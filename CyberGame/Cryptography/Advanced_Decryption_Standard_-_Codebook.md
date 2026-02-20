# Advanced Decryption Standard - Codebook

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Advanced Decryption Standard - Codebook | Cryptography  | SK-CERT{f1r57_15_3cb} | super easy (0 filled stars) |

## Description
EN: You know that feeling—waking up after a wild night of gambling, pockets full of keys you’re sure are yours, but somehow every single one feels wrong, and you can’t, for the life of you, remember which one fits where, or even what it’s supposed to unlock?

Now imagine being a novice cryptographer after that same night. You’ve got the keys—sure—but absolutely no clue what they open, how they work, or why you even have them in the first place. Welcome to the hangover of cryptography.

You think this file should contain a flag encrypted using... AES? Also, the letters ECB come to mind although you don’t know what it is. The flag should be in the usual format SK-CERT{something}.

key (hex format): 00000000000000000000000000000000

## Attachments
ecb.dat
## Solution
By going to cyberchef and using the AES ECB decryption with the key and the mode ECB, we can decrypt the file and get the flag.