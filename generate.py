import os
import sys
import json

if __name__ == "__main__":
    current_dir: str = os.getcwd()

    # contains snippets for each language
    src_dir: str = os.path.join(current_dir, "src")
    if (not os.path.isdir(src_dir)):
        print("{d} does not exist!".format(d=src_dir))
        sys.exit(1)

    # target for the json files per language
    out_dir: str = os.path.join(current_dir, "out")
    if (not os.path.isdir(out_dir)):
        print("{d} does not exist!".format(d=out_dir))
        sys.exit(1)

    # optional file containing path to vscode snippet directory for output
    _filename = "snippets.path"
    _file = os.path.join(current_dir, _filename)
    vsc_snippets_dir = None
    if (os.path.isfile(_file)):
        with open(_file) as f:
            vsc_snippets_dir = f.readline().rstrip("\n")
            if (not os.path.isdir(vsc_snippets_dir)):
                print("! {d} does not exist".format(d=vsc_snippets_dir))
                sys.exit(1)
    else:
        print("(Tip: Create ./{n} containing the path to your vscode snippets folder)".format(n=_filename))


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
            out_map = {}
            for file in file_map:
                file_without_type = file.split('.')[0]
                out_map[file_without_type] = {
                    "prefix": file_without_type,
                    "description": file_without_type,
                    "body": file_map[file],
                }

            out_path = os.path.join(out_dir, dir) + ".json"
            print(" = Writing snippet to {o}".format(o=out_path))
            with open(out_path, 'w') as out_file:
                out_file.write(json.dumps(out_map, indent=2))

            vsc_path = None if vsc_snippets_dir is None else os.path.join(vsc_snippets_dir, dir) + ".json"
            if (vsc_path is not None):
                print(" = Writing snippet to {o}".format(o=vsc_path))
                with open(vsc_path, 'w') as out_file:
                    out_file.write(json.dumps(out_map, indent=2))
                    

            


