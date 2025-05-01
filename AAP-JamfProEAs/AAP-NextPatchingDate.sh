#!/bin/bash

AAP_folder="/Library/Management/AppAutoPatch"
AAP_plist="${AAP_folder}/xyz.techitout.appAutoPatch" # No trailing ".plist"

if [[ -f "${AAP_plist}.plist" ]]; then
  # Read and clean values
  patchingCompleteDate=$(defaults read "${AAP_plist}" AAPPatchingCompleteDate 2>/dev/null | sed 's/.\{6\}$//')
  daysUntilReset=$(defaults read "${AAP_plist}" DaysUntilReset 2>/dev/null | tr -d '[:space:]')

  # Validate both values
  if [[ -n "$patchingCompleteDate" && "$daysUntilReset" =~ ^[0-9]+$ ]]; then
    # Convert input date to epoch
    patch_epoch=$(date -j -f "%Y-%m-%d %H:%M:%S" "$patchingCompleteDate" "+%s")

    # Add days in seconds
    next_epoch=$((patch_epoch + (daysUntilReset * 86400)))

    # Convert back to desired format
    nextRunDate=$(date -j -r "$next_epoch" "+%Y-%m-%d %H:%M:%S")
    echo "<result>${nextRunDate}</result>"
  else
    echo "<result>Invalid data in plist</result>"
  fi
else
  echo "<result>No AAP preference file.</result>"
fi

exit 0
