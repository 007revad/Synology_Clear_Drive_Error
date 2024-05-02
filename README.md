# Synology Clear Drive Error

<a href="https://github.com/007revad/Synology_Clear_Drive_Error/releases"><img src="https://img.shields.io/github/release/007revad/Synology_Clear_Drive_Error.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_Clear_Drive_Error&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views&edge_flat=false"/></a>
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/007revad)
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
[![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad)

### Description

Clear [critical drive errors](critical-drive.md) so DSM will let you use the drive

If DSM decides a drive is critical DSM stores "status critical" in a database and will not let you use the drive again. If you run an extended S.M.A.R.T. test on the drive in a computer and it says there is nothing wrong with the drive DSM will still refuse to let you use the drive. You can use this script on the Synology to delete that drive's "status critical" entries from DSM's database. Then DSM will let you use the drive again.

**NOTE** The script does **not** fix a faulty drive.

## Download the script

1. Download the latest version _Source code (zip)_ from https://github.com/007revad/Synology_clear_drive_error/releases
2. Save the download zip file to a folder on the Synology.
3. Unzip the zip file.

## How to run the script

### Run the script via SSH

[How to enable SSH and login to DSM via SSH](https://kb.synology.com/en-global/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)

Run the script:

```bash
sudo -s /volume1/scripts/syno_clear_drive_error.sh
```

> **Note** <br>
> Replace /volume1/scripts/ with the path to where the script is located.

### After running the script

If Storage Manager is already open, close it and then open it again.

## Screenshots

<p align="center">Clearing critical error for 2 drives</p>
<p align="center"><img src="/images/script-4.png"></p>

