#![crate_id = "opencl-stress"]
#![crate_type = "bin"]

#![feature(phase)]
#[phase(syntax, link)] extern crate log;

extern crate OpenCL;
extern crate std;

use std::io::fs;
use std::io::File;
use tester::{TestCase, test_everything};

mod tester;

fn main() {
    let mut tests = FileSystemTests::new(&Path::new("kernels"));
    test_everything(&mut tests);
}

struct FileSystemTests {
    dirs: fs::Directories
}

impl FileSystemTests {
    fn new(path: &Path) -> FileSystemTests {
        FileSystemTests {
            dirs: fs::walk_dir(path).unwrap()
        }
    }
}

impl Iterator<TestCase> for FileSystemTests {
    fn next(&mut self) -> Option<TestCase> {
        for p in self.dirs {
            match p.extension_str() {
                Some("cl") => {
                    return Some(TestCase {
                        name: p.display().to_str(),
                        source: File::open(&p).read_to_str().unwrap()
                    })
                },
                _ => info!("Skipping {}", p.display())
            }
        }
        None
    }
}
