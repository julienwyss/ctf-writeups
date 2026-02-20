# Adversary - 3AES

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Adversary - 3AES | Cryptography  | SK-CERT{1_w0nd3r_why_th3y_d0nt_us3_7h1s_1rl} | easy (1 filled star) |

## Description
We have intercepted a ciphertext along with a presumed key exchange in plaintext. Our sources informed us that the adversary is using a custom-made cipher they call "3AES".

## Attachments
intercept.txt

Content:
```
key1: h+NvKyaJFRhpn7lRWo0JGGcSk7TOd2ltibSSI1CGDCk=
key2: CznIYU0rBgmzSb7WyqYfj+WKyDSXbbnsa8Wp/IRvUOc=
key3: ihpLsXPURUTwH4ULO9/87rHRCQibQO6+V4/QKJL7Bgg=

Y: rOkz0hogqrrjVXe8KhfwPmTXqy0NI5BaaVRwg8g4490Gi//XIIYY6t7pMpw/0DN4V26tcdwmmOOne75oEt4/oQ==
X: t+WZSn6H1mA9XUQJrQ2xxt33nVh6orKFygb7Q+8xMe9JSk7XgMdZ8Fwq9rSMw9SuCZWoIJ8qYOSOKwmyyvMmW7/kkPDoWNEezfme08HmEWi3DrPAefIpNVVewbfVzt5j
Y: dNMxxcWRHkxNxHu17gw5g5IE/Jf6tNmxw4OfBHEXfRv0cx4pKVKYjZofSRAgFspLnWcdR5GGasKxCgpOANPyS4liypMrPFKlXy/pm2BG7bM=
X: k8JzsMNxiG5KPGSdM/YjGjW7y8dzgG8vsQ3RB062Kz1/EzwUaWz5Sr2UFNuq0jcWqDdj3Y9I0UKz0rYdZuTxMHZ+oKVEqI8Xv9CuvOmOzkdBoBgsjaWT9ke6+BPcMH9Kpwq/jgoYVQ7SfJDKx5GCAxzSLyyS6tXGIZRrUny6jiU=
```

## Solution

I wrote a script to try different combinations of decrypting and encrypting the ciphertext with the keys. It then checks if the result contains the flag format. The script is as follows:

```python
from Crypto.Cipher import AES
from base64 import b64decode
from itertools import permutations, product
import re

FLAG_FORMAT = "SK-CERT{.*}"

def unpad(padded):
    """Remove PKCS7 padding if valid"""
    pad_len = padded[-1]
    if pad_len <= 16 and all(p == pad_len for p in padded[-pad_len:]):
        return padded[:-pad_len]
    return padded

def apply_aes(data, key, direction):
    """Apply AES-ECB encrypt or decrypt"""
    cipher = AES.new(key, AES.MODE_ECB)
    return cipher.encrypt(data) if direction == 'E' else cipher.decrypt(data)

def decrypt_custom(ciphertext, key_order, directions):
    """Apply AES in custom order and direction"""
    data = ciphertext
    for key, direction in zip(key_order, directions):
        data = apply_aes(data, key, direction)
    try:
        return unpad(data).decode('utf-8')
    except UnicodeDecodeError:
        return f"[utf-8 decode error] {unpad(data).hex()}"
    except Exception as e:
        return f"[error: {e}] {data.hex()}"


key1 = b64decode("h+NvKyaJFRhpn7lRWo0JGGcSk7TOd2ltibSSI1CGDCk=")
key2 = b64decode("CznIYU0rBgmzSb7WyqYfj+WKyDSXbbnsa8Wp/IRvUOc=")
key3 = b64decode("ihpLsXPURUTwH4ULO9/87rHRCQibQO6+V4/QKJL7Bgg=")
keys = [key1, key2, key3]


cipher_b64_list = [
    "rOkz0hogqrrjVXe8KhfwPmTXqy0NI5BaaVRwg8g4490Gi//XIIYY6t7pMpw/0DN4V26tcdwmmOOne75oEt4/oQ==",
    "t+WZSn6H1mA9XUQJrQ2xxt33nVh6orKFygb7Q+8xMe9JSk7XgMdZ8Fwq9rSMw9SuCZWoIJ8qYOSOKwmyyvMmW7/kkPDoWNEezfme08HmEWi3DrPAefIpNVVewbfVzt5j",
    "dNMxxcWRHkxNxHu17gw5g5IE/Jf6tNmxw4OfBHEXfRv0cx4pKVKYjZofSRAgFspLnWcdR5GGasKxCgpOANPyS4liypMrPFKlXy/pm2BG7bM=",
    "k8JzsMNxiG5KPGSdM/YjGjW7y8dzgG8vsQ3RB062Kz1/EzwUaWz5Sr2UFNuq0jcWqDdj3Y9I0UKz0rYdZuTxMHZ+oKVEqI8Xv9CuvOmOzkdBoBgsjaWT9ke6+BPcMH9Kpwq/jgoYVQ7SfJDKx5GCAxzSLyyS6tXGIZRrUny6jiU="
]
ciphertexts = [b64decode(cipher) for cipher in cipher_b64_list]

for i, key_perm in enumerate(permutations(keys), 1):
    for j, directions in enumerate(product("ED", repeat=3), 1):
        dir_str = '-'.join(directions)
        order_str = [keys.index(k) + 1 for k in key_perm]
        results = []

        for ciphertext in ciphertexts:
            result = decrypt_custom(ciphertext, key_perm, directions)
            results.append(result)

        if any(re.search(FLAG_FORMAT, result) for result in results):
            print(f"\n=== Permutation {i} Order {order_str}, Mode {dir_str} ===")
            for result in results:
                print(result)

```

Output of the script:
```
=== Permutation 6 Order [3, 2, 1], Mode D-E-D ===
The meeting was compromised. They were waiting for us.
It should be fine now. We switched to a custom cipher based on the AES standard.
FINE but if this fails again I pick the crypto we use! What is the drop point?
We had to flee. Our guy will wait for you near Slavin. Come right at noon. SK-CERT{1_w0nd3r_why_th3y_d0nt_us3_7h1s_1rl}
```

The flag is SK-CERT{1_w0nd3r_why_th3y_d0nt_us3_7h1s_1rl}
