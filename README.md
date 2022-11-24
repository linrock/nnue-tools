## Stockfish NNUE trainer

A Docker image for training Stockfish NNUE with nnue-pytorch

Trainer for Stockfish NNUE
https://github.com/glinscott/nnue-pytorch


### Download data files

See data files in this PR:
https://github.com/official-stockfish/Stockfish/pull/4100


### Download large data files from Google Drive

- Go to OAuth 2.0 Playground https://developers.google.com/oauthplayground/
- In the Select the Scope box, paste https://www.googleapis.com/auth/drive.readonly
- Click Authorize APIs and then Exchange authorization code for tokens
- Copy the Access token

```bash
curl -H "Authorization: Bearer <token>" \
  "https://www.googleapis.com/drive/v3/files/<file_id>?alt=media \
  -o output.binpack
```
