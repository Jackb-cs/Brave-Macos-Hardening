#!/bin/bash
set -e

SCRIPT_PATH="$HOME/brave-policy-hardening.sh"
LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.local.brave.policy.hardening.plist"

cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/bash

POLICY_SYSTEM_DIR="/Library/Managed Preferences"
POLICY_USER_DIR="/Library/Managed Preferences/$(whoami)"
POLICY_SYSTEM_FILE="$POLICY_SYSTEM_DIR/com.brave.Browser.plist"
POLICY_USER_FILE="$POLICY_USER_DIR/com.brave.Browser.plist"

apply_policy_file() {
    local file="$1"
    local dir
    dir="$(dirname "$file")"

    sudo mkdir -p "$dir"
    sudo chown root:wheel "$dir"
    sudo chmod 755 "$dir"

    set_bool() {
        sudo /usr/libexec/PlistBuddy -c "Delete :$1" "$file" 2>/dev/null || true
        sudo /usr/libexec/PlistBuddy -c "Add :$1 bool $2" "$file"
    }

    set_bool "TorDisabled" true
    set_bool "BraveVPNDisabled" true
    set_bool "BraveWalletDisabled" true
    set_bool "BraveRewardsDisabled" true
    set_bool "BraveAIChatEnabled" false
    set_bool "BraveNewsDisabled" true
    set_bool "BraveTalkDisabled" true
    set_bool "BraveSpeedreaderEnabled" false
    set_bool "BraveWaybackMachineEnabled" false

    sudo chown root:wheel "$file"
    sudo chmod 644 "$file"
}

apply_policy_file "$POLICY_SYSTEM_FILE"
apply_policy_file "$POLICY_USER_FILE"

defaults write com.brave.Browser TorDisabled -bool true
defaults write com.brave.Browser BraveVPNDisabled -bool true
defaults write com.brave.Browser BraveWalletDisabled -bool true
defaults write com.brave.Browser BraveRewardsDisabled -bool true
defaults write com.brave.Browser BraveAIChatEnabled -bool false
defaults write com.brave.Browser BraveNewsDisabled -bool true
defaults write com.brave.Browser BraveTalkDisabled -bool true
defaults write com.brave.Browser BraveSpeedreaderEnabled -bool false
defaults write com.brave.Browser BraveWaybackMachineEnabled -bool false

sudo killall cfprefsd 2>/dev/null || true
EOF

chmod +x "$SCRIPT_PATH"

mkdir -p "$HOME/Library/LaunchAgents"

cat > "$LAUNCH_AGENT" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.brave.policy.hardening</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

launchctl unload "$LAUNCH_AGENT" 2>/dev/null || true
launchctl load "$LAUNCH_AGENT"

"$SCRIPT_PATH"
