# Adversary - Key exchange

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Adversary - Key exchange | Cryptography  | SK-CERT{d1ff13_h3llm4n_15_n07_7h47_51mpl3_l0l} | easy (1 filled star) |

## Description
The adversary started using a new algorithm for key exchange. We were able to get its schema from our source. We attach the communication where we suspect the adversary might be agreeing upon a key and then using the 3AES encryption we've seen previously.

## Attachments
exchange.png
messages.txt

![Exchange.png](images/Exchange.png)

## Solution
By looking at the image I was able to figure out how they konstructed the key:

- Step 1: X → Y sends S1 ⊕ Key 
- Step 2: Y → X sends S2 ⊕ S1 ⊕ Key
- Step 3: X → Y sends S2 ⊕ Key

At the end the key is `Key = (S2 ⊕ Key) ⊕ S2`

Then I wrote a script that XORs the messages and gets the key. The script is as follows:

```python
from base64 import b64decode

def xor_bytes(a: bytes, b: bytes) -> bytes:
    return bytes(x ^ y for x, y in zip(a, b))

X1_b64 = "tL90zeX19A2CLF9PH9oMQEuAPURmv7rp+oQ/DWiXEwTTQ6Ry/yDBHgqBGAa+OCaoI5JfdGYqhM2SHCWQyVdKJPj8HTY3gkxG38JEaET+CgX7h3cPQrufwYG8UOH6scrk1+guWvLOIAb/VJZ7pbjnEeORtN9C91EvxhNAO7r9pSFczo2TCGyFSaNOsvzN6C88Gw+4eXMTtVw="
Y1_b64 = "mBpf0ZTjWUczik9rrfwdM4wgVrN4I+++PGQSctBkAliziynxXJxYT0KnWxf5q8f1utv9ERPaWsJ+e/fENymhCWELXAnXGFaF8LHLzl9N1TWxu4b1CPPsU2pi2Rar9pm9FLfN4x/yYfP7daqKD7Rvq67wRu9+jsrgQKFj7687mZA4I9s11NpQQ7TSrEVr8Xx0d8FIZsV4x9M="
X2_b64 = "R8BSLUs24ieC8nV22ER/HYDYE7ltrz548dNMJeC+SwsOrcXFmuTdYHlSCnor9NU28nSoDhCJ7DXMDL5gzEiPWsikIgeM30CNfyH2ny/A6H0eZrOyLiEK8ZOS79hoFDsbiA3IidA2KpB9EgbRz1vRzXoOsAhUTa27/Px3nlCOboZRhXnTruzsPnKpWYjvXRQLKKW/d4Y4BbI="

X1 = b64decode(X1_b64)
Y1 = b64decode(Y1_b64)
X2 = b64decode(X2_b64)

# Y1 ⊕ X1
S2 = xor_bytes(Y1, X1)

# X2 ⊕ S2
Key = xor_bytes(X2, S2)

print("Derived AES Key (hex):", Key.hex())
print("UTF-8 Decoded Key:", Key.decode('utf-8'))
```

When I ran the script I got the following output:
```
[+] Derived AES Key (hex): 6b6579313a204f6d335465526a626e6e4778784e73336b2f3733615a584d5a576e654846395844313174496b6c67346b6b3d0a6b6579323a206b6c3432366477515363386c455a4e505279393473374d545a424864697963784c662f395368424b522b303d0a6b6579333a2065575977376f4238683436747a4e544a4548523735682f75725a39346535473149444743446b4f683053773d
[+] UTF-8 Decoded Key: key1: Om3TeRjbnnGxxNs3k/73aZXMZWneHF9XD11tIklg4kk=
key2: kl426dwQSc8lEZNPRy94s7MTZBHdiycxLf/9ShBKR+0=
key3: eWYw7oB8h46tzNTJEHR75h/urZ94e5G1IDGCDkOh0Sw=
```

I then used the 3 keys and my script from the [Adversary - 3AES](Adversary_-_3AES.md) challenge to decrypt the messages. This then produced the following output:
```
=== Permutation 6 Order [3, 2, 1], Mode D-E-D ===
They were there again.  Exchanging keys in the plaintext is not something a sensible person would do! We cannot make rookie mistakes like this again. The key exchange algo I made is 100% secure as it's based on Diffie Hellman.
Okay Mr. Robot. Since they've busted all our people I'll be waiting for you on the corner of Priehradna and Modricova tomorrow at 15:30
Agreed. SK-CERT{d1ff13_h3llm4n_15_n07_7h47_51mpl3_l0l}
```

The flag is `SK-CERT{d1ff13_h3llm4n_15_n07_7h47_51mpl3_l0l}`.