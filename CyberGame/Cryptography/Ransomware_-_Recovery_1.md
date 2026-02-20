# Ransomware - Recovery 1

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Ransomware - Recovery 1 | Cryptography  | SK-CERT{7r1v14l_r4n50mw4r3_f0r_7h3_574r7} | easy |

## Description
You've been contacted by a movie production company that has been hit by ransomware. They need your help recovering the script for the next episode of a long-awaited series. It's urgent—millions (and possibly billions) of impatient fans are waiting.

## Attachments
recovery_1.zip
 - ransomware.py
 - files
    - inescapable_storyception_of_doom.txt.enc
    - slon.png.enc

Content of `ransomware.py`:
```python
import os
from itertools import cycle


TARGET_DIR = "./files/"

def encrypt(filename, key):
    orig_bytes = None
    encrypted_bytes = bytearray()
    with open(TARGET_DIR + filename, "rb") as f:
        orig_bytes = bytearray(f.read() )
    encrypted_bytes = bytes(a ^ b for a, b in zip(orig_bytes, cycle(key)))

    with open(TARGET_DIR + filename, "wb") as f:
        f.write(encrypted_bytes)

    os.rename(TARGET_DIR + filename, TARGET_DIR + filename + ".enc")

    print(f"[+] Encrypted {TARGET_DIR + filename}")


if __name__=="__main__":
    key = os.urandom(16)
    for subdir, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            print(f"file name: {file}")
            encrypt(file, key)
```

## Solution
By looking at the code, we can see that the file is encrypted using XOR with a secret key that we don't know.  However, because one of the files is a png file, we can use the first 16 bytes of the png file to find the key because the first 16 bytes of the png file are always the same.

So I wrote a script to try and find the key by XORing the first 16 bytes of the png file with the first 16 bytes of the encrypted file. The script is as follows:
```python
from itertools import cycle

with open("./files/slon.png.enc", "rb") as f:
    encrypted_bytes = f.read()

png_header = bytes([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
partial_key = bytes([a ^ b for a, b in zip(encrypted_bytes[:8], png_header)])

ihdr_header = bytes([0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52])
next_key_part = bytes([a ^ b for a, b in zip(encrypted_bytes[8:16], ihdr_header)])

full_key = partial_key + next_key_part

decrypted_bytes = bytes([a ^ b for a, b in zip(encrypted_bytes, cycle(full_key))])
with open("slon_decrypted.png", "wb") as f:
    f.write(decrypted_bytes)
```

When I ran the script I then got the following intact png file:
![Decrypted png file](images/slon_decrypted.png)

With this I now know the key. So I can now decrypt the text file, with the following code:
```python
with open("./files/inescapable_storyception_of_doom.txt.enc", "rb") as f:
    encrypted_bytes = f.read()
decrypted_bytes = bytes([a ^ b for a, b in zip(encrypted_bytes, cycle(full_key))])
with open("inescapable_storyception_of_doom.txt", "wb") as f:
    f.write(decrypted_bytes)
```

This then produced me a fully intact text file:
```text
# Rick and Morty and the Inescapable Storyception of Doom
It started like any other Tuesday: Rick barged into Morty’s room, pantsless and holding a glowing space burrito.

“Morty! Morty, we gotta go! The burrito prophecy is unfolding. There’s, uh, like, a 42% chance of narrative collapse if we don’t act fast!”

“Wait—what? What does that even mean, Rick?!”

But before Morty could protest, they were already in the spaceship, hurtling through a wormhole shaped suspiciously like Dan Harmon’s beard.

They emerged in a dimension made entirely of plot devices. Everything was suspiciously convenient. A USB drive floated by labeled “This Will Be Important Later.” Morty reached for it.

Suddenly, everything paused. A booming voice echoed:

“Well, well, well… if it isn’t Rick and Morty, caught once again in my narrative net!”

It was… STORY LORD, the villain who feeds on plotlines, milks tension for power, and gets royalties every time someone gasps during a season finale.

“Damn it, Morty,” Rick grumbled, “we flew into a recursive narrative trap. He’s been setting this up for seasons.”

Story Lord appeared dramatically, twirling his monologue mustache. “You are now inside a story… within a story… within a story!”

With a snap, Rick and Morty were yanked into another layer of reality: they were now characters in a TV show about two writers creating a cartoon about Rick and Morty, writing a script about Rick and Morty being trapped in a story…

"Rick, this is getting confusing! I think I just broke my brain! I’m seeing credits in my eyes!”

Rick slapped Morty with the burrito. “Snap out of it! We’re not real, Morty, we’re meta-real. That’s realer than real. We gotta break the recursive loop or we’ll be trapped in an infinite chain of storylines where every time we escape, it’s just another plot twist!”

They leapt through a narrative portal, landing in a noir-themed detective story.

“Rick, why am I wearing a fedora and narrating everything I do in a gravelly voice?”

Rick lit a cigarette with a flame that spelled out “THEME.” “Because we’re now in a genre layer, Morty. Story Lord’s getting desperate. He’s throwing every trope he’s got at us.”

Cue musical montage: they escape a heist plot, a romantic subplot where Morty almost kisses a lamp, and a musical number narrated by Morgan Freeman playing himself playing God inside the story of Rick and Morty.

Finally, they reached the core: a little dusty room with a typewriter, and on it... a script titled “Rick and Morty and the Inescapable Storyception of Doom.”

“Wait, Rick... that’s the name of this story. Are we... are we already at the end?”

“No, Morty. This isn’t the end. This is just the start of the end’s backstory.”

Suddenly, the script flipped itself open and they were sucked into that story too. Now they were watching themselves read the story of themselves being sucked into a story about themselves watching themselves…

“STOP!” screamed Morty, clutching his face. “It’s stories all the way down!”

And then, a voice—your voice, dear reader—says out loud:

“Wait… what the hell am I reading?”

Story Lord gasps. “No… the reader has become self-aware! Abort narrative! ABORT NARRATIVE!”

Rick smirks. “Too late, jackass. I slipped an anti-narrative grenade into your metaphorical pants.”

BOOM.

Everything resets.

Morty’s back in bed.

“Morty! Get up! We gotta stop Story Lord before he traps us in a recursive—”

“NOPE. NUH UH. I’M DONE.”

“…Okay, jeez. Fine. Wanna get pancakes?”

“Yeah. Pancakes sound safe.”

As they leave, a figure watches from a dark corner. It's a scriptwriter.

Holding a pen.

Smiling.

To be continued… in the story within the sequel within the prequel of the origin reboot.

			SK-CERT{7r1v14l_r4n50mw4r3_f0r_7h3_574r7}	
```

This then gave me the flag: `SK-CERT{7r1v14l_r4n50mw4r3_f0r_7h3_574r7}`.
