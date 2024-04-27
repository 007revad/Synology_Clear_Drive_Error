# Synology clear drive error
Clear drive critical errors so DSM will let you use the drive

If a drive gets kicked out of RAID DSM stores "status critical" in a database and will not let you use the drive again. If you test the drive in a computer and find there is nothing wrong with the drive you can use this script on the Synology to delete that drive's "status critical" entries from DSM's database.

## How to run the script

### Run the script via SSH

[How to enable SSH and login to DSM via SSH](https://kb.synology.com/en-global/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)

Run the script:

```bash
sudo -s /volume1/scripts/syno_clear_drive_error.sh
```

> **Note** <br>
> Replace /volume1/scripts/ with the path to where the script is located.

## Screenshots

<p align="center">Clearing critical error for 2 drives</p>
<p align="center"><img src="/images/script.png"></p>
