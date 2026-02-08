#!/bin/sh
set -e

echo "Initializing openclaw home directory..."

OPENCLAW_HOME=/home/kasm-user/.openclaw
OPENCLAW_WORKSPACE=/home/kasm-user/shared/clawd

# Copy config file
echo "Copying openclaw configuration..."
cp /tmp/config/openclaw.json $OPENCLAW_HOME/openclaw.json

# Fix permissions on the PVC mount
echo "Setting ownership to 1000:1000..."
chown -R 1000:1000 $OPENCLAW_HOME
mkdir -p $OPENCLAW_WORKSPACE
chown -R 1000:1000 $OPENCLAW_WORKSPACE

echo "Setting permissions to 755..."
chmod -R 755 $OPENCLAW_HOME
chmod -R 755 $OPENCLAW_WORKSPACE

mkdir -p /etc/supervisor/conf.d
cp /tmp/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

echo "Initialization complete!"