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
    generate_manifest("d:/1.DEV/2026/LauncherJX/patch", "v1.0.0")
