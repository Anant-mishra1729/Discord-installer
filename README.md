# Discord setup linux

Handy scripts to get Discord up and running, or remove it completely, on your Linux system - it works on any version!

## Usage

### Installer
Copy the script and save it in any file like `discord_install.sh` & `discord_uninstall.sh` , execute it with sudo privileges.
```sh
sudo sh discord_setup.sh
```

```bash
#!/bin/bash

# Prompt for reinstall
prompt_reinstall() {
    read -rp "Discord is already installed. Do you want to reinstall it? (y/n): " choice
    case "$choice" in
        [yY]|[yY][eE][sS])
            return 0  # Reinstall
            ;;
        *)
            return 1  # Do not reinstall
            ;;
    esac
}

# Checking for dependencies
if ! command -v wget &>/dev/null; then
    echo -e "\e[1;31mError: 'wget' is not installed. Please install it and try again.\e[0m"
    exit 1
fi

# Checking if Discord is already installed
if command -v Discord &>/dev/null; then
    if prompt_reinstall; then
        echo -e "\e[1;33mRemoving existing Discord installation...\e[0m"
        sudo rm -rf "/opt/Discord" "/usr/bin/Discord" "/usr/share/applications/discord.desktop"
    else
        echo -e "\e[1;33mSkipping setup.\e[0m"
        exit 0
    fi
fi

# Downloading the Discord tar file
FILENAME="discord.tar.gz"
URL="https://discordapp.com/api/download?platform=linux&format=tar.gz"

echo -e "\n\e[1;32mDownloading Discord tar file...\e[0m"
if ! wget -O "$FILENAME" "$URL"; then
    echo -e "\e[1;31mError: Download failed. Please check your internet connection or try again later.\e[0m"
    exit 1
fi

# Extracting the tar file
echo -e "\n\e[1;33mExtracting the tar file...\e[0m"
if ! sudo tar -xvf "$FILENAME" -C /opt/; then
    echo -e "\e[1;31mError: Extraction failed.\e[0m"
    exit 1
fi

# Creating symbolic link
if ! sudo ln -sf "/opt/Discord/Discord" "/usr/bin/Discord"; then
    echo -e "\e[1;31mError: Symbolic link creation failed.\e[0m"
    exit 1
fi

# Modifying desktop file
echo -e "\n\e[1;33mModifying desktop file...\e[0m"
if ! sudo sed -i 's/Exec=\/usr\/share\/discord\/Discord/Exec=Discord/g' "/opt/Discord/discord.desktop" \
    || ! sudo cp "/opt/Discord/discord.desktop" "/usr/share/applications/"; then
    echo -e "\e[1;31mError: Desktop file modification failed.\e[0m"
    exit 1
fi

# Cleanup
echo -e "\n\e[1;33mCleaning up...\e[0m"
if ! rm "$FILENAME"; then
    echo -e "\e[1;31mError: Cleanup failed.\e[0m"
    exit 1
fi

# Completion message
echo -e "\n\e[1;32mDiscord setup completed successfully.\e[0m"
```

### Uninstaller

```sh
sudo sh discord_uninstall.sh
```

```bash
#!/bin/bash

# Function to prompt for uninstallation
prompt_uninstall() {
    read -rp "Do you want to uninstall Discord? (y/n): " choice
    case "$choice" in
        [yY]|[yY][eE][sS])
            return 0  # Uninstall
            ;;
        *)
            return 1  # Do not uninstall
            ;;
    esac
}

# Function to prompt for config file removal
prompt_config_removal() {
    read -rp "Do you also want to remove Discord configuration files? (y/n): " choice
    case "$choice" in
        [yY]|[yY][eE][sS])
            return 0  # Remove config files
            ;;
        *)
            return 1  # Do not remove config files
            ;;
    esac
}

# Check if Discord is installed
if ! command -v Discord &>/dev/null; then
    echo -e "\e[1;33mDiscord is not installed on your system.\e[0m"
    exit 0
fi

# Prompt for uninstallation
if ! prompt_uninstall; then
    echo -e "\e[1;33mSkipping uninstallation.\e[0m"
    exit 0
fi

# Remove Discord files and symbolic link
echo -e "\n\e[1;32mUninstalling Discord...\e[0m"
sudo rm -rf "/opt/Discord" "/usr/bin/Discord" "/usr/share/applications/discord.desktop"

# Prompt for config file removal
if prompt_config_removal; then
    echo -e "\n\e[1;32mRemoving Discord configuration files...\e[0m"
    config_dir="$HOME/.config/discord"
    if [ -d "$config_dir" ]; then
        rm -rf "$config_dir"
        echo -e "\e[1;32mDiscord configuration files removed successfully.\e[0m"
    else
        echo -e "\e[1;33mDiscord configuration directory not found.\e[0m"
    fi
fi

# Check if uninstallation was successful
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32mDiscord has been successfully uninstalled.\e[0m"
else
    echo -e "\n\e[1;31mError: Uninstallation failed.\e[0m"
fi
```

