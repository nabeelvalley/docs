import content/metadata
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn load_photography_meta_test() {
  let assert Ok(_) = metadata.load_photos()
}
