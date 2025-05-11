# copypasta

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| copypasta | Forensics  | BtSCTF{we_have_to_censor_that_one_and_another_one_and_finally_that_one} | unknown |

## Description
I was moving one of the most relatable copypastas to me to a pendrive, but I think something went wrong during copying and pasting (hehe) and I can't open the file. To make matters worse, I forgot the password, but it should be one of those in a wordlist. Can you help me recover my favourite copypasta?

## Attachments
copypasta.pdf
wordlist.txt

## Solution
First find the password using the wordlist. I used pdfcrack to do this.

```bash
pdfcrack -f copypasta.pdf -w wordlist.txt
```
Output:
```
PDF version 1.7
Security Handler: Standard
V: 2
R: 3
P: -3392
Length: 128
Encrypted Metadata: True
FileID: d3117196a8bcb2110a0067458b6bc623
U: 460a5599c264b869503f662f4ebd1bad00000000000000000000000000000000
O: 4d472cbb7fb42299fa91d557dc4de781868767dc39b1e8789286ee343282d5a2
found user-password: 'pumpkin'
```

Then I tried to open the file with the password, but it didn't work, it seems to be corrupted. I then tried a lot of different approaches to recover the file, but none of them worked. I then tried to repair the file on `https://www.freepdfconvert.com/` this the produced a file that was fixed it contained some text:

```
using linux in front of class mates
teacher says “Ok students, now open photoshop”
start furiously typing away at terminal to install Wine
Errors out the BtSCTF{we_have_to_censor_that_one
Everyone else has already started their classwork
I start to sweat
Install GIMP
”Umm...what the _and_another_one” a girl next to me asks
I tell her its GIMP and can do everything that photoshop does and IT’S FREE!
“Ok class, now use the shape to to draw a circle!” the teacher says
I _and_finally_that_one} break down and cry and run out of the class
I get beat up in the parking lot after school
```

I then used the text to create the flag. It seems to be a 3 part flag, when peaced together it produced the flag: `BtSCTF{we_have_to_censor_that_one_and_another_one_and_finally_that_one}`