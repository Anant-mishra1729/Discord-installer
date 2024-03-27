# Discord installer

Shell script to install discord in any linux distribution

## Usage
Copy the script and save it in any file like `discord_setup.sh`  and run it with sudo privilege
```sh
sudo sh discord_setup.sh
```


## Script
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
