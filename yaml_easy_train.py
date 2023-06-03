import random
import yaml

default_args = {
    'seed': random.randint(9999, 9_999_999),
    'tui': False,
}

with open("config.yml", "r") as stream:
    try:
        args = yaml.safe_load(stream)
        args = {**default_args, **args}
        command = ["python3 easy_train.py"]
        for key,value in sorted(args.items()):
            command.append(f"  --{key} {value}")
        print(" \\\n".join(command))
    except yaml.YAMLError as exc:
        print(exc)
