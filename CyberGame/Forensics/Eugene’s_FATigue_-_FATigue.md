# Eugene's FATigue - FATigue

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Eugene's FATigue - FATigue | Forensics  | SK-CERT{pl41n_5iGh7} | medium (2 filled stars) |

## Description
National hero and local legend, Eugene "Gene" Securewitz, famous for single-handedly preventing the Great Cyber Catastrophe by unplugging the internet router at City Hall, has suddenly vanished. Rumor has it he's fled his apartment to escape fans, bill collectors, and overly enthusiastic historians.

The "Committee for the Preservation of Gene's Greatness" (CPGG) desperately wants to immortalize Gene's groundbreaking research. It's up to you, the city's most underpaid forensic expert, to unravel the mysteries hidden on Gene’s USB stick - which reportedly includes profound insights about the universe, meticulously detailed recipes, and an eclectic collection of heartfelt poems.

Just remember: the fate of national pride - and perhaps the location of Gene’s secret cookie stash - is in your hands. Download and unzip the diskimage.bin from files.cybergame.sk/fatigue-eaaf2057-1b0d-4cc4-be2a-5d231b5fc4d4/diskimage.bin.gz

## Attachments
diskimage.bin.gz -> diskimage.bin

## Solution

The flag came up in strings of the whole image:

```
This feels like FX-PREG{cy41a_5vTu7} to me. Cannot hide my best work here.
```

This looked a lot like ROT13, so I decoded it and got the flag `SK-CERT{pl41n_5iGh7}`.