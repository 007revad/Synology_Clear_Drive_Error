#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Clear drive critical errors so DSM will let you use the drive
#
# GitHub: https://github.com/007revad/Synology_clear_drive_error
# Script verified at https://www.shellcheck.net/
#
# To run in a shell (replace /volume1/scripts/ with path to script):
# sudo /volume1/scripts/syno_clear_drive_error.sh
#------------------------------------------------------------------------------
# References:
# https://new.reddit.com/r/synology/comments/1cdco8a/critical_drive_error/
# https://community.synology.com/enu/forum/1/post/151784?page=1&sort=oldest
# 
# https://www.squash.io/executing-multiple-sqlite-statements-in-bash-scripts-on-linux/
# https://www.tutorialspoint.com/sqlite/sqlite_and_or_clauses.htm
#------------------------------------------------------------------------------

file="/var/log/synolog/.SYNODISKDB"
msg="status_critical"
level="err"

scriptver="v1.0.3"
script=Synology_Clear_Drive_Error
repo="007revad/Synology_Clear_Drive_Error"

# Show script version
#echo -e "$script $scriptver\ngithub.com/$repo\n"
echo "$script $scriptver"

# Shell Colors
#Black='\e[0;30m'   # ${Black}
#Red='\e[0;31m'     # ${Red}
#Green='\e[0;32m'   # ${Green}
#Yellow='\e[0;33m'  # ${Yellow}
#Blue='\e[0;34m'    # ${Blue}
#Purple='\e[0;35m'  # ${Purple}
Cyan='\e[0;36m'     # ${Cyan}
#White='\e[0;37m'   # ${White}
Error='\e[41m'      # ${Error}
Off='\e[0m'         # ${Off}

ding(){ 
    printf \\a
}

# Check script is running as root
if [[ $( whoami ) != "root" ]]; then
    ding
    echo -e "\n${Error}ERROR${Off} This script must be run as sudo or root!\n"
    exit 1  # Not running as root
fi


if [[ ! -f "$file" ]]; then
    ding
    echo -e "\n${Error}ERROR${Off} $file not found!\n"
    exit 1
fi

#------------------------------------------------------------------------------
# Check latest release with GitHub API

# Get latest release info
# Curl timeout options:
# https://unix.stackexchange.com/questions/94604/does-curl-have-a-timeout
#release=$(curl --silent -m 10 --connect-timeout 5 \
#    "https://api.github.com/repos/$repo/releases/latest")

# Use wget to avoid installing curl in Ubuntu
release=$(wget -qO- -q --connect-timeout=5 \
    "https://api.github.com/repos/$repo/releases/latest")

# Release version
tag=$(echo "$release" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
#shorttag="${tag:1}"

if ! printf "%s\n%s\n" "$tag" "$scriptver" |
        sort --check=quiet --version-sort >/dev/null ; then
    echo -e "\n${Cyan}There is a newer version of this script available.${Off}"
    echo -e "Current version: ${scriptver}\nLatest version:  $tag"
fi

#------------------------------------------------------------------------------

# Assign status_critical entries to array
readarray -t tmp_array < <(sqlite3 "${file}" <<EOF
SELECT * FROM logs WHERE level ="${level}" AND msg ="${msg}";
.quit
EOF
)

# Get number of status_critical entries found
found="${#tmp_array[@]}"

# Assign drive|serial to array
for e in "${tmp_array[@]}"; do
    c=$(echo "$e" | cut -d"|" -f5-6)
    if [[ $c != "|" ]]; then
        new_array+=("$c")
    fi
done

# Sort array into new array to remove duplicates
if [[ ${#new_array[@]} -gt "0" ]]; then
    while IFS= read -r -d '' x; do
        sorted_array+=("$x")
    done < <(printf "%s\0" "${new_array[@]}" | sort -uz)
fi

if [[ ${#sorted_array[@]} -lt 1 ]]; then
    # Exit if no status_critical entries found
    echo -e "\n${#sorted_array[@]} $msg entries found\n"
    exit 1
else
    # Show number of status_critical entries found
    echo -e "\n$found $msg entries found"
fi

# Let user select drive
echo -e "\n[Drive Model|Serial Number]"
PS3="Select the drive: "
select choice in "${sorted_array[@]}"; do
    case "$choice" in
        Quit)
            exit
        ;;
        *\|*)
            model=$(echo "$choice" | cut -d"|" -f1)
            serial=$(echo "$choice" | cut -d"|" -f2)
            echo -e "You selected ${Cyan}$model${Off} with serial number ${Cyan}$serial${Off}"
            break
        ;;
        *)
            ding
            echo -e "Invalid choice!"
        ;;
    esac
done

# Delete matching entries of selected drive
echo -e "\nEditing sqlite database"
sqlite3 "${file}" <<EOF
DELETE FROM logs WHERE level ="${level}" AND msg ="${msg}" AND serial ="${serial}";
.quit
EOF

code="$?"
echo -e "sqlite3 exit code: $code"

#echo -e "\nserial: $serial\n"  # debug

# Get remaining number of status_critical entries
readarray -t edited_array < <(sqlite3 "${file}" <<EOF
SELECT * FROM logs WHERE level ="${level}" AND msg ="${msg}";
.quit
EOF
)

#echo -e "\nfound: $found"                       # debug
#echo "after edit: ${#edited_array[@]}"          # debug
#echo "edited: $((found -${#edited_array[@]}))"  # debug

# Show result
#echo "${#edited_array[@]} entries after deletion"
if [[ $found -gt "${#edited_array[@]}" ]]; then
    deleted=$((found -${#edited_array[@]}))
    if [[ $deleted -eq "0" ]]; then
        echo -e "\n$deleted $msg entry deleted"
    else
        echo -e "\n$deleted $msg entries deleted"
    fi
    echo -e "\nYou can now use ${Cyan}$model${Off} with serial number ${Cyan}$serial${Off}"
    echo -e "\nIf Storage Manager is already open, close it then open it again.\n"
else
    echo -e "\nNo staus_critical entries were deleted!"
    echo -e "\n${#edited_array[@]} $msg entries remain\n"
fi

exit

