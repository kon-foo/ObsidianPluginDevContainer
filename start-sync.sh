#!/bin/bash

# Path to your plugin files in the container
PLUGIN_DIR="/workspace"

# Path to the plugin directory in the test vault
VAULT_PLUGIN_DIR="/workspace/ObsidianPluginTestVault/.obsidian/plugins/my-plugin"

# Function to sync files
sync_files() {
  # Check if main.js exists before attempting to sync
  if [ -f "${PLUGIN_DIR}/main.js" ]; then
    cp "${PLUGIN_DIR}/main.js" "${VAULT_PLUGIN_DIR}/main.js"
    cp "${PLUGIN_DIR}/manifest.json" "${VAULT_PLUGIN_DIR}/manifest.json"
  else
    echo "main.js does not exist yet. Waiting for the first build..."
  fi
}

# Check if the VAULT_PLUGIN_DIR exists
if [ ! -d "$VAULT_PLUGIN_DIR" ]; then
  echo "Warning: Vault plugin directory (${VAULT_PLUGIN_DIR}) does not exist. Syncing will not proceed."
  exit 1
fi

# Continuous watch and sync
# Using a fallback watch on the directory itself if main.js is not present yet.
while true; do
  # If main.js exists, watch for changes on it directly. Otherwise, watch the directory.
  if [ -f "${PLUGIN_DIR}/main.js" ]; then
    inotifywait -e close_write "${PLUGIN_DIR}/main.js" "${PLUGIN_DIR}/manifest.json"
  else
    inotifywait -e create,modify,delete,move "${PLUGIN_DIR}"
    # After any change in the directory, check and sync if main.js has been created.
    sync_files
    continue
  fi
  
  sync_files
done
