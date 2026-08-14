# Photography Conventions

## Image Title Formats

To simplify management of image data, important metadata is stored in their name, the format is as follows:

```
<date: YYYY-MM-DD> - <cam+lens code> - <tags: bw/color (..others)> - <country: XX> (- <city>) - <Caption/alt>.ext
```

- Date, camera, lens identify shooting meta, the rest is for sorting and display

- The country should be the ISO 3166 country code
- Tags should be space-separated, no # or any non-alphanumeric
  - bw/color should always be present
- Camera/lens mappings are defined in `meta.yaml`


## Galleries

Galleries are rendered using `<gallery>` and have the following attributes, all of which are optional:

- `path` - a path to folder containing images within `content/photography` - defaults to all images in folder
- `tags` - a space-separated list of tags to filter on applied images - defaults to ``
- `sort` - images are sorted by file name with the latest first by default, the following options will change this behavior:
  - `normal` (default) - old-to-new, and then alphabetical by path
  - `reverse` - reverses the default sort order
