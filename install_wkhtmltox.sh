#!/bin/bash

# Determine Ubuntu version
ubuntu_version=$(lsb_release -cs)

# Determine processor architecture (amd64 or arm64)
architecture=$(lscpu | awk '/Architecture/ {print $2}')

# Determine bit architecture (64-bit)
bit_architecture=$(getconf LONG_BIT)

echo "$ubuntu_version $architecture $bit_architecture"

# URL for the corresponding wkhtmltox package based on the determined information
if [[ "$ubuntu_version" == "jammy" ]] && [[ "$bit_architecture" == "64" ]] && [[ "$architecture"=="aarch64" ]]; then
    # For Ubuntu Jammy and 64-bit architecture
    url="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_arm64.deb"
elif [[ "$ubuntu_version" == "focal" ]] && [[ "$bit_architecture" == "64" ]]; then
    # For Ubuntu Focal and 64-bit architecture
    url="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb"
else
    echo "Unsupported Ubuntu version or processor architecture."
    exit 1
fi

# Downloading and installing the wkhtmltox package
mkdir -p ~/wkhtmltox_install
cd ~/wkhtmltox_install

wget "$url"
sudo dpkg -i "$(basename "$url")"
#sudo apt install wkhtmltopdf -y
sudo apt install -f -y


# Verify the installation
wkhtmltopdf --version

# Remove the installation directory
cd ~
rm -rf wkhtmltox_install

echo "Installation completed and installation directory removed."
