#!/bin/bash

# Update system packages
apt-get update
apt-get upgrade -y

# Install PPTPD and required packages
apt-get install -y pptpd iptables

# Backup original configuration
cp /etc/pptpd.conf /etc/pptpd.conf.bak
cp /etc/ppp/pptpd-options /etc/ppp/pptpd-options.bak

# Configure PPTPD
cat > /etc/pptpd.conf << EOF
option /etc/ppp/pptpd-options
logwtmp
localip 192.168.0.1
remoteip 192.168.0.100-200
EOF

# Configure PPP options
cat > /etc/ppp/pptpd-options << EOF
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
nodefaultroute
lock
nobsdcomp
novj
novjccomp
nologfd
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Configure iptables for NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables-save > /etc/iptables.rules

# Create script to restore iptables rules on boot
cat > /etc/network/if-pre-up.d/iptables << EOF
#!/bin/sh
iptables-restore < /etc/iptables.rules
EOF

chmod +x /etc/network/if-pre-up.d/iptables

# Create function to add VPN users
add_vpn_user() {
    username=$1
    password=$2
    
    # Add user to chap-secrets with full permission
    echo "$username pptpd $password *" >> /etc/ppp/chap-secrets
    echo "User $username has been added successfully"
}

# Create example user
add_vpn_user "sedotphp" "password123"

# Restart PPTPD service
systemctl restart pptpd

echo "PPTP VPN Server installation completed!"
echo "Default user created:"
echo "Username: sedotphp"
echo "Password: password123"
echo ""
echo "To add more users, use the following command format:"
echo "echo \"username pptpd password *\" >> /etc/ppp/chap-secrets"
echo ""
echo "To check current users:"
echo "cat /etc/ppp/chap-secrets"
