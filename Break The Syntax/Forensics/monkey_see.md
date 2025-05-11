# monkey see

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| monkey see | Forensics  | BtSCTF{m0nk3y_tYpE} | unknown |

## Description
🙈

## Attachments
monkey_see.pcapng

## Solution
When opening the file in Wireshark, I saw that there was a lot of USB traffic. I then researched about USB traffic and found out this actually contains keyboard inputs. So I then filtered the USB traffic:
```
usb.transfer_type == 0x01 && usb.dst == "host" && !(usb.capdata == 00:00:00:00:00:00:00:00)
```

It then only contained `URB_INTERRUPT in` packets. They all had some `Leftover Capture Data` in them. I then first exported the packets into a csv and then extracted the data into a text file with the following command:
```bash
cat monkey-see.csv | cut -d "," -f 7 | cut -d "\"" -f 2 | grep -vE "Leftover Capture Data" > hexout.txt
```

Then I used the following script to convert the hex data into a readable format. After some tweaking of the Key mappings I was able to decode the flag.


```python
KEYS = {
    0x04: 'a', 0x05: 'b', 0x06: 'c', 0x07: 'd', 0x08: 'e', 0x09: 'f',
    0x0A: 'g', 0x0B: 'h', 0x0C: 'i', 0x0D: 'j', 0x0E: 'k', 0x0F: 'l',
    0x10: 'm', 0x11: 'n', 0x12: 'o', 0x13: 'p', 0x14: 'q', 0x15: 'r',
    0x16: 's', 0x17: 't', 0x18: 'u', 0x19: 'v', 0x1A: 'w', 0x1B: 'x',
    0x1C: 'y', 0x1D: 'z', 0x1E: '1', 0x1F: '2', 0x20: '3', 0x21: '4',
    0x22: '5', 0x23: '6', 0x24: '7', 0x25: '8', 0x26: '9', 0x27: '0',
    0x28: '\n', 0x29: '[ESC]', 0x2A: '[DEL]', 0x2B: '\t', 0x2C: ' ',
    0x2D: '-', 0x2E: '=', 0x2F: '[', 0x30: ']', 0x31: '\\', 0x32: '#',
    0x33: ';', 0x34: "'", 0x35: '`', 0x36: ',', 0x37: '.', 0x38: '/'
}

SHIFT_KEYS = {
    0x04: 'A', 0x05: 'B', 0x06: 'C', 0x07: 'D', 0x08: 'E', 0x09: 'F',
    0x0A: 'G', 0x0B: 'H', 0x0C: 'I', 0x0D: 'J', 0x0E: 'K', 0x0F: 'L',
    0x10: 'M', 0x11: 'N', 0x12: 'O', 0x13: 'P', 0x14: 'Q', 0x15: 'R',
    0x16: 'S', 0x17: 'T', 0x18: 'U', 0x19: 'V', 0x1A: 'W', 0x1B: 'X',
    0x1C: 'Y', 0x1D: 'Z', 0x1E: '!', 0x1F: '@', 0x20: '#', 0x21: '$',
    0x22: '%', 0x23: '^', 0x24: '&', 0x25: '*', 0x26: '(', 0x27: ')',
    0x2D: '_', 0x2E: '+', 0x2F: '{', 0x30: '}', 0x31: '|', 0x32: '~',
    0x33: ':', 0x34: '"', 0x35: '~', 0x36: '<', 0x37: '>', 0x38: '?'
}

output = []
pressed_keys = set()

with open("hexout.txt", "r") as f:
    for line in f:
        line = line.strip()
        if not line or len(line) != 18:
            continue

        try:
            report = bytearray.fromhex(line[2:])
        except:
            continue

        if len(report) != 8:
            continue

        modifier = report[0]
        new_keys = {k for k in report[2:8] if k != 0}
        new_presses = new_keys - pressed_keys
        pressed_keys = new_keys

        shift = modifier & 0x02 or modifier & 0x20

        for key in new_presses:
            char = None
            if shift and key in SHIFT_KEYS:
                char = SHIFT_KEYS[key]
            elif key in KEYS:
                char = KEYS[key]

            if char == '[DEL]' and output:
                output.pop()
            elif char and not (char.startswith('[') and char.endswith(']')):
                output.append(char)

print("".join(output))
```

The flag is: `BtSCTF{m0nk3y_tYpE}`