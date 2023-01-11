import os
import sys
import json

if __name__ == "__main__":
    current_dir: str = os.getcwd()

    src_dir: str = os.path.join(current_dir, "src")
    if (not os.path.isdir(src_dir)):
        print("{d} does not exist!".format(d=src_dir))
        sys.exit(1)

    out_dir: str = os.path.join(current_dir, "out")
    if (not os.path.isdir(out_dir)):
        print("{d} does not exist!".format(d=out_dir))
        sys.exit(1)

    for _, dirs, __ in os.walk(src_dir):
        for dir in dirs:
            print("[{d}] Generating map from files...".format(d=dir))
            file_map = {}
            dir_path = os.path.join(src_dir, dir)
            for _, __, files in os.walk(dir_path):
                for file in files:
                    print(" > {f}".format(f=file))
                    file_path = os.path.join(dir_path, file)
                    with open(file_path) as f:
                        lines = f.read().splitlines()
                        file_map[file] = lines

            print(" = Generating single json from src snippets ...")
            out_path = os.path.join(out_dir, dir) + ".json"
            out_map = {}
            for file in file_map:
                file_without_type = file.split('.')[0]
                out_map[file_without_type] = {
                    "prefix": file_without_type,
                    "description": file_without_type,
                    "body": file_map[file],
                }

            print(" = Writing snippet to {o}".format(o=out_path))
            with open(out_path, 'w') as out_file:
                out_file.write(json.dumps(out_map, indent=2))
                    

            


