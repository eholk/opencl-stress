#![crate_id = "opencl-stress"]
#![crate_type = "bin"]

#![feature(phase)]
#[phase(syntax, link)] extern crate log;

extern crate OpenCL;
extern crate std;

use OpenCL::hl::Device;
use OpenCL::hl::get_platforms;
use std::io::fs;
use std::io::File;


fn main() {
    for platform in get_platforms().iter() {
        println!("");
        println!("================================================================================");
        println!("    Using platform {}", platform.name());
        println!("================================================================================");
        println!("");
        for device in platform.get_devices().iter() {
            println!("Testing device {}", device.name());
            test_device(device);
            println!("");
        }
    }
}

fn test_device(dev: &Device) {
    for p in fs::walk_dir(&Path::new("kernels")).unwrap() {
        match p.extension_str() {
            Some("cl") => {
                println!("    Building {}", p.display());

                let source = File::open(&p).read_to_str().unwrap();
                let context = dev.create_context();
                let program = context.create_program_from_source(source);
                match program.build(dev) {
                    Ok(()) => (),
                    Err(e) => println!("Error building program: {}", e)
                }
            },
            _ => info!("Skipping {}", p.display())
        }
    }
}
