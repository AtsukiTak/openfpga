pub struct Config {
    pub remote_server_ip: String,
    pub remote_server_user: String,
}

impl Config {
    pub fn new() -> Self {
        let remote_server_ip =
            std::env::var("REMOTE_SERVER_IP").unwrap_or("100.105.200.84".to_string());
        let remote_server_user =
            std::env::var("REMOTE_SERVER_USER").unwrap_or("atsuki".to_string());

        Self {
            remote_server_ip,
            remote_server_user,
        }
    }
}
