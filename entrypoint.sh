#!/bin/bash
cd /home/container

# Start Xvfb (Virtual Framebuffer)
Xvfb :99 -screen 0 1280x1024x24 &
sleep 2

# Initialize Wine
if [ ! -d "$WINEPREFIX" ]; then
    echo "Initializing Wine prefix..."
    wineboot -u
fi

# Auto-install dependencies if package.json exists but node_modules doesn't
if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
    echo "Detected package.json but no node_modules. Installing..."
    npm install
fi

# Replace the startup variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the user's startup command
eval ${MODIFIED_STARTUP}

