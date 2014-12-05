#![crate_id = "opencl-stress"]
#![crate_type = "bin"]

#![feature(phase)]
#[phase(plugin, link)] extern crate log;

extern crate opencl;

use std::io::fs;
use std::io::File;
use tester::{TestCase, test_everything};

mod tester;

fn main() {
    let path = &Path::new("kernels");
    let mut tests = FileSystemTests::new(path);
    test_everything(&mut tests);
}

struct FileSystemTests<'a> {
    path: &'a Path,
    dirs: fs::Directories
}

impl<'a> Clone for FileSystemTests<'a> {
    fn clone(&self) -> FileSystemTests<'a> {
        FileSystemTests {
            path: self.path,
            dirs: fs::walk_dir(self.path).unwrap()
        }
    }
}

impl<'a> FileSystemTests<'a> {
    fn new<'b>(path: &'b Path) -> FileSystemTests<'b> {
        FileSystemTests {
            path: path,
            dirs: fs::walk_dir(path).unwrap()
        }
    }
}

impl<'a> Iterator<TestCase> for FileSystemTests<'a> {
    fn next(&mut self) -> Option<TestCase> {
        for p in self.dirs {
            match p.extension_str() {
                Some("cl") => {
                    return Some(TestCase {
                        name: String::from_str(p.display().as_cow().deref()),
                        source: File::open(&p).read_to_string().unwrap()
                    })
                },
                _ => info!("Skipping {}", p.display())
            }
        }
        None
    }
}
