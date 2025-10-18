# Sample SSH Connection Configuration

This document provides examples for configuring SSH connections in Onyx Terminal.

## Basic Password Authentication

```swift
let connection = SSHConnection(
    host: "example.com",
    port: 22,
    username: "user",
    password: "your-password"
)
```

## Custom Port

```swift
let connection = SSHConnection(
    host: "example.com",
    port: 2222,  // Custom SSH port
    username: "user",
    password: "your-password"
)
```

## IP Address Connection

```swift
let connection = SSHConnection(
    host: "192.168.1.100",
    port: 22,
    username: "admin",
    password: "your-password"
)
```

## Common SSH Server Examples

### Raspberry Pi

```swift
let piConnection = SSHConnection(
    host: "raspberrypi.local",  // or use IP address
    port: 22,
    username: "pi",
    password: "raspberry"  // Change default password!
)
```

### Ubuntu Server

```swift
let ubuntuConnection = SSHConnection(
    host: "ubuntu-server.example.com",
    port: 22,
    username: "ubuntu",
    password: "your-password"
)
```

### AWS EC2

```swift
let ec2Connection = SSHConnection(
    host: "ec2-xx-xxx-xxx-xxx.compute.amazonaws.com",
    port: 22,
    username: "ec2-user",  // or "ubuntu" for Ubuntu AMIs
    password: "your-password"
)
```

## Security Best Practices

### 1. Use Strong Passwords

- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, and symbols
- Don't use common words or patterns

### 2. Change Default Passwords

- Always change default passwords on new systems
- Examples: Raspberry Pi default is "raspberry"

### 3. Use Private Key Authentication (TODO)

```swift
// Future implementation
let keyConnection = SSHConnectionConfig(
    host: "example.com",
    port: 22,
    username: "user",
    authMethod: .privateKey(privateKeyData, passphrase: "key-passphrase")
)
```

### 4. Enable Two-Factor Authentication

- Consider using 2FA on your SSH servers
- Some configurations may require special handling

### 5. Use Non-Standard Ports

- Consider changing SSH port from 22 to reduce automated attacks
- Remember to update firewall rules

## SFTP Configuration

SFTP uses the same connection as SSH. When "Also connect SFTP" is enabled:

```swift
// SSH connection is established first
try await sshClient.connect(config)

// Then SFTP can be used over the same connection
let sftpClient = try await sshClient.openSFTPSession()
```

## Troubleshooting

### Connection Refused

- Check if SSH server is running
- Verify port number is correct
- Check firewall settings

### Authentication Failed

- Verify username and password
- Check if password authentication is enabled on server
- Some servers require key-based auth only

### Timeout

- Check network connectivity
- Verify host address is correct
- Check if server is accessible from your network

### SFTP Not Available

- Ensure SFTP subsystem is enabled on server
- Check sshd_config: `Subsystem sftp /usr/lib/openssh/sftp-server`

## Server Configuration Examples

### Enable Password Authentication (sshd_config)

```bash
# Edit /etc/ssh/sshd_config
PasswordAuthentication yes
ChallengeResponseAuthentication no

# Restart SSH service
sudo systemctl restart sshd
```

### Enable SFTP Subsystem

```bash
# In /etc/ssh/sshd_config, ensure this line exists:
Subsystem sftp /usr/lib/openssh/sftp-server
```

### Create SSH User

```bash
# Create a new user for SSH access
sudo useradd -m -s /bin/bash sshuser
sudo passwd sshuser

# Add to sudo group (optional)
sudo usermod -aG sudo sshuser
```

## Testing Connection

### Test SSH from Terminal

```bash
ssh username@hostname -p port
```

### Test SFTP from Terminal

```bash
sftp -P port username@hostname
```

### Common Test Commands

```bash
# Check SSH is listening
netstat -tuln | grep :22

# Test connection
nc -zv hostname 22

# Check SSH server logs
sudo tail -f /var/log/auth.log  # Ubuntu/Debian
sudo tail -f /var/log/secure     # CentOS/RHEL
```

## Notes

- Onyx Terminal currently supports password authentication
- Private key authentication is planned for future releases
- Keep your credentials secure and never share them
- Consider using a password manager
