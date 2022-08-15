//config to service
const protocol = "http";
const host = "192.168.10.102";
const baseUrl = "electronic-documents";
//config to app create into database
const String clientName = "b83baf55-729c-41ae-a40c-94e1c14a2c28";
const String clientSecret =
    "V9JxYhIvMbYN11fM7VsIXByygRFb84T9T6IGNx5WyqvVYeuJlj";
//URL for security
const apiSecurity = '$protocol://$host:8090/$baseUrl/security-service/';
const apiSecurityLogin = "${apiSecurity}oauth/token";
