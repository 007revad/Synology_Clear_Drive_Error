# Synology Clear Drive Error

<a href="https://github.com/007revad/Synology_Clear_Drive_Error/releases"><img src="https://img.shields.io/github/release/007revad/Synology_Clear_Drive_Error.svg"></a>
![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_clear_drive_error&label=Visitors&icon=github&color=%23198754&message=&style=flat&tz=Australia%2FSydney)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/007revad)
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
<!-- [![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad) -->

### Description

Clear [critical drive errors](critical-drive.md) so DSM will let you use the drive

If DSM decides a drive is critical DSM stores "status critical" in a database and will not let you use the drive again. If you run an extended S.M.A.R.T. test on the drive in a computer and it says there is nothing wrong with the drive DSM will still refuse to let you use the drive. You can use this script on the Synology to delete that drive's "status critical" entries from DSM's database. Then DSM will let you use the drive again.

**NOTE** The script does **not** fix a faulty drive.

### If this script does not work use the following method:

**NAS with hotswap drive bays:** 
1. Open Storage Manager and select the drive.
2. Click on Actions then select Deactivate.
3. Remove the drive from the NAS.
4. Reboot.
5. Insert the drive.
6. Open Storage Manager and click on Repair.
7. Select the drive, click Next then Repair.

**NVMe drives or NAS without hotswap drive bays:** 
1. Open Storage Manager and select the drive.
2. Click on Actions then select Deactivate.
3. Shut down the NAS.
4. Remove the drive from the NAS.
5. Boot the NAS.
6. Shut down the NAS.
7. Insert the drive.
8. Boot the NAS.
9. Open Storage Manager and click on Repair.
10. Select the drive, click Next then Repair.

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

