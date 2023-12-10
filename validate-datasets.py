import random
import re
import subprocess
import sys
import yaml

yaml_config_file = sys.argv[1]
with open(yaml_config_file, "r") as f:
    try:
        config = yaml.safe_load(f)
    except yaml.YAMLError as exc:
        print(exc)

dataset_components = []
for key,value in sorted(config.items()):
    if key == "training-dataset":
        if isinstance(value, list):
            for dataset_component in value:
                dataset_components.append(dataset_component)
        else:
            dataset_components.append(value)

# print(dataset_components)
print(subprocess.check_output(['du', '-hsc'] + dataset_components).decode().strip())
