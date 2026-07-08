import gleam/dict
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

/// A drop-in replacement for result.try when in a promise context.
/// Wraps results in a promise so that they can be used in `use` statements
/// within a function ensuring consistent returns
pub fn try_resolve(result, cb) {
  case result {
    Ok(ok) -> cb(ok)
    Error(err) -> promise.resolve(Error(err))
  }
}

/// Simplifies mapping List(Result) to Result(List)
/// if you can, it would be better to convert a list.map to a list.try_map
/// which would avoid needing this function altogether
pub fn try_list(res, cb) {
  result.try(
    res
      |> result.all,
    cb,
  )
}

pub fn try_resolve_chain(
  base: a,
  processors: List(fn(a) -> Promise(Result(a, b))),
) {
  case processors {
    [] -> base |> Ok |> promise.resolve
    [proc, ..rest] -> {
      use r <- promise.try_await(proc(base))
      try_resolve_chain(r, rest)
    }
  }
}

/// Map over result object and merge error messages
pub fn try_all_merge_errors(res: List(Result(ok, String)), cb) {
  let oks = res |> list.filter_map(fn(i) { i })
  let errs =
    res
    |> list.filter_map(fn(i) {
      case i {
        Ok(ok) -> Error(ok)
        Error(err) -> Ok(err)
      }
    })

  case errs {
    [] -> cb(oks)
    [_, ..] -> Error(errs |> string.join("\n"))
  }
}

pub fn dict_to_sorted_entries(d) {
  d
  |> dict.to_list
  |> list.sort(fn(entry_a, entry_b) {
    let a = entry_a |> pair.first
    let b = entry_b |> pair.first

    string.compare(a, b)
  })
}
