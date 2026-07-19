import shoki/date

@external(javascript, "./date_ffi.mjs", "toRFC822")
fn to_rfc_822(_date: String) -> String {
  panic as "not supported for the given target"
}

pub fn to_rss_pub_date(date: date.IsoDate) -> String {
  date |> date.to_string("-") |> to_rfc_822
}
