# Eugene's FATigue  Was that the only file?

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Eugenes FATigue  Was that the only file | Forensics  | SK-CERT{R3c0V3r3D_R3cip3} | medium (2 filled stars) |

## Description
You have a persistent feeling there must be more to it. We are still searching for Gene's recipe. Keep recovering.

## Attachments
diskimage.bin.gz -> diskimage.bin
(This is a follow-up challenge to Eugene's FATigue - FATigue)

## Solution

After looking at the diskimage.bin with `binwalk`:
```
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------

WARNING: Extractor.execute failed to run external extractor 'jar xvf '%e'': [Errno 2] No such file or directory: 'jar', 'jar xvf '%e'' might not be installed correctly
1630720       0x18E200        Zip archive data, at least v2.0 to extract, compressed size: 130929, uncompressed size: 130936, name: file
1761711       0x1AE1AF        Zip archive data, at least v2.0 to extract, compressed size: 776, uncompressed size: 1262, name: fifth.txt
1766068       0x1AF2B4        JPEG image data, EXIF standard
1766080       0x1AF2C0        TIFF image data, big-endian, offset of first image directory: 8
1879290       0x1CACFA        Zip archive data, at least v2.0 to extract, compressed size: 653, uncompressed size: 825, name: fourth-flag.aes.b64.txt
1880270       0x1CB0CE        End of Zip archive, footer length: 22
```

I tried to extract the files with `binwalk -e diskimage.bin`. In the resulting zip file I found the file `file` which contained the flag `SK-CERT{R3c0V3r3D_R3cip3}`.