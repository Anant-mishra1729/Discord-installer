# Shell script to setup discord in linux

# Download the discord tar file
FILENAME="discord.tar.gz"
URL="https://discordapp.com/api/download?platform=linux&format=tar.gz"

# Colored echo
echo -e "\n\e[1;32mDownloading Discord tar file\e[0m"

wget -O $FILENAME $URL

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32mDownload successful\e[0m"
else
    echo -e "\n\e[1;31mDownload failed\e[0m"
    exit 1
fi

# Extract the tar file in /opt directory
echo -e "\n\e[1;33mExtracting the tar file\e[0m"

sudo tar -xvf $FILENAME -C /opt/

# Check if the extraction was successful
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32mExtraction successful\e[0m"
else
    echo -e "\n\e[1;31mExtraction failed\e[0m"
    exit 1
fi

# Create a symbolic link of the discord executable in /usr/bin
sudo ln -sf /opt/Discord/Discord /usr/bin/Discord

# Check if the symbolic link was created successfully
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32mSymbolic link created successfully\e[0m"
else
    echo -e "\n\e[1;31mSymbolic link creation failed\e[0m"
    exit 1
fi

# Create a desktop file for discord
echo -e "\n\e[1;33mCreating desktop file for discord\e[0m"

# Replace Exec=/usr/share/discord/Discord with Exec=Discord
sudo sed -i 's/Exec=\/usr\/share\/discord\/Discord/Exec=Discord/g' /opt/Discord/discord.desktop

sudo cp /opt/Discord/discord.desktop /usr/share/applications/

# Check if the desktop file was created successfully
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32mDesktop file created successfully\e[0m"
else
    echo -e "\n\e[1;31mDesktop file creation failed\e[0m"
    exit 1
fi

# Clean up the downloaded tar file
echo -e "\n\e[1;33mCleaning up the downloaded tar file\e[0m"
rm $FILENAME

# Check if the cleanup was successful
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32mCleanup successful\e[0m"
else
    echo -e "\n\e[1;31mCleanup failed\e[0m"
    exit 1
fi

# echo completion message
echo -e "\n\e[1;32mDiscord setup completed successfully\e[0m"
