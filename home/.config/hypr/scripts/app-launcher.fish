#!/bin/fish
# Native Fish TUI Launcher - Optimized Version

set -l CACHE_FILE "$HOME/.cache/fzf_launcher_cache"
set -l HISTORY_FILE "$HOME/.cache/fzf_launcher_history" # Legacy/Backup
mkdir -p (dirname "$CACHE_FILE") (dirname "$HISTORY_FILE")

# APPS_DIRS to scan
set -l APPS_DIRS \
    /usr/share/applications \
    $HOME/.local/share/applications \
    /var/lib/flatpak/exports/share/applications \
    $HOME/.local/share/flatpak/exports/share/applications

# Check if we need to rebuild the cache
set -l REBUILD false
if not test -f "$CACHE_FILE"
    set REBUILD true
else
    for dir in $APPS_DIRS
        if test -d "$dir"; and test (find "$dir" -newer "$CACHE_FILE" -print -quit 2>/dev/null)
            set REBUILD true
            break
        end
    end
end

if test "$REBUILD" = "true"
    # To preserve existing counts during rebuild, we'll read the old cache into a variable
    set -l OLD_COUNTS
    if test -f "$CACHE_FILE"
        set OLD_COUNTS (awk -F'\t' '{print $1"\t"$2}' "$CACHE_FILE")
    end

    set -l TEMP_CACHE (mktemp)
    for dir in $APPS_DIRS
        if test -d "$dir"
            for file in "$dir"/*.desktop
                if test -f "$file"; and grep -q "^Type=Application" "$file"; and not grep -q "^NoDisplay=true" "$file"; and not grep -q "^Hidden=true" "$file"
                    set -l name (grep -m 1 "^Name=" "$file" | cut -d= -f2-)
                    set -l cmd (grep -m 1 "^Exec=" "$file" | cut -d= -f2- | sed -E 's/[[:space:]]*%([a-zA-Z])//g' | sed 's/^"//; s/"$//')
                    set -l desc (grep -m 1 "^Comment=" "$file" | cut -d= -f2- | sed 's/^"//; s/"$//')
                    set -l try_exec (grep -m 1 "^TryExec=" "$file" | cut -d= -f2-)

                    if test -n "$try_exec"
                        if string match -q "/*" -- "$try_exec"
                            test -x "$try_exec"; or continue
                        else
                            command -sq -- "$try_exec"; or continue
                        end
                    end

                    if grep -q "^Terminal=true" "$file"
                        set cmd "kitty -e $cmd"
                    end
                    
                    test -z "$desc"; and set desc "No description available."

                    # Find existing count or default to 0
                    set -l count "00000"
                    if set -l match (printf "%s\n" $OLD_COUNTS | grep -F "$name\t")
                        set count (printf "%s" $match | cut -f1)
                    end

                    if test -n "$name"; and test -n "$cmd"
                        printf "%s\t%s\t%s\t%s\n" "$count" "$name" "$cmd" "$desc" >> "$TEMP_CACHE"
                    end
                end
            end
        end
    end
    sort -t\t -u -k2,2 "$TEMP_CACHE" > "$CACHE_FILE"
    rm "$TEMP_CACHE"
end

set -l TAB (printf "\t")

# Use fzf to select. Note: we sort the cache file by the first column (count) descending.
set -l SELECTED (sort -rn "$CACHE_FILE" | fzf \
    --prompt="Launch > " \
    --layout=reverse --border=rounded --margin=5%,10% \
    --delimiter="$TAB" \
    --with-nth=2 \
    --no-sort \
    --header="Ranked Applications" \
    --preview "echo 'Cmd:  {3}'; echo ''; echo 'Desc: {4}'" \
    --preview-window="right:50%:wrap:border-left")

if test -n "$SELECTED"
    set -l fields (string split \t -- "$SELECTED")
    set -l COUNT "$fields[1]"
    set -l NAME "$fields[2]"
    set -l CMD "$fields[3]"
    
    # Increment rank in cache file efficiently using awk
    set -l NEW_COUNT (math $COUNT + 1)
    set -l PADDED_COUNT (printf "%05d" $NEW_COUNT)
    
    # Update cache file in place
    set -l TEMP_UPDATE (mktemp)
    awk -v name="$NAME" -v new_count="$PADDED_COUNT" -F'\t' 'BEGIN {OFS="\t"} $2 == name {$1 = new_count} {print}' "$CACHE_FILE" > "$TEMP_UPDATE"
    mv "$TEMP_UPDATE" "$CACHE_FILE"

    # Also log to history for posterity
    echo "$NAME" >> "$HISTORY_FILE"
    
    # Launch
    hyprctl eval "hl.exec_cmd([==[uwsm app -- $CMD]==])"
end