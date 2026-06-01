# Brave macOS Hardening

Small script I made to apply a few Brave Browser policies on macOS.

It disables stuff I do not use, like:

* Tor
* Brave VPN
* Brave Wallet / crypto
* Brave Rewards
* Brave Leo
* Brave News
* Brave Talk
* Speedreader
* Wayback Machine prompt

## Why

I wanted Brave to feel cleaner on macOS without manually changing the same settings again after a restart.

The script applies the policies, then sets up a LaunchAgent so they get applied again when you log in.

## Install

Clone the repo:

```bash
git clone https://github.com/Jackb-cs/Brave-Macos-Hardening.git
```

Go into the folder:

```bash
cd Brave-Macos-Hardening
```

Make the script executable:

```bash
chmod +x brave-macos-policy-hardening.sh
```

Run it:

```bash
./brave-macos-policy-hardening.sh
```

macOS may ask for your password because some of the policy files are written to `/Library`.

## Check

Open Brave and go to:

```text
brave://policy
```

Click **Reload policies**.

If it worked, the policies should show there.

## What it changes

The script writes Brave policy files here:

```text
/Library/Managed Preferences/com.brave.Browser.plist
/Library/Managed Preferences/<your-username>/com.brave.Browser.plist
```

It also creates a LaunchAgent in your user Library so the script runs at login.

## Notes

Brave may show **Managed by your organization** after running this. That is normal. It just means the browser is being controlled by local policies on your Mac.

This does not install anything, download anything, or touch your bookmarks, passwords, history, or extensions.

## License

MIT
