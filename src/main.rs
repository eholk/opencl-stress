extern crate OpenCL;
extern crate std;

use std::io::fs;

fn main() {
    for p in fs::walk_dir(&Path::new("kernels")).unwrap() {
        match p.extension_str() {
            Some("cl") => println!("Testing {}", p.display()),
            _ => println!("Skipping {}", p.display())
        }
    }
}
