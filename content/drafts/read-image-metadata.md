---
title: Read Metadata from Images using Rust
subtitle: 20 August 2022
description: Using Rust to parse EXIF metadata from image files
published: false
---

> The complete Rust code discussed in this post can be found in the [exiflib GitHub repo](https://github.com/nabeelvalley/exiflib)

# Introduction

Image files, such a JPEG, PNG, and RAW formats from digital cameras and software, contain metadata about the image. This metadata can contain information ranging from the make and model of the camera used to the specific shooting conditions under which a picture was taken

Reading this data depends on the image format used. This post looks at specifically reading metadata from images that use the Exchangeable Image File Format (EXIF) for storing metadata

# The Rust Programming Language

The [Rust programming language](https://www.rust-lang.org/) is used to read and process the image files. Rust is a general purpose programming language with an emphasis on performance and type safety

While this post doesn't cover the specifics of programming in Rust, any code samples are accompanied by a description of what the code does but it's useful to have a basic understanding of programming for understanding exactly what the code is doing

It's also worth noting that this post covers a lot of bit-level processing of image files, to get a basic understanding of binary data works take a look at the previous post on [Understanding Binary File Formats](../20-08/understanding-binary-files)

# The Exchangeable Image File Format (EXIF)

The Exchangeable Image File Format (EXIF) is based on the Tag Image File Format (TIFF) specificiation for storing metadata. This data is organizaed into Image File Directories (IFDs) within an image file

The EXIF section in an image file is structured structured as follows:

| Section                 | Subsection            | Number of Bytes             |
|-------------------------|-----------------------|-----------------------------|
| Header                  |                       |                             |
|                         | EXIF Marker (Exif00)  | 6 bytes                     |
| IFD                     |                       |                             |
|                         | Byte Order (II or MM) | 2 bytes                     |
|                         | Magic Number (42)     | 2 bytes                     |
|                         | Data Start Location   | 4 bytes                     |
|                         | Data Count            | 2 bytes                     |
|                         | Data Entries          | Data Count x 12 bytes/entry |
| Additional Data Section |                       |                             |

# Reading EXIF Data

Reading EXIF data is done by reading the bytes in the file. The following examples will use a JPEG from a Fujifilm X-T200 as a reference, though the same concepts can be applied to understanding data from any file format that stores metadata using the EXIF structure

## Under the Hood of an Image File

Below is a snippet of the Hex data for a JPEG file alongside the bytes decoded as text:

```
Hex Data                                           Decoded Text                       Approximate EXIF Subsections

FF D8 FF E1 57 FE 45 78 69 66 00 00 49 49 2A 00    . . . . W . E x i f . . I I * .    Header, Byte Order, Magic Number
08 00 00 00 0C 00 0F 01 02 00 09 00 00 00 9E 00    . . . . . . . . . . . . . . . .    Data Count, Data Start Location
00 00 10 01 02 00 07 00 00 00 A8 00 00 00 12 01    . . . . . . . . . . . . . . . .    |
03 00 01 00 00 00 01 00 00 00 1A 01 05 00 01 00    . . . . . . . . . . . . . . . .    |
00 00 B0 00 00 00 1B 01 05 00 01 00 00 00 B8 00    . . . . . . . . . . . . . . . .    | Data Entries
00 00 28 01 03 00 01 00 00 00 02 00 00 00 31 01    . . ( . . . . . . . . . . . 1 .    | 
02 00 1E 00 00 00 C0 00 00 00 32 01 02 00 14 00    . . . . . . . . . . 2 . . . . .    |_ 
00 00 DE 00 00 00 13 02 03 00 01 00 00 00 02 00    . . . . . . . . . . . . . . . .    | 
00 00 98 82 02 00 05 00 00 00 F2 00 00 00 69 87    . . . . . . . . . . . . . . i .    |
04 00 01 00 00 00 14 01 00 00 A5 C4 07 00 1C 00    . . . . . . . . . . . . . . . .    | Additional Data Section
00 00 F8 00 00 00 EC 29 00 00 46 55 4A 49 46 49    . . . . . . . ) . . F U J I F I    |
4C 4D 00 00 58 2D 54 32 30 30 00 00 48 00 00 00    L M . . X - T 2 0 0 . . H . . .    |
01 00 00 00 48 00 00 00 01 00 00 00 44 69 67 69    . . . . H . . . . . . . D i g i    |
```

The above snippet shows the hex data, in here the EXIF marker can be found on the first line - `45 78 69 66 00 00` which decodes to `EXIF\0\`, followed by the byte order `49 49` - `II` which means that the byte order for the file is Little Endian - which means that the smallest value in a sequence is the first byte - this can be used to decode `2A 00` to `42`, if the byte order was Big endian the bytes representing `42` would be flipped

The byte order secion is the most important thing to note on this first line as it tells an application how to read the data in the IFD as well as it is what any byte offsets should be calculated relative to

Additionally, the data entries section and the additional data section are broadly marked off, in order to understand where data is located in this file

## Reading a File as Bytes

Rust provides a method for reading a file in the standard library is `fs::read` which can be used by providing it with a path to the file to read, the code for this looks like so:

```rs
let file = fs::read("./sample.jpg").unwrap();
```

The `.unwrap()` at the end tells rust to either get the file data or exit the program with an error if it could not read the file

The result of this is a `Vec[u8]` which means a vector (or list) of bytes - the bytes in the list are represented as integer values between 0 and 255, these are equivalent to the hex values in the snippet above

The `file` is what is used to read the bytes from and will be the data source for reading the EXIF data

## Finding the EXIF Starting Point

To find the starting point of the EXIF data we can scan through the file until we find the `Exif\0\0` pattern, a function can be defined for searching for a pattern in a list of bytes:

```rs
pub fn get_sequence_range(bytes: &[u8], pattern: &[u8]) -> Option<Range<usize>> {
    let start = bytes
        .windows(pattern.len())
        .position(|window| window == pattern)?;

    let end = start + pattern.len();

    Some(start..end)
}
```

The function above called `get_sequence_range` searches the `bytes` for a `pattern`. This uses the `windows` function in rust which creates a bunch of smaller lists and finds the `position` where the `window`, which is a section of bytes that's the same length as the search `pattern` and checks if the value is equal to the `pattern`

If the pattern can be found, then the function will return a range (basically, a start and end point) that goes from the `start` of the found pattern until the `end` of the pattern, which is simply the `start` value plus the length of the pattern

The `Option` indicates that the function returns either a value if it finds one (denoted by `Some`) or will return nothing if no value is found, denoted by `None`. The above function uses the shorthand for the `None` case which is done by placing a `?` at the end of the check for the pattern - which will cause the function to end early if it could not find the pattern

The above function for finding the starting point can be used by passing it the file's bytes like so:

```rs
const EXIF_MARKER: &[u8] = "Exif\0\0".as_bytes();

let exif_range = get_sequence_range(file, EXIF_MARKER)?;
```

Note that in the above function the `EXIF_MARKER` is defined as the `Exif\0\0` text converted to bytes, this is passed as the the search pattern to the `get_sequence_range` function. This gets the EXIF header location which is used to find the Byte order (Endian) marker

## Getting the Byte Order

Once we know the location of the EXIF marker, the byte order values go from the 6th and 7th byte after the start of the marker. Since this is done using a range, this means that the range goes from 6 to 8, since the end value is not included in the range, this can be see defined below:

```rs
const ENDIAN_RANGE_FROM_EXIF_MARKER: Range<usize> = 6..8;
```

The bytes for the endian value can be found relative to the `exif_range` like so:

```rs
let start = exif_range.start + ENDIAN_RANGE_FROM_EXIF_MARKER.start;

let bytes = file.get(start..)?;
let endian_bytes = bytes.get(0..2)?;
let endian = get_endian(endian_bytes)?;
```

The above makes use of a `get_endian` function to get the byte order which can be defined as follows:

```rs
fn get_endian(endian_bytes: &[u8]) -> Option<Endian> {
    let endian = parsing::full_bytes_string(endian_bytes)?;

    match endian.as_str() {
        "MM" => Some(Endian::Big),
        "II" => Some(Endian::Little),
        _ => None,
    }
}
```

The above function takes the bytes which start at the endian location and convert them to a string (text) value

These values are then compared using a `match`. If it is `II` or `MM` the function returns Big Endian (`Endian::Big`) or Little Endian (`Endian::Little`) respectively. If no matching value is found, then `None` is returned instead

The code above also finds the `bytes`, which defines the file's bytes but trims off all the bytes that are before the endian marker - this is important since any data in the IFD needs to be read relative to the this location

Following the Endian bytes are 2 bytes which specify the Magic Number (42) as mentioned above - this can also be checked to verify the byte order of the file but is not covered in this post

## Getting the IFD Data Start Location and Count

Immediately after the Magic Number are four bytes that specify where the IFD data starts, in the snippet above, these bytes are `08 00 00 00` which convert to the value of `8`, this informs us that the IFD data starts from 8 bytes from the Endian marker

By following the offset value, the number of entries in the IFD can be found at the 8 bytes from the Endian marker, in this case bytes `0C 00` which convert to the value of `12`, which indicates that there are 12 entries in the IFD

The code applying the above logic can be seen below:

```rs
let ifd0_offset = get_ifd_offset(&endian, ifd)? as usize;
let ifd0_entry_offset = ifd0_offset + 2;

let ifd0_count = u16::from_offset_endian_bytes(&endian, ifd, ifd0_offset)?;
```

The function which gets the `ifd0_offset` does the lookup of bytes from the range 4 to 8, relative to the Endian marker

## Reading Entries in the IFD

As a reference example, the bytes for the first entry in the IFD above will be used to understand the data and how it's stored

After the bytes indicating the count, the next section consists of the entries. Each entry consists of 12 bytes and is structured like so:

| Tag     | Data Format | Component Length | Data          |
| ------- | ----------- | ---------------- | ------------- |
| 2 bytes | 2 Bytes     | 4 Bytes          | 4 Bytes       |
| `0F 01` | `02 00`     | `09 00 00 00`    | `9E 00 00 00` | 

- The Tag is an identifier that specifies what the value of the entry represents
- The Data format states how the data should be read
- The Component Length states how many bytes the data for the entry consists of
- The data can either be the actual data, or a value that give the offset to the data, depending on the Component Lenght

### Tag ID

Reading the Tag is done by parsing the first two bytes of an entry - This convers the value into a 16-bit unsigned integer (a positive integer)

The TagID is read like so:

```rs
let tag = u16::from_endian_bytes(endian, entry)?;
```

The value of the tag is a 16-bit unsigned integer, but it's more commonly represented as Hex value in the tag lookup tables, a lookup table for these can be found at the [EXIF Tool Tag Names Doc](https://exiftool.org/TagNames/EXIF.html)

The value of the tag above `0F 01`  can be converted to hex with respect to the Little Endian notation results in `0x010F`, the lookup table states that this tag identifies the `Make` property in the Exif data

### Data Format

The data stored in an entry can be of 12 different formats, each of these associated with a format value - the format value can be read by reading from byte index 2 in the entry, like so:

```rs
let format_value = u16::from_offset_endian_bytes(endian, entry, 2)?;
```

The format value is a 16-bit unsigned integer, same as the Tag, though this is used as an integer value and not hex. Each integer value maps to a specific format type, as seen in the below table:

| Format Value | Format            | Bytes per Component | Data Type | Description                                   |
| ------------ | ----------------- | ------------------- | --------- | --------------------------------------------- |
| 1            | Unsigned Byte     | 1                   | u8        | 8-bit positive integer                        |
| 2            | ASCII String      | 1                   | String    | Text/String value                             |
| 3            | Unsigned Short    | 2                   | u16       | 16-bit positive integer                       |
| 4            | Unsigned Long     | 4                   | u32       | 32-bit positive integer                       |
| 5            | Unsigned Rational | 8                   | u32, u32  | positive fraction - numerator and denominator |
| 6            | Signed Byte       | 1                   | i8        | 8-bit integer                                 |
| 7            | Undefined         | 1                   | [u8]      | list of bytes                                 |
| 8            | Signed Short      | 2                   | i16       | 16-bit integer                                |
| 9            | Signed Long       | 4                   | i32       | 32-bit integer                                |
| 10           | Signed Rational   | 8                   | i32, i32  | fraction value - numerator and denominator    |
| 11           | Single Float      | 4                   | f32       | floating point/decimal                        |
| 12           | Double Float      | 8                   | f64       | double precision floating point               |

The 

The above table is implemented in code by first defining a type that states all the possible format types:

```rs
pub enum TagFormat {
    UnsignedByte,
    AsciiString,
    UnsignedShort,
    UnsignedLong,
    UnsignedRational,
    SignedByte,
    Undefined,
    SignedShort,
    SignedLong,
    SignedRational,
    SingleFloat,
    DoubleFloat,
}
```

Each type of value can also be described in terms of the data type it stores as follows:

```rs
pub enum ExifValue<'a> {
    UnsignedByte(u8),
    AsciiString(String),
    UnsignedShort(u16),
    UnsignedLong(u32),
    UnsignedRational(u32, u32),
    SignedByte(i8),
    Undefined(&'a [u8]),
    SignedShort(i16),
    SignedLong(i32),
    SignedRational(i32, i32),
    SingleFloat(f32),
    DoubleFloat(f64),
}
```

Thereafter, a function to go from the given Format Value to the type of the tag being used:

```rs
fn get_tag_format(value: &u16) -> Option<TagFormat> {
    match value {
        1 => Some(TagFormat::UnsignedByte),
        2 => Some(TagFormat::AsciiString),
        3 => Some(TagFormat::UnsignedShort),
        4 => Some(TagFormat::UnsignedLong),
        5 => Some(TagFormat::UnsignedRational),
        6 => Some(TagFormat::SignedByte),
        7 => Some(TagFormat::Undefined),
        8 => Some(TagFormat::SignedShort),
        9 => Some(TagFormat::SignedLong),
        10 => Some(TagFormat::SignedRational),
        11 => Some(TagFormat::SingleFloat),
        12 => Some(TagFormat::DoubleFloat),
        _ => None,
    }
}
```

As done previously, if the correct value can't be found, the function returns `None`

So, adding to the above code, the code for reading the tag value is:

```rs
let format_value = u16::from_offset_endian_bytes(endian, entry, 2)?;
let format = get_tag_format(&format_value)?;
```

### Component Length

The Component length specifies the number of components for the tag format being read - for most tag formats this will be 1, however, for specific values like `AsciiString` or `Undefined`, this may be different in which case it specifies the length of the string or how many bytes are required respectively 

The value for the component length can be found by reading the relevant bytes in the entry and converting them to a 32-bit unsigned integer, starting from byte index 4, like so:

```rs
let component_length = u32::from_offset_endian_bytes(endian, entry, 4)?;
```

### Data

Once the component length is known, getting the total length of the data to be read is done by multiplying the component length by the bytes per component - since different components need different amounts of data

A function that gets the bytes per component for a given tag format can be seen below:

```rs
fn get_bytes_per_component(format: &TagFormat) -> u32 {
    match format {
        TagFormat::UnsignedByte => 1,
        TagFormat::AsciiString => 1,
        TagFormat::UnsignedShort => 2,
        TagFormat::UnsignedLong => 4,
        TagFormat::UnsignedRational => 8,
        TagFormat::SignedByte => 1,
        TagFormat::Undefined => 1,
        TagFormat::SignedShort => 2,
        TagFormat::SignedLong => 4,
        TagFormat::SignedRational => 8,
        TagFormat::SingleFloat => 4,
        TagFormat::DoubleFloat => 8,
    }
}
```

This is based on the table shown previously on component formats

Next, the total length can be defined as the component length multiplied by the bytes per component which can be seen in code below:

```rs
let component_length = u32::from_offset_endian_bytes(endian, entry, 4)?;

let bytes_per_component = get_bytes_per_component(&format);

let total_length = component_length * bytes_per_component;
```

The data can be read from the data bytes, which start at index 8 of the entry

```rs
let data = entry.get(8..12)?;
```

The data value must be the raw bytes because depending on the resulting length it needs to be processed differently

If the `total_length` is less than or equal to 4, the data can be read directly from the data bytes, this can be done using a function that converts a `TagFormat` and `data` to the relevant value as defined in the table:

```rs
fn parse_tag_value<'a>(
    format: &TagFormat,
    endian: &'a Endian,
    bytes: &'a [u8],
) -> Option<ExifValue<'a>> {
    match format {
        TagFormat::UnsignedByte => parsing::bytes_to_unsigned_byte(endian, bytes),
        TagFormat::AsciiString => parsing::bytes_to_ascii_string(bytes),
        TagFormat::UnsignedShort => parsing::bytes_to_unsigned_short(endian, bytes),
        TagFormat::UnsignedLong => parsing::bytes_to_unsigned_long(endian, bytes),
        TagFormat::UnsignedRational => parsing::bytes_to_unsigned_rational(endian, bytes),
        TagFormat::SignedByte => parsing::bytes_to_signed_byte(endian, bytes),
        TagFormat::Undefined => parsing::bytes_to_undefined(bytes),
        TagFormat::SignedShort => parsing::bytes_to_signed_short(endian, bytes),
        TagFormat::SignedLong => parsing::bytes_to_signed_long(endian, bytes),
        TagFormat::SignedRational => parsing::bytes_to_signed_rational(endian, bytes),
        TagFormat::SingleFloat => parsing::bytes_to_single_float(endian, bytes),
        TagFormat::DoubleFloat => parsing::bytes_to_double_float(endian, bytes),
    }
}
```

And the data value can be obtained using the function above like so:

```rs
let value = parse_tag_value(&format, endian, data)
```

However, if the `total_length` is greater than 4, the data value needs to be read as an offset from the IFD which is then converted, again, using the `parse_tag_value` function above

```rs
// the value needs to be checked at the offset and used from there
let offset = u32::from_endian_bytes(endian, data)?;

let start = (offset) as usize;
let end = start + (length) as usize;

let range = start..end;

let value_bytes = bytes.get(range)?;

let result = parse_tag_value(&format, endian, value_bytes)
```


Putting all the above together, reading the tag above will give:


| Tag      | Data Format  | Component Length | Data          |
| -------- | ------------ | ---------------- | ------------- |
| 2 bytes  | 2 Bytes      | 4 Bytes          | 4 Bytes       |
| `0F 01`  | `02 00`      | `09 00 00 00`    | `9E 00 00 00` | 
| `0x010f` | ASCII String | 9                | FUJIFILM\0    |

# Conclusion



# References

Implementation details and guidance for reading metadata from:

- [EXIF Tool Tag Names](https://exiftool.org/TagNames/EXIF.html)
- [EXIF Viewer](http://exif-viewer.com/)
- [Fujifilm EXIF Viewer](https://greybeard.org.uk/exif3/)
- [COMPSCI 365/590F - Bit Twiddling File Formats, Parsing EXIF](https://people.cs.umass.edu/~liberato/courses/2018-spring-compsci365+590f/lecture-notes/05-bit-twiddling-file-formats-parsing-exif/)
- [Description of Exif file format (MIT Media)](https://www.media.mit.edu/pia/Research/deepview/exif.html)
- [Exif Explanation](http://gvsoft.no-ip.org/exif/exif-explanation.html#ExifIFDTags)
- [Exif Specification](http://web.archive.org/web/20131019050323/http://www.exif.org/specifications.html)
- [TIFF Specification](https://web.archive.org/web/20190624045241if_/http://www.cipa.jp:80/std/documents/e/DC-008-Translation-2019-E.pdf)

Some reference implementations and libraries:

- [rawloader docs](https://docs.rs/rawloader/latest/rawloader/index.html)
- [libopenraw](https://libopenraw.freedesktop.org/)
- [rust image](https://docs.rs/image/0.5.4/image/index.html)