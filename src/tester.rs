use OpenCL::hl::Device;
use OpenCL::hl::get_platforms;

pub struct TestCase {
    pub name: String,
    pub source: String,
}

pub fn test_everything<It: Iterator<TestCase>>(tests: &mut It) {
    let mut platforms = get_platforms();
    platforms.reverse();
    for platform in platforms.iter() {
        println!("");
        println!("================================================================================");
        println!("    Using platform {}", platform.name());
        println!("================================================================================");
        println!("    OpenCL Version: {}", platform.version());
        println!("");
        for device in platform.get_devices().iter() {
            println!("Testing device {}", device.name());
            test_device(device, tests);
            println!("");
        }
    }
}

fn test_device<It: Iterator<TestCase>>(dev: &Device, tests: &mut It) {
    for test in *tests {
        println!("    Building {}", test.name);
        
        let context = dev.create_context();
        let program = context.create_program_from_source(&test.source);
        match program.build(dev) {
            Ok(log) => {
                if log.len() > 0 {
                    println!("{}", log)
                }
            },
            Err(e) => println!("Error building program: {}", e)
        }
    }
}
