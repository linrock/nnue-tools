import hashlib
import os
import secrets
import sys

if len(sys.argv) != 3:
    print('Usage: ./edit_random_bytes.py <nnue_filename> <sha256_prefix>')
    sys.exit(0)

nnue_filename = sys.argv[1]
sha256_prefix = sys.argv[2]

def read_chunks(f, chunk_size=16384):
    while True:
        data = f.read(chunk_size)
        if not data:
            break
        yield data

def get_sha256_hash(nnue_filename):
    hasher = hashlib.sha256()
    for chunk in read_chunks(open(nnue_filename, "rb")):
        hasher.update(chunk)
    return hasher.hexdigest()

def random_non_functional_edit(nnue_filename):
    with open(nnue_filename, "r+b") as f:
        f.seek(33) # the
        f.write(secrets.token_bytes(3))
        f.seek(79) # trainer
        f.write(secrets.token_bytes(7))


print(f'Modifying {nnue_filename} to have sha256 prefix: {sha256_prefix}')
num_tries = 0
sha256 = get_sha256_hash(nnue_filename)
while not sha256.startswith(sha256_prefix):
    random_non_functional_edit(nnue_filename)
    sha256 = get_sha256_hash(nnue_filename)
    num_tries += 1
    if num_tries % 100 == 0:
        print(f'Tried {num_tries} times')

print(f'Found {sha256} after {num_tries} tries')
new_nnue_filename = f'nn-{sha256[:12]}.nnue'
print(f'Renaming from {nnue_filename} to {new_nnue_filename}')
os.rename(nnue_filename, new_nnue_filename)
