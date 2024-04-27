#!/usr/bin/env bash
#
# References:
# https://new.reddit.com/r/synology/comments/1cdco8a/critical_drive_error/
# https://community.synology.com/enu/forum/1/post/151784?page=1&sort=oldest
# 
# https://www.squash.io/executing-multiple-sqlite-statements-in-bash-scripts-on-linux/
# https://www.tutorialspoint.com/sqlite/sqlite_and_or_clauses.htm

file="/var/log/synolog/.SYNODISKDB"
level=status_critical

if [[ ! -f "$file" ]]; then
    echo "$file not found!"
    exit 1
fi

# Assign status_critical entries to array
readarray -t tmp_array < <(sqlite3 "${file}" <<EOF
SELECT * FROM logs WHERE level ="${level}";
.quit
EOF
)

# Show number of status_critical entries found
found="${#tmp_array[@]}"
echo "$found status_critical entries found"

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

# Exit if no status_critical entries found
if [[ ${#sorted_array[@]} -lt 1 ]]; then
    echo "${#sorted_array[@]} status_critical entries found!"
    exit 1
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
            serial=$(echo "$choice" | cut -d"|" -f2)
            echo -e "You selected $choice"
            break
        ;;
        *)
            echo -e "Invalid choice!"
        ;;
    esac
done

# Delete matching entries of selected drive
sqlite3 "${file}" <<EOF
DELETE FROM logs WHERE level ="${level}" AND serial ="${serial}";
.quit
EOF

code="$?"
echo -e "\nsqlite3 exit code: $code"

#echo -e "\nserial: $serial\n"  # debug

# Get remaining number of status_critical entries
readarray -t edited_array < <(sqlite3 "${file}" <<EOF
SELECT * FROM logs WHERE level ="${level}";
.quit
EOF
)

#echo -e "\nfound: $found"                       # debug
#echo "after edit: ${#edited_array[@]}"          # debug
#echo "edited: $((found -${#edited_array[@]}))"  # debug

# Show result
#echo "${#edited_array[@]} entries after deletion"
if [[ $found -gt "${#edited_array[@]}" ]]; then
    echo -e "\n$((found -${#edited_array[@]})) status_critical entries deleted"
else
    echo -e "\n${#edited_array[@]} status_critical entries after deletion"
fi

exit

