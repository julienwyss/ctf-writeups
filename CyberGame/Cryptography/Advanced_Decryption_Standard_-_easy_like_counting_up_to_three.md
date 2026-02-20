# Advanced Decryption Standard - easy like counting up to three

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Advanced Decryption Standard - easy like counting up to three | Cryptography  | SK-CERT{4nd_7h3_l457_15_c7r} | super easy (0 filled stars) |

## Description
EN: The math of this is beyond your comprehension, but you just know this file contains a third flag, encrypted using AES with CTR (counter) mode.

key (hex format): 11111111111111111111111111111111 iv (hex format): 99999999999999999999999999999999

## Attachments
ctr.dat

## Solution
By going to cyberchef and using the AES CTR decryption with the key and iv, we can decrypt the file and get the flag.