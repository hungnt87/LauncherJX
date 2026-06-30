import os
import hashlib
import json
import zipfile
import sys
import argparse

def get_sha256(file_path):
    sha256 = hashlib.sha256()
    try:
        with open(file_path, 'rb') as f:
            while chunk := f.read(8192):
                sha256.update(chunk)
        return sha256.hexdigest()
    except Exception as e:
        print(f"Error hashing {file_path}: {e}")
        return None

def zip_directory(dir_path, zip_path, rel_root):
    try:
        with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, dirs, files in os.walk(dir_path):
                for file in files:
                    abs_path = os.path.join(root, file)
                    rel_path = os.path.relpath(abs_path, rel_root).replace('\\', '/')
                    zipf.write(abs_path, rel_path)
        print(f"Compressed directory {dir_path} -> {zip_path}")
    except Exception as e:
        print(f"Error compressing {dir_path}: {e}")

def generate_manifest(patch_dir, version, updater_path=None, updater_name="updater.exe", launcher_path=None):
    manifest = {
        "version": version,
        "files": []
    }
    
    # 0. Thêm metadata cho updater nếu được cung cấp
    if updater_path:
        if os.path.exists(updater_path):
            updater_hash = get_sha256(updater_path)
            if updater_hash:
                manifest["updater"] = {
                    "name": updater_name,
                    "hash": updater_hash
                }
                print(f"Added updater metadata: {updater_name} ({updater_hash})")
            else:
                print(f"Warning: Failed to compute hash for updater at {updater_path}")
        else:
            print(f"Warning: Updater path '{updater_path}' does not exist.")

    # 0b. Thêm thông tin LauncherJX.exe vào danh sách files nếu được cung cấp
    if launcher_path:
        if os.path.exists(launcher_path):
            launcher_hash = get_sha256(launcher_path)
            if launcher_hash:
                manifest["files"].append({
                    "name": "LauncherJX.exe",
                    "hash": launcher_hash,
                    "zip": ""
                })
                print(f"Added LauncherJX.exe to manifest files: {launcher_hash}")
            else:
                print(f"Warning: Failed to compute hash for launcher at {launcher_path}")
        else:
            print(f"Warning: Launcher path '{launcher_path}' does not exist.")

    # 1. Quét và nén các thư mục con cấp 1

    zips_dir = os.path.abspath(os.path.join(patch_dir, "..", "zips"))
    os.makedirs(zips_dir, exist_ok=True)

    for item in os.listdir(patch_dir):
        sub_dir_path = os.path.join(patch_dir, item)
        if os.path.isdir(sub_dir_path):
            sub_dir = item
            if sub_dir.startswith('.') or sub_dir == "tmp":
                continue
                
            zip_path = os.path.join(zips_dir, f"{sub_dir}.zip")
            zip_directory(sub_dir_path, zip_path, patch_dir)
            
            ignored_files = {"config.ini", "jx1mod.ini", "package.ini"}
            
            # Quét các file trong thư mục con này để tính hash và add vào manifest
            for root, dirs, files in os.walk(sub_dir_path):
                for file in files:
                    if file.lower() in ignored_files:
                        continue
                    abs_path = os.path.join(root, file)
                    rel_path = os.path.relpath(abs_path, patch_dir).replace('\\', '/')
                    sha = get_sha256(abs_path)
                    if sha:
                        manifest["files"].append({
                            "name": rel_path,
                            "hash": sha,
                            "zip": f"{sub_dir}.zip"
                        })
                        
    # 2. Quét các file lẻ nằm trực tiếp ở thư mục gốc và nén thành root.zip
    root_files = []
    for item in os.listdir(patch_dir):
        abs_path = os.path.join(patch_dir, item)
        if os.path.isfile(abs_path):
            file = item
            if file == "version.json" or file.endswith(".zip"):
                continue
            root_files.append(item)

    if root_files:
        root_zip_path = os.path.join(zips_dir, "root.zip")
        import zipfile
        try:
            with zipfile.ZipFile(root_zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
                for file in root_files:
                    abs_path = os.path.join(patch_dir, file)
                    zipf.write(abs_path, file)
            print(f"Compressed root files to {root_zip_path}")

            # Thêm các file lẻ này vào manifest với trường "zip": "root.zip"
            for file in root_files:
                abs_path = os.path.join(patch_dir, file)
                sha = get_sha256(abs_path)
                if sha:
                    manifest["files"].append({
                        "name": file,
                        "hash": sha,
                        "zip": "root.zip"
                    })
        except Exception as e:
            print(f"Error compressing root files to zip: {e}")
                
    manifest["files"].sort(key=lambda x: x["name"])
    
    # Lưu version.json ra ngoài cùng cấp với thư mục dự án (bên ngoài thư mục patch)
    manifest_path = os.path.abspath(os.path.join(patch_dir, "..", "version.json"))
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
    
    print(f"Manifest generated successfully at {manifest_path} with {len(manifest['files'])} files.")


if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    patch_dir = os.path.abspath(os.path.join(script_dir, "..", "patch"))
    
    if not os.path.exists(patch_dir):
        print(f"Error: Path '{patch_dir}' does not exist.")
        # Nếu không có thư mục patch, thử tạo mới
        try:
            os.makedirs(patch_dir)
            print(f"Created patch directory at '{patch_dir}'.")
        except Exception as e:
            print(f"Could not create patch directory: {e}")
            exit(1)
            
    version_file = os.path.abspath(os.path.join(patch_dir, "..", "version.json"))
    old_version = "v1.0.0"
    if os.path.exists(version_file):
        try:
            with open(version_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                old_version = data.get("version", "v1.0.0")
        except Exception as e:
            print(f"Warning reading current version.json: {e}")

            
    print(f"Thu muc patch phat hien tai: {patch_dir}")
    
    parser = argparse.ArgumentParser(description="Generate manifest version.json for LauncherJX")
    parser.add_argument("version", nargs="?", default=None, help="New version tag")
    parser.add_argument("--updater-path", default=None, help="Path to updater.exe binary to hash")
    parser.add_argument("--updater-name", default="updater.exe", help="Name of the updater asset")
    parser.add_argument("--launcher-path", default=None, help="Path to LauncherJX.exe binary to include in files manifest")
    
    args = parser.parse_args()
    
    new_version = args.version
    if not new_version:
        # Nếu chạy không có đối số version, hỏi người dùng
        new_version = input(f"Nhap phien ban moi (Nhan Enter de giu nguyen [{old_version}]): ").strip()
        if not new_version:
            new_version = old_version
    else:
        new_version = new_version.strip()
        print(f"Su dung phien ban tu dong lenh: {new_version}")
        
    generate_manifest(patch_dir, new_version, updater_path=args.updater_path, updater_name=args.updater_name, launcher_path=args.launcher_path)


