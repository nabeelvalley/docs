import gleam/dict
import gleam/list
import gleam/pair
import gleam/string

pub fn to_sorted_entries(d) {
  d
  |> dict.to_list
  |> list.sort(fn(entry_a, entry_b) {
    let a = entry_a |> pair.first
    let b = entry_b |> pair.first

    string.compare(a, b)
  })
}
