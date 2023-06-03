import yaml

with open("config.yml", "r") as stream:
    try:
        args = yaml.safe_load(stream)
        command = ["python3 easy_train.py"]
        for key,value in sorted(args.items()):
            command.append(f"  --{key} {value}")
        print(" \\\n".join(command))
    except yaml.YAMLError as exc:
        print(exc)
