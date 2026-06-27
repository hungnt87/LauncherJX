import os
import hashlib
import json
import zipfile
import sys

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

def generate_manifest(patch_dir, version):
    manifest = {
        "version": version,
        "files": []
    }
    
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
            
            # Quét các file trong thư mục con này để tính hash và add vào manifest
            for root, dirs, files in os.walk(sub_dir_path):
                for file in files:
                    abs_path = os.path.join(root, file)
                    rel_path = os.path.relpath(abs_path, patch_dir).replace('\\', '/')
                    sha = get_sha256(abs_path)
                    if sha:
                        manifest["files"].append({
                            "name": rel_path,
                            "hash": sha,
                            "zip": f"{sub_dir}.zip"
                        })
                        
    # 2. Quét các file lẻ nằm trực tiếp ở thư mục gốc (không nén)
    for item in os.listdir(patch_dir):
        abs_path = os.path.join(patch_dir, item)
        if os.path.isfile(abs_path):
            file = item
            if file == "version.json" or file.endswith(".zip"):
                continue
            sha = get_sha256(abs_path)
            if sha:
                manifest["files"].append({
                    "name": file,
                    "hash": sha,
                    "zip": ""
                })
                
    manifest["files"].sort(key=lambda x: x["name"])
    
    manifest_path = os.path.join(patch_dir, "version.json")
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
            
    version_file = os.path.join(patch_dir, "version.json")
    old_version = "v1.0.0"
    if os.path.exists(version_file):
        try:
            with open(version_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                old_version = data.get("version", "v1.0.0")
        except Exception as e:
            print(f"Warning reading current version.json: {e}")
            
    print(f"Thu muc patch phat hien tai: {patch_dir}")
    if len(sys.argv) > 1:
        new_version = sys.argv[1].strip()
        print(f"Su dung phien ban tu dong lenh: {new_version}")
    else:
        new_version = input(f"Nhap phien ban moi (Nhan Enter de giu nguyen [{old_version}]): ").strip()
        if not new_version:
            new_version = old_version
        
    generate_manifest(patch_dir, new_version)
