import random
import re
import sys
import yaml

default_args = {
    'seed': random.randint(9999, 9_999_999),
    'tui': False,
    'workspace-path': '/root/easy-train-data',
    'build-engine-arch': 'x86-64-bmi2',
    'network-testing-book': 'https://github.com/official-stockfish/books/raw/master/UHO_Lichess_4852_v1.epd.zip',
}

yaml_config_file = sys.argv[1]
with open(yaml_config_file, "r") as stream:
    try:
        args = yaml.safe_load(stream)
        args = {**default_args, **args}

        # if config filename contains gpu ids, automatically use them
        gpus_from_filename = re.search(r"gpu(\d+)", yaml_config_file)
        if gpus_from_filename:
            gpus_str = ",".join(list(gpus_from_filename.group(1)))
            args["gpus"] = gpus_str

        # prepare an easy_train.py command for training
        command = ["python3 easy_train.py"]
        for key,value in sorted(args.items()):
            if key == "training-dataset" and isinstance(value, list):
                for dataset_component in value:
                    command.append(f"  --{key} {dataset_component}")
            else:
                command.append(f"  --{key} {value}")

        if len(sys.argv) > 2 and sys.argv[2] == "print":
            print(" \\\n".join(command))
        else:
            print(" ".join(command))
    except yaml.YAMLError as exc:
        print(exc)
