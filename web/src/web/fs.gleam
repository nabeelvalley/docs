import gleam/list
import gleam/result
import simplifile

fn read_dir_rec(at: String) {
  simplifile.read_directory(at)
  |> result.try(
    list.try_map(_, fn(i: String) {
      let inner = at <> "/" <> i
      simplifile.is_directory(inner)
      |> result.try(fn(is_dir) {
        case is_dir {
          True -> {
            read_dir_rec(inner)
          }
          False -> Ok([inner])
        }
      })
    }),
  )
  |> result.map(list.flatten)
}

pub fn read_dir(at: String) -> Result(List(String), simplifile.FileError) {
  read_dir_rec(at)
}
