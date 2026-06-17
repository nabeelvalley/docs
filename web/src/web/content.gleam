import web/consts
import web/fs

pub type Book {
  Book(title: String, author: String, isbn: String)
}

pub type Collection {
  Collection
}

pub fn read_collection() {
  fs.read_dir(consts.content_dir)
}
