## Stockfish NNUE trainer

A containerized linux environment for training Stockfish NNUE with
[nnue-pytorch](https://github.com/glinscott/nnue-pytorch).

To use this, make sure Nvidia drivers, [Docker](https://docs.docker.com/engine/install/),
and the [Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) are installed.

The container image is an Ubuntu environment with Cuda, Torch,
and all the necessary dependencies for running nnue-pytorch.

```bash
./docker_build.sh   # builds an image with a working nnue-pytorch environment
./docker_run.sh     # access the command-line within the container
```

### Download data files

See training data files in this PR:
https://github.com/official-stockfish/Stockfish/pull/4100


### Download large data files from Google Drive via cmd-line

- Go to [OAuth 2.0 Playground](https://developers.google.com/oauthplayground/)
- In the "Input your own scopes" text box, enter in:
  - `https://www.googleapis.com/auth/drive.readonly`
- Click Authorize APIs and then click "Exchange authorization code for tokens"
- Copy the access token

```bash
curl -H "Authorization: Bearer <access_token>" \
  "https://www.googleapis.com/drive/v3/files/<file_id>?alt=media \
  -o output.binpack
```
