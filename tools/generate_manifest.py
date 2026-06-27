import os
import hashlib
import json

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

def generate_manifest(patch_dir, version):
    manifest = {
        "version": version,
        "files": []
    }
    
    for root, dirs, files in os.walk(patch_dir):
        for file in files:
            if file == "version.json":
                continue
            
            abs_path = os.path.join(root, file)
            rel_path = os.path.relpath(abs_path, patch_dir).replace('\\', '/')
            sha = get_sha256(abs_path)
            
            if sha:
                manifest["files"].append({
                    "name": rel_path,
                    "hash": sha
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
            
    import sys
    print(f"Thu muc patch phat hien tai: {patch_dir}")
    if len(sys.argv) > 1:
        new_version = sys.argv[1].strip()
        print(f"Su dung phien ban tu dong lenh: {new_version}")
    else:
        new_version = input(f"Nhap phien ban moi (Nhan Enter de giu nguyen [{old_version}]): ").strip()
        if not new_version:
            new_version = old_version
        
    generate_manifest(patch_dir, new_version)
