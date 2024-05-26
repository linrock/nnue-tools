# Stockfish NNUE trainer

A containerized linux environment for training Stockfish NNUE with
[nnue-pytorch](https://github.com/glinscott/nnue-pytorch).

The container image is Ubuntu 22.04 LTS with Cuda, Torch,
and all the necessary dependencies for running nnue-pytorch
installed.


## Installing on Ubuntu 20.04 hosts

To use this, make sure Nvidia drivers, [Docker](https://docs.docker.com/engine/install/),
and the [Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) are installed.

See [server_setup.sh](./server_setup.sh) for commands to install dependencies
from a clean Ubuntu server environment, should be run with sudo rights.
This will enable docker as a non-root user, as described here
https://docs.docker.com/engine/install/linux-postinstall/.

Afterwards, use these scripts to prepare and run the container image.

```bash
./docker_build.sh   # builds an image with a working nnue-pytorch environment
./docker_run.sh     # access the command-line within the container
```

The following files will be copied into the container image:
```
requirements.txt
yaml_easy_train.py
.bash_profile
misc/utils.sh
misc/get_native_properties.sh
easy-train.sh
fetch-nnue.sh
```


### Running the container

A few directories are mounted into the container to share data between the host and container.

```
training-data
easy-train-data
config

/dev/shm
/mnt
```

There are multiple ways to get your training data into the container:

- `/dev/shm` is a shared memory directory where files can temporarily be stored for fast access.
- `/mnt` typically for mounting a large storage volume, like an external hard drive.
- `training-data` and `easy-train-data` can also be used to store training data, though their primary purpose is binpack scripts and the directory structure for nnue-pytorch, respectively.
- `/media` is a directory that can be used to mount external storage devices as well.


### Download training data

See training data files in this July 2022 PR:
https://github.com/official-stockfish/Stockfish/pull/4100 or https://www.kaggle.com/linrock/datasets.

Info on how the training data is generated is in the [nnue-pytorch wiki](https://github.com/glinscott/nnue-pytorch/wiki/Training-datasets#lc0-data-converter).

Use this [interleave_binpacks.py](https://github.com/official-stockfish/Stockfish/blob/tools/script/interleave_binpacks.py) script to
mix downloaded `.binpack` files together to prepare training data.


##### Download large data files from Google Drive via cmd-line

- Go to [OAuth 2.0 Playground](https://developers.google.com/oauthplayground/)
- In the "Input your own scopes" text box, enter in:
  - `https://www.googleapis.com/auth/drive.readonly`
- Click Authorize APIs and then click "Exchange authorization code for tokens"
- Copy the access token

```bash
curl -H "Authorization: Bearer <access_token>" \
  "https://www.googleapis.com/drive/v3/files/<file_id>?alt=media" \
  -o output.binpack
```

##### Download datasets from kaggle

- Install `kaggle`
  ```
  pipx install kaggle
  ```
- Go to https://www.kaggle.com/<USER_NAME>/account
- Create a New API Token in the "API" section
- place your downloaded file at ~/.kaggle/kaggle.json
- `kaggle datasets download linrock/<DATASET_NAME>`
