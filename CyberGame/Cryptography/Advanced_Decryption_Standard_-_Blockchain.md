# Advanced Decryption Standard - Blockchain

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Advanced Decryption Standard - Blockchain | Cryptography  | SK-CERT{cbc_m0d3_15_n3x7} | super easy (0 filled stars) |

## Description
EN: You can’t, for the life of you, remember why each flag ended up with a different chaining method. Must’ve been one heck of a night...

This file contains the flag encrypted using AES with mode CBC.

key (hex format): 00000000000000000000000000000000 iv (hex format): 01020304050607080102030405060708

## Attachments
cbc.dat

## Solution
By going to cyberchef and using the AES CBC decryption with the key and iv, we can decrypt the file and get the flag.
