import random
import re
import sys
import yaml

GPU_ID = 0

yaml_config_file = sys.argv[1]
with open(yaml_config_file, "r") as f:
    try:
        exp_sequence_config = yaml.safe_load(f)
    except yaml.YAMLError as exc:
        print(exc)

# print(config)
for i,exp in enumerate(exp_sequence_config["experiments"]):
    config = {
        **exp_sequence_config["common"],
        **exp,
    }
    if i > 0:
        prev_exp = exp_sequence_config["experiments"][i-1]
        prev_exp_name = prev_exp["experiment-name"]
        epoch = prev_exp["num-epochs"] - 1
        path = f"/root/easy-train-data/experiments/experiment_{prev_exp_name}/training/run_{GPU_ID}/nn-epoch{epoch}.nnue"
        config["start-from-model"] = path
    print(exp["experiment-name"])
    print(config)
    with open(f"gpu{GPU_ID}-{exp['experiment-name']}.yaml", "w") as f:
        yaml.dump(config, f)
