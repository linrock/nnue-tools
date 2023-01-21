import hashlib
from multiprocessing import Process
import secrets
import sys

if len(sys.argv) != 3:
    print('Usage: ./twin_miner.py <nnue_filename> <hex_word_list>')
    sys.exit(0)

def get_nnue_data(nnue_filename):
    with open(nnue_filename, 'rb') as f:
        return bytearray(f.read())

def random_non_functional_edit(nnue_data):
    for i in range(33, 36):  # the
        nnue_data[i] = list(secrets.token_bytes(1))[0]
    for i in range(79, 85):  # traine
        nnue_data[i] = list(secrets.token_bytes(1))[0]

def get_sha256_hash(nnue_data):
    h = hashlib.sha256()
    h.update(nnue_data)
    return h.hexdigest()

def find_variants(nnue_filename, hex_word_list):
    print(f'Searching for {nnue_filename} variants with sha256 matching {len(hex_word_list)} words')
    nnue_data = get_nnue_data(nnue_filename)
    num_tries = 0
    while True:
        random_non_functional_edit(nnue_data)
        sha256 = get_sha256_hash(nnue_data)
        sha256_prefix = sha256[:12]
        num_tries += 1
        if any(word in sha256_prefix for word in hex_word_list):
            print(f'Found {sha256_prefix} after {num_tries} tries')
            new_nnue_filename = f'nn-{sha256_prefix}.nnue'
            print(f'Writing nnue data to {new_nnue_filename}')
            with open(new_nnue_filename, 'wb') as f:
                f.write(nnue_data)
        elif num_tries % 100 == 0:
            print(f'Tried {num_tries} times')

nnue_filename = sys.argv[1]
hex_word_list = open(sys.argv[2], 'r').read().strip().split('\n')
processes = [
    Process(target=find_variants, args=(nnue_filename, hex_word_list)) for i in range(4)
]
for p in processes:
    p.start()
for p in processes:
    p.join()
