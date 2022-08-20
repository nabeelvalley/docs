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

While this post doesn't cover the specifics of programming in Rust, any code samples are accompanied by a description of what the code does

# The Exchangeable Image File Format (EXIF)

The Exchangeable Image File Format (EXIF) is based on the Tag Image File Format (TIFF) specificiation for storing metadata. This data is organizaed into Image File Directories (IFDs) within an image file

The EXIF section in an image file is structured structured as follows:

| Section                 | Subsection            | Number of Bytes             |
|-------------------------|-----------------------|-----------------------------|
| Header                  |                       |                             |
|                         | EXIF Marker (Exif00)  | 6 bytes                     |
|                         | Magic Number (42)     | 2 bytes                     |
| IFD                     |                       |                             |
|                         | Byte Order (II or MM) | 2 bytes                     |
|                         | Data Count            | 2 bytes                     |
|                         | Data Start Location   | 4 bytes                     |
|                         | Data Entries          | Data Count x 12 bytes/entry |
| Additional Data Section |                       |                             |


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