## Stockfish NNUE trainer

A containerized linux environment for training Stockfish NNUE with
[nnue-pytorch](https://github.com/glinscott/nnue-pytorch).

Make sure Nvidia drivers, [Docker](https://docs.docker.com/engine/install/),
and the [Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) are installed.


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
