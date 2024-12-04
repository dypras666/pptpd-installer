# PPTPD VPN Server Installation Guide for Ubuntu 20.04

This guide provides instructions for installing and configuring a PPTP VPN server on Ubuntu 20.04. The installation script automates the setup process and includes user management capabilities.

## Prerequisites

- Ubuntu 20.04 LTS server
- Root access or sudo privileges
- Active internet connection
- Open ports:
  - TCP 1723 (PPTP)
  - Protocol 47 (GRE)

## Installation

1. Download the installation script
```bash
wget https://your-domain/install-pptpd.sh
```

2. Make the script executable
```bash
chmod +x install-pptpd.sh
```

3. Run the installation script
```bash
sudo ./install-pptpd.sh
```

## Default Configuration

The script sets up the following default configuration:

- Local IP: 192.168.0.1
- Remote IP Range: 192.168.0.100-200
- DNS Servers: 
  - Primary: 8.8.8.8 (Google DNS)
  - Secondary: 8.8.4.4 (Google DNS)

### Default User Account
The script creates a default user account:
- Username: sedotphp
- Password: password123

**Important**: Change the default password immediately after installation for security purposes.

## User Management

### Adding New Users
To add a new VPN user, use the following command:
```bash
echo "username pptpd password *" >> /etc/ppp/chap-secrets
```
Replace `username` and `password` with your desired credentials.

### Viewing Existing Users
To view all configured VPN users:
```bash
cat /etc/ppp/chap-secrets
```

### Removing Users
To remove a user, manually edit the chap-secrets file:
```bash
sudo nano /etc/ppp/chap-secrets
```
Delete the line containing the user you want to remove.

## Service Management

### Check Service Status
```bash
systemctl status pptpd
```

### Restart Service
```bash
systemctl restart pptpd
```

### Stop Service
```bash
systemctl stop pptpd
```

### Start Service
```bash
systemctl start pptpd
```

## Client Connection

### Windows
1. Go to Network Settings > VPN > Add a VPN Connection
2. Set VPN Provider to "Windows (built-in)"
3. Enter your server's IP address
4. Set VPN type to "Point to Point Tunneling Protocol (PPTP)"
5. Enter your username and password
6. Connect to the VPN

### Android
1. Go to Settings > Network & Internet > VPN
2. Click + to add new VPN
3. Enter any name for the VPN
4. Select PPTP as type
5. Enter your server's IP address
6. Enter your username and password
7. Save and connect

### iOS
1. Go to Settings > VPN
2. Tap Add VPN Configuration
3. Select PPTP
4. Enter the following:
   - Description: Any name
   - Server: Your server's IP address
   - Account: Your username
   - Password: Your password
5. Save and connect

## Security Considerations

1. PPTP is considered less secure than modern VPN protocols. Consider using OpenVPN or WireGuard for better security.
2. Change the default user credentials immediately after installation.
3. Use strong passwords for VPN accounts.
4. Regularly monitor `/var/log/syslog` for any suspicious activities.

## Troubleshooting

1. If connection fails, check:
   - Firewall settings (ports 1723 and GRE protocol)
   - Server accessibility
   - User credentials
   
2. Check logs for errors:
```bash
tail -f /var/log/syslog
```

3. Common issues:
   - Connection timeouts: Check firewall settings
   - Authentication failures: Verify user credentials
   - No internet access: Check IP forwarding and iptables rules

## Support

For issues or questions:
1. Check the system logs
2. Verify configuration files in `/etc/pptpd.conf` and `/etc/ppp/pptpd-options`
3. Ensure all required ports are open
4. Check the status of the PPTPD service

## License

This script is provided under the MIT License. Feel free to modify and distribute as needed.
