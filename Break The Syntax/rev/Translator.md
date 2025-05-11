# Translator

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| Translator | rev  | BtSCTF{W0W_it_re4l1y_m3aNs_$0methIng!!:)} | unknown |

## Description
Have you ever heard about the ancient Unicode language? ...me neither, until a couple of weeks ago when I got my hands on a translation program and some text written in this mysterious script. Unfortunately, despite spending countless nights on it, I still cannot translate anything back. Maybe you could take a look at this?

## Attachments
translator
text

## Solution


```python

def sub_401270_accurate_asm_based(byte_values, start_index):
    """
    Re-implementation of sub_401270 based directly on assembly logic.
    Uses byte_values for zero checks and calculates sum of upper nibbles.
    """
    if start_index >= len(byte_values):
        return 0 # Base case: Beyond input bounds

    b0 = byte_values[start_index]
    if b0 == 0:
        return 0

    if start_index + 1 >= len(byte_values):
        return (b0 >> 4) & 0xf # Only b0 is non-zero, end of input

    b1 = byte_values[start_index + 1]
    if b1 == 0:
        return (b0 >> 4) & 0xf # b0 non-zero, b1 zero

    if start_index + 2 >= len(byte_values):
        return ((b0 >> 4) & 0xf) + ((b1 >> 4) & 0xf) # b0, b1 non-zero, end of input

    b2 = byte_values[start_index + 2]
    if b2 == 0:
        return ((b0 >> 4) & 0xf) + ((b1 >> 4) & 0xf) # b0, b1 non-zero, b2 zero

    if start_index + 3 >= len(byte_values):
        return ((b0 >> 4) & 0xf) + ((b1 >> 4) & 0xf) + ((b2 >> 4) & 0xf) # b0, b1, b2 non-zero, end of input

    b3 = byte_values[start_index + 3]
    if b3 == 0:
        return ((b0 >> 4) & 0xf) + ((b1 >> 4) & 0xf) + ((b2 >> 4) & 0xf) # b0, b1, b2 non-zero, b3 zero

    # All first 4 bytes non-zero - recursive case
    sum_nibbles = ((b0 >> 4) & 0xf) + ((b1 >> 4) & 0xf) + ((b2 >> 4) & 0xf) + ((b3 >> 4) & 0xf)
    return sum_nibbles + sub_401270_accurate_asm_based(byte_values, start_index + 4)

# Output Unicode text from the challenge (from the hexdump)
output_bytes_hex = "e5 b9 be e6 b9 82 e6 bd8c e8 95 94 e4 a9 98 e6 a1 a2 e8 b1 9d e8 a9 a7 e4 ad a1 e4 9d b5 e6 95 af e4 a1 a8 e5 89 b1 e6 8c a7 e4 8d a9 e7 a1 b7 e7 a9 8f e7 bd a3 e3 88 a1 e4 a8 a5 e8 b4 87 0a"
output_bytes = bytes.fromhex(output_bytes_hex.replace(" ", ""))
output_text = output_bytes.decode('utf-8')

# Get the Unicode code points of the output characters
output_code_points = [ord(char) for char in output_text]

# Exclude the newline character.
output_code_points = output_code_points[:-1]

# Subtract the offset (0x1000) to get the transformed code points
transformed_code_points = [cp - 0x1000 for cp in output_code_points]

num_pairs = len(transformed_code_points)
input_bytes = [0] * (num_pairs * 2)
upper_nibbles = [0] * (num_pairs * 2)
lower_nibbles = [0] * (num_pairs * 2)

# Extract upper nibbles from the transformed code points
for i in range(num_pairs):
    transformed_code = transformed_code_points[i]
    high_byte = (transformed_code >> 8) & 0xff
    low_byte = transformed_code & 0xff
    upper_nibbles[2 * i] = (high_byte >> 4) & 0xf
    upper_nibbles[2 * i + 1] = (low_byte >> 4) & 0xf

# Initialize lower nibbles (e.g., all zeros)
lower_nibbles = [0] * (num_pairs * 2)

# Iterative refinement of lower nibbles
num_iterations = 50 # Increased iterations

print("Starting iterative refinement (ASM-based sub_401270)...")

for iteration in range(num_iterations):
    previous_lower_nibbles = list(lower_nibbles)

    # Reconstruct byte values using current upper and lower nibbles
    current_byte_values = [(upper_nibbles[i] << 4) | lower_nibbles[i] for i in range(num_pairs * 2)]

    # Calculate sub_ret values for all pairs using the accurate ASM-based function
    sub_ret_values = [0] * num_pairs
    for i in range(num_pairs):
        start_index_for_sub_ret = 2 * i + 1
        raw_sub_ret = sub_401270_accurate_asm_based(current_byte_values, start_index_for_sub_ret)

        adjusted_sub_ret = raw_sub_ret # No general adjustment applied here

        sub_ret_values[i] = adjusted_sub_ret
        sub_ret_values[i] &= 0xffffffff # Ensure 32-bit as in original

    # Recalculate lower nibbles using the new sub_ret values
    new_lower_nibbles = [0] * (num_pairs * 2)
    for i in range(num_pairs):
        transformed_code = transformed_code_points[i]
        high_byte = (transformed_code >> 8) & 0xff
        low_byte = transformed_code & 0xff

        un_current = upper_nibbles[2 * i]
        un_next = upper_nibbles[2 * i + 1]

        sub_ret = sub_ret_values[i]

        # Calculate rdx_1 and rax_1 based on assembly using the current byte values
        # Assembly: mov edx, r9d (in1), shr dl, 4, add edx, eax (sub_ret) -> rdx_1 = (in1 >> 4) + sub_ret
        # Assembly: mov eax, edx (rdx_1), shr al, 4 -> rax_1 = rdx_1 >> 4

        current_in1 = (upper_nibbles[2*i] << 4) | lower_nibbles[2*i] # Use current lower nibble
        current_in2 = (upper_nibbles[2*i+1] << 4) | lower_nibbles[2*i+1] # Use current lower nibble


        rdx_val_for_rdx1 = (current_in1 >> 4) & 0xf # Upper nibble of in1
        rdx_1 = rdx_val_for_rdx1 + sub_ret

        rax_1 = rdx_1 >> 4

        target_lower_2i = high_byte & 0xf
        target_lower_2i_plus_1 = low_byte & 0xf

        # L_{2i} = (target_lower_2i - (rax_1 & 0xf)) & 0xf
        new_lower_nibbles[2 * i] = (target_lower_2i - (rax_1 & 0xf)) & 0xf

        # L_{2i+1} = (target_lower_2i_plus_1 - (rdx_1 & 0xf)) & 0xf
        new_lower_nibbles[2 * i + 1] = (target_lower_2i_plus_1 - (rdx_1 & 0xf)) & 0xf

    lower_nibbles = new_lower_nibbles

    # Check for convergence
    if lower_nibbles == previous_lower_nibbles:
        print(f"Converged after {iteration + 1} iterations.")
        break
    if iteration == num_iterations - 1:
        print("Warning: Did not converge within maximum iterations.")

# Reconstruct input bytes from final upper and lower nibbles
final_input_bytes = [(upper_nibbles[i] << 4) | lower_nibbles[i] for i in range(num_pairs * 2)]

# Convert bytes to string (assuming UTF-8 encoding for the flag)
try:
    flag = bytes(final_input_bytes).decode('utf-8')
    print("Decoded flag:", flag)
except Exception as e:
    print("Could not decode as UTF-8:", e)
    print("Raw bytes:", bytes(final_input_bytes).hex())
```