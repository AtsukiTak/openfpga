use clap::Parser;

#[derive(Parser)]
pub struct Args {
    #[command(subcommand)]
    task: Task,
}

#[derive(clap::Subcommand)]
pub enum Task {
    Reverse {
        #[arg(index = 1)]
        src: String,
        #[arg(index = 2)]
        dst: String,
    },
}

fn main() {
    let args = Args::parse();

    match args.task {
        Task::Reverse { src, dst } => reverse(&src, &dst),
    }
}

fn reverse(src_file: &str, dst_file: &str) {
    eprintln!("Task: reverse");

    eprintln!("Reading {}.", src_file);
    let src = std::fs::read(src_file).expect("cannot read src_file");

    eprintln!("Reversing {} bytes.", src.len());
    let mut dst = Vec::with_capacity(src.len());
    for byte in src.iter() {
        let reversed_byte = byte.reverse_bits();
        dst.push(reversed_byte);
    }

    eprintln!("Writing {}.", dst_file);
    std::fs::write(dst_file, dst).expect("cannot write dst_file");
}
