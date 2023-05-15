---
published: true
title: Binary Data and File Formats
subtitle: 20 August 2022
description: An introduction to bits, bytes, and binary file formats
---

---

title: Binary Data and File Formats
subtitle: 20 August 2022
description: An introduction to bits, bytes, and binary file formats
published: true

---

# Introduction

Computers work with data stored in binary formats. Reading and interpreting binary data is an important part of understanding file formats so their data can be read and interpreted

# Bits and Bytes, and Binary

Binary files store data using bits

A bit can be either a 1 or 0. When working with bit-data, it's useful to group them into sets of 8, known as bytes

A byte is a sequence of 8-bits which can contain a value ranging from `0` to `255` - these are referred to as the decimal representation

Bytes consist of 8-bit, with each position representing a power of 2 from 2^0 to 2^7, as seen below:

```
0 0 0 0 0 0 0 0
| | | | | | | |
| | | | | | | |__ 2^0 - 0 or 1
| | | | | | |____ 2^1 - 0 or 2
| | | | | |______ 2^2 - 0 or 4
| | | | |________ 2^3 - 0 or 8
| | | |__________ 2^4 - 0 or 16
| | |____________ 2^5 - 0 or 32
| |______________ 2^6 - 0 or 64
|________________ 2^7 - 0 or 128

total:                  0 to 255
```

The byte above represents the value for 0, this is because all the bits have a value of 0

Using the above explanation, the number 1 is represented using the following:

```
0 0 0 0 0 0 0 1
| | | | | | | |
| | | | | | | |__ 2^0 - 1
| | | | | | |____ 2^1 - 0
| | | | | |______ 2^2 - 0
| | | | |________ 2^3 - 0
| | | |__________ 2^4 - 0
| | |____________ 2^5 - 0
| |______________ 2^6 - 0
|________________ 2^7 - 0

total:                  1
```

Where the position for 2^0 is the only bit with a value (1)

Similarly, 2 is represented as:

```
0 0 0 0 0 0 2 0
| | | | | | | |
| | | | | | | |__ 2^0 - 0
| | | | | | |____ 2^1 - 2
| | | | | |______ 2^2 - 0
| | | | |________ 2^3 - 0
| | | |__________ 2^4 - 0
| | |____________ 2^5 - 0
| |______________ 2^6 - 0
|________________ 2^7 - 0

total:                  2
```

Where the bit for 2^1 has a value

Or the number 5 with bits 2^0 and 2^2 having a value:

```
0 0 0 0 0 1 0 1
| | | | | | | |
| | | | | | | |__ 2^0 - 1
| | | | | | |____ 2^1 - 0
| | | | | |______ 2^2 - 4
| | | | |________ 2^3 - 0
| | | |__________ 2^4 - 0
| | |____________ 2^5 - 0
| |______________ 2^6 - 0
|________________ 2^7 - 0

total:                  5
```

Which is calculated by adding 2^0 + 2^2 = 1 + 4 = 5

A larger number, like 234 is:

```
1 1 1 0 1 0 1 0
| | | | | | | |
| | | | | | | |__ 2^0 - 0
| | | | | | |____ 2^1 - 2
| | | | | |______ 2^2 - 0
| | | | |________ 2^3 - 8
| | | |__________ 2^4 - 0
| | |____________ 2^5 - 32
| |______________ 2^6 - 64
|________________ 2^7 - 128

total:                  234
```

The calculation for the above value is:

```
2^1 + 2^3 + 2^5 + 2^6 + 2^7 = total = 234
```

When substituting the powers of 2:

```
2 + 8 + 32 + 64 + 128 = total = 234
```

The numbers discussed above are all 1-byte (8-bit) numbers, which have a range between 0 and 255, adding bits to the value will allow the representation of bigger numbers, for example, a 2-byte (16-bit) number can have a value from 0 to 65,535

# Hexadecimal (Hex)

In the above example, numbers are represented in binary format (e.g. `000000020`), or decimal format (e.g. 2)

When looking at binary data, it can be a bit easier to navigate around by representing data in hexadecimal (hex) format - which represents every 4 bits as a value ranging from 0-15, so, similar to the byte example above, but instead using 4-bits:

```
0 0 0 0
| | | |
| | | |__ 2^0 - 0 or 1
| | |____ 2^1 - 0 or 2
| |______ 2^2 - 0 or 4
|________ 2^3 - 0 or 8
```

Using what's already been discussed, the number 12 can be represented in bits as `1100`,

Hex numbers additionally convert each of these values into a value from 0-9 or A-F, as seen in the following table:

| Decimal | Bits   | Hex |
| ------- | ------ | --- |
| 0       | `0000` | `0` |
| 1       | `0001` | `1` |
| 2       | `0010` | `2` |
| 3       | `0011` | `3` |
| 4       | `0100` | `4` |
| 5       | `0101` | `5` |
| 6       | `0110` | `6` |
| 7       | `0111` | `7` |
| 8       | `1000` | `8` |
| 9       | `1001` | `9` |
| 10      | `1010` | `A` |
| 11      | `1011` | `B` |
| 12      | `1100` | `C` |
| 13      | `1101` | `D` |
| 14      | `1110` | `E` |
| 15      | `1111` | `F` |

Using the binary representation, a byte can be represented using 2 Hex values which are taken by using the first 4-bits as the first hex value, and the second 4-bits as the second hex value

For example, the value for 234, represented as bits: `11101010` can be split into 2 sets of 4-bits `1110 1010`, using the table above, this becomes `EA` in hex

## Binary Files

Binary files encode data using bits, when viewing them, it's convenient to view the data in them using bytes represented as hex values as was shown above

Binary files usually require some knowledge of how their data is structured to correctly interpret the information. This is usually described in the specification for the file format

# Text Files

Plain text files are usually in the UTF-8 or UTF-16 format - this means that they use 8-bits or 16-bits to represent each character, but there are lots of other formats that a text file can use

UTF-8 data can be read by converting the binary data to text data using a table which maps the byte/hex value to the character -for the UTF-8 format, the character "A" is encoded in hex as `41` and "z" is `7a`

The Hexadecimal representation for a text file that contains the following UTF-8 data:

```
Hello World!
```

Would be stored as a binary file which contains:

```
48 65 6C 6C 6F 20 57 6F 72 6C 64 21
```

Putting the hex below the text content, the hex to character mapping can be seen:

```
H  e  l  l  o     W  o  r  l  d  !
48 65 6C 6C 6F 20 57 6F 72 6C 64 21
```

Binary files can be viewed in a hex editor to see the raw binary data, but interpreting these files depends on the format used and will differ between file formats

# Conclusion

Computers store data using bits. Bits can be structured into sets of 8-bits, called a byte

Data can be represented using bits, bytes, decimal values, or hexadecimal values

Files store data using binary. Binary data can be represented as decimal or hex depending and can be viewed as whichever is appropriate

# References

- [UTF-8 Character Table](https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=bin)
- [HexEdit](https://hexed.it/)
- [Bits, Bytes, and Binary Summary](https://www.cs.cmu.edu/~fgandon/documents/lecture/uk1999/binary/HandOut.pdf)
