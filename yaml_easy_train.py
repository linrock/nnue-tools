import random
import sys
import yaml

default_args = {
    'seed': random.randint(9999, 9_999_999),
    'tui': False,
}

with open(sys.argv[1], "r") as stream:
    try:
        args = yaml.safe_load(stream)
        args = {**default_args, **args}
        command = ["python3 easy_train.py"]
        for key,value in sorted(args.items()):
            command.append(f"  --{key} {value}")
        if len(sys.argv) > 2 and sys.argv[2] == "print":
            print(" \\\n".join(command))
        else:
            print(" ".join(command))
    except yaml.YAMLError as exc:
        print(exc)
