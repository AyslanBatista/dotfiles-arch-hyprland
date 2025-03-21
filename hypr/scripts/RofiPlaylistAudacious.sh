#!/usr/bin/env bash
#
# Script name: dmconf
# Description: Choose from a list of configuration files to edit.
# Dependencies: dmenu
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# Contributors: Derek Taylor

# Defining the text editor to use.
# DMENUEDITOR="vim"
# DMENUEDITOR="leafpad"
DMEDITOR="audacious"


# An array of options to choose.
# You can edit this list to add/remove config files.
declare -a options=(
"Black - $HOME/Music/Playlist/Black.xspf"
"Louvores - $HOME/Music/Playlist/Louvores.xspf"
"FundoMusical - $HOME/Music/Playlist/FundoMusical.xspf"
"DioneiVieira - $HOME/Music/Playlist/DioneiVieira.xspf"
"NewsDionei - $HOME/Music/Playlist/NewsDionei.xspf"
"RapJesus - $HOME/Music/Playlist/RapJesus.xspf"
"RapNacional - $HOME/Music/Playlist/RapNacional.xspf"
"quit"
)

# Piping the above array into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i  20 -p files: 'Edit config:')

# What to do when/if we choose 'quit'.
if [[ "$choice" == "quit" ]]; then
    echo "Program terminated." && exit 1

# What to do when/if we choose a file to edit.
elif [ "$choice" ]; then
	cfg=$(printf '%s\n' "${choice}" | awk '{print $NF}')
	$DMEDITOR "$cfg"

# What to do if we just escape without choosing anything.
else
    echo "Program terminated." && exit 1
fi
