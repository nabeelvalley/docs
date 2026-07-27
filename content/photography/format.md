# Image Title Formats

To simplify management of image data, important metadata is stored in their name, the format is as follows:

```
<date: YYYY-MM-DD> - <cam+lens code> - <tags: bw/color (..others)> - <country: XX> (- <city>) - <Caption/alt>.ext
```

- Date, camera, lens identify shooting meta, the rest is for sorting and display

- The country should be the ISO 3166 country code
- Tags should be space-separated, no # or any non-alphanumeric
  - bw/color should always be present
- Camera/lens mappings are defined in `meta.yaml`


