use clap::Parser;
use std::process::Command;

#[derive(Parser)]
pub struct Args {
    #[command(subcommand)]
    task: Task,
}

#[derive(clap::Subcommand)]
pub enum Task {
    RemoteCompile,
    RemotePush,
    Reverse {
        #[arg(index = 1)]
        src: String,
        #[arg(index = 2)]
        dst: String,
    },
}

const SSH_DST: &str = "ubuntu";

fn main() {
    let args = Args::parse();

    match args.task {
        Task::RemoteCompile => remote_compile(),
        Task::RemotePush => {
            remote_push();
        },
        Task::Reverse { src, dst } => reverse(&src, &dst),
    }
}

fn remote_compile() {
    eprintln!("Task: remote-compile");

    let tmp_dir = remote_push();

    // リモートサーバーでコンパイル
    {
        eprintln!("Compiling on the remote server.");

        let working_dir = format!("{tmp_dir}/src");
        let compile_cmd =
            "$HOME/intelFPGA_lite/23.1std/quartus/bin/quartus_sh --flow compile ap_core";
        let cmd = format!("cd {working_dir} && {compile_cmd}");
        let result = Command::new("ssh")
            .args(&[SSH_DST, &cmd])
            .stderr(std::process::Stdio::inherit())
            .stdout(std::process::Stdio::inherit())
            .output()
            .expect("failed to execute ssh process");

        if !result.status.success() {
            panic!("failed to execute compiler. status: {}", result.status);
        }

        eprintln!("Compiled on the remote server.");
    }

    // コンパイル結果をダウンロード
    {
        eprintln!("Downloading the output files from the remote server.");

        let scp_src = format!("{SSH_DST}:{tmp_dir}/src/output_files");
        let scp_dst = ".";
        let result = Command::new("scp")
            .args(&["-r", &scp_src, &scp_dst])
            .stderr(std::process::Stdio::inherit())
            .stdout(std::process::Stdio::inherit())
            .output()
            .expect("failed to execute scp process");

        if !result.status.success() {
            panic!("failed to execute scp. status: {}", result.status);
        }

        eprintln!("Downloaded the compiled files from the remote server.");
    }

    // コンパイル結果のファイルをbyte reverse
    {
        eprintln!("Reversing the output files.");

        let src_file = "output_files/ap_core.rbf";
        let dst_file = "output_files/ap_core.rbf_r";
        reverse(src_file, dst_file);

        eprintln!("Reversed the output files.");
    }

    // 最終成果物をdistに格納
    {
        eprintln!("Copying the output files to dist.");

        let src_file = "output_files/ap_core.rbf_r";
        let dst_file = "AnaloguePocket/Cores/Atsuki.Core1/bitstream.rbf_r";
        std::fs::copy(src_file, dst_file).expect("cannot copy file");

        eprintln!("Copied the output files to dist.");
    }

    eprintln!("Done.");
}

fn remote_push() -> String {
    eprintln!("Task: remote-push");

    // リモートサーバーに一時的なディレクトリを作成
    let tmp_dir = {
        eprintln!("Creating a temporary directory on the remote server.");

        let cmd = "mktemp -d /tmp/atsuki-xtask-XXXXXX";
        let result = Command::new("ssh")
            .args(&[SSH_DST, cmd])
            .stderr(std::process::Stdio::inherit())
            .output()
            .expect("failed to execute ssh process");

        if !result.status.success() {
            panic!("failed to execute ssh. status: {}", result.status);
        }

        let tmp_dir = String::from_utf8(result.stdout).unwrap();
        let tmp_dir = tmp_dir.trim().to_string();

        eprintln!("Created a temporary directory: {}", tmp_dir);

        tmp_dir
    };

    // 作成したディレクトリにソースコードをコピー
    {
        eprintln!("Copying source code to the remote server.");

        let scp_dst = format!("{SSH_DST}:{tmp_dir}",);
        let scp_src = "src";
        let result = Command::new("scp")
            .args(&["-r", &scp_src, &scp_dst])
            .stderr(std::process::Stdio::inherit())
            .stdout(std::process::Stdio::inherit())
            .output()
            .expect("failed to execute scp process");

        if !result.status.success() {
            panic!("failed to execute scp. status: {}", result.status);
        }

        eprintln!("Copied source code to the remote server.");
    }

    tmp_dir
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
