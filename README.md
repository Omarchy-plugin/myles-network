# myles.network

Network management for the Omarchy bar: subnet warnings, resilient IPv4 recovery, profile backups, usage totals, and Proton VPN.

> **Derived work.** Forked from Omarchy's built-in `omarchy.network` and substantially modified.
> See [Credits](#credits) for licensing.

Wi-Fi and Ethernet management, with **active-subnet warnings**, resilient temporary IPv4
recovery, portable saved-network shortcuts, reliable profile backups, usage totals, and
Proton VPN control.

## What it does

- Lists saved Wi-Fi profiles separately from the current scan, so an out-of-range network is
  still visible and manageable.
- Warns when the active subnet looks like a hostile portal or captive network.
- Recovers a temporary (non-persistent) IPv4 address when the lease is lost.
- Ethernet details: speed, duplex, MAC, MTU, driver, and error counters.
- Host details: resolved DNS, IPv6, public address, firewall posture, Tailscale state.
- Throughput and latency sparkline history.
- Proton VPN connect/disconnect with an optional preferred country.
- Profile backup and restore to a portable JSON file.

## Shell scripts

| Script | Purpose |
| --- | --- |
| `net-scan.sh` | Trigger/restart the radio scan |
| `net-link.sh` | Link statistics, speed, duplex, counters |
| `net-profiles.sh` | Enumerate and order saved profiles |
| `net-extras.sh` | DNS, IPv6, public IP, firewall posture, Tailscale state |
| `proton-install.sh`, `proton-signin.sh` | Proton VPN CLI install and sign-in helpers |

## Network calls

- `http://ping.archlinux.org/nm-check.txt` — NetworkManager's own connectivity probe.
- `https://api.ipify.org` — public IP lookup. **Off by default**; enable with the
  `showPublicIp` setting.
- `https://account.proton.me/vpn` — printed as install guidance by the Proton helpers.

## State and portability

Settings and saved profiles live in:

```
~/.local/state/omarchy/myles-network/
```

The **Saved Setup** export is a portable JSON of *shortcut labels and your VPN preference*
only. It deliberately does **not** carry NetworkManager profiles or Wi-Fi passwords. On
import, Wi-Fi shortcuts match by **SSID** and wired shortcuts by **profile name** when a
matching UUID is not present — so create the local NetworkManager profile first, then
import.

## Privilege boundary

This plugin can query and change NetworkManager connections when you use its controls.

Saved-network passwords are never passed on the command line. The panel writes them to
`nmcli connection edit` on **stdin**, because argv is world-readable in `/proc`.

## Install

```bash
omarchy plugin add https://github.com/Omarchy-plugin/myles-network.git --enable --yes
```

That clones, validates, installs to `~/.config/omarchy/plugins/myles.network/`, and places it on your bar.

The stock `omarchy.network` widget does the same job and will fight with this one. Turn it off:

```bash
omarchy plugin disable omarchy.network
```

## Update

```bash
omarchy plugin update myles.network --yes
```

Or update every git-managed plugin at once:

```bash
omarchy plugin update --yes
```

## Uninstall

omarchy plugin enable omarchy.network   # if you want the built-in back

omarchy plugin remove myles.network --yes

## Installing the whole suite

Every plugin in the suite installs with one command, and updates itself
automatically:

```bash
git clone https://github.com/Omarchy-plugin/myles-omarchy-plugins.git
cd myles-omarchy-plugins && ./install.sh
```

See [myles-omarchy-plugins](../myles-omarchy-plugins) for the update mechanism.

## Credits

- Omarchy — <https://omarchy.org> — MIT, © David Heinemeier Hansson. `omarchy.network` is the base this is forked from.
- Mylesoft — <https://github.com/Omarchy-plugin> — modifications.

Plugins run unsandboxed inside the long-lived `omarchy-shell` process with your user
permissions. Review the source before enabling anything you did not write.
