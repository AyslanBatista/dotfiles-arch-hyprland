#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Rofi Beats to play online Music or Locally save media files

# Variables
mDIR="$HOME/Music/"
playlistDIR="$HOME/Music/Playlist/"
iDIR="$HOME/.config/swaync/icons"
rofi_theme="$HOME/.config/rofi/config-rofi-Beats.rasi"
rofi_theme_1="$HOME/.config/rofi/config-rofi-Beats-menu.rasi"

# Online Stations. Edit as required
declare -A online_music=(
    ["YT - Instrumental BASS 😎🎶"]="https://youtube.com/playlist?list=PL9q0n3HNppU2S2V3K6JUCoewvnQ5D6Uag&si=Od8Iq1G3saNjqTFm"
    ["YT - Instrumental Louvor 🎻🎼"]="https://youtube.com/playlist?list=PL9q0n3HNppU0EcqSzwHV12pHMNb0fs9Ze&si=vCHA54-TZv1fnkNE"
    ["YT - Programming Music 🎧🎶"]="https://www.youtube.com/playlist?list=PLdnVyoeE0BGnv9XY8vEXwboZWWfNQEt2V"
    ["YT - lofi hip hop radio beats 📹🎶"]="https://www.youtube.com/live/jfKfPfyJRdk?si=PnJIA9ErQIAw6-qd"
    ["Radio - Lofi Girl 🎧🎶"]="https://play.streamafrica.net/lofiradio"
    ["Radio - Chillhop 🎧🎶"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
    ["YT - Wish 107.5 YT Pinoy HipHop 📻🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJnmgMYwCKid4XIFqUKBVWEs&si=vahW_noh4UDJ5d37"
    ["YT - Wish 107.5 YT Wishclusives 📹🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJn5B22H9HOWP3Kxxs-DkPSM&si=d_Ld2OKhGvpH48WO"
    ["YT - Relaxing Piano Music 🎹🎶"]="https://youtu.be/6H7hXzjFoVU?si=nZTPREC9lnK1JJUG"
    ["YT - Relaxing Piano Jazz Music 🎹🎶"]="https://youtu.be/85UEqRat6E4?si=jXQL1Yp2VP_G6NSn"
    ["Radio - Ibiza Global 🎧🎶"]="https://filtermusic.net/ibiza-global"
)

# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
    local_music=()
    filenames=()
    while IFS= read -r file; do
        local_music+=("$file")
        filenames+=("$(basename "$file")")
    done < <(find -L "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" \))
}

# Populate playlists array with .m3u files from the playlist directory
populate_playlists() {
    playlists=()
    playlist_names=()

    # Create the playlist directory if it doesn't exist
    mkdir -p "$playlistDIR"

    while IFS= read -r file; do
        playlists+=("$file")
        playlist_names+=("📋 $(basename "$file" .m3u)")
    done < <(find -L "$playlistDIR" -type f -iname "*.m3u")
}

# Function for displaying notifications
notification() {
    notify-send -u normal -i "$iDIR/music.png" " Now Playing:" " $@"
}

# Main function for playing local music
play_local_music() {
    populate_local_music

    # Prompt the user to select a song
    choice=$(printf "%s\n" "${filenames[@]}" | rofi -i -dmenu -config $rofi_theme)

    if [ -z "$choice" ]; then
        exit 1
    fi

    # Find the corresponding file path based on user's choice and set that to play the song then continue on the list
    for ((i = 0; i < "${#filenames[@]}"; ++i)); do
        if [ "${filenames[$i]}" = "$choice" ]; then

            notification "$choice"

            # Play the selected local music file using mpv
            mpv --playlist-start="$i" --loop-playlist --vid=no "${local_music[@]}"

            break
        fi
    done
}

# Main function for shuffling local music
shuffle_local_music() {
    notification "Shuffle Play local music"

    # Play music in $mDIR on shuffle
    mpv --shuffle --loop-playlist --vid=no "$mDIR"
}

# Main function for playing online music
play_online_music() {
    choice=$(for online in "${!online_music[@]}"; do
        echo "$online"
    done | sort | rofi -i -dmenu -config "$rofi_theme")

    if [ -z "$choice" ]; then
        exit 1
    fi

    link="${online_music[$choice]}"

    notification "$choice"

    # Play the selected online music using mpv
    mpv --shuffle --vid=no "$link"
}

# Main function for playing playlist files
play_playlists() {
    populate_playlists

    if [ ${#playlist_names[@]} -eq 0 ]; then
        notification "Nenhuma playlist encontrada em $playlistDIR"
        return
    fi

    # Prompt the user to select a playlist
    choice=$(printf "%s\n" "${playlist_names[@]}" | rofi -i -dmenu -config $rofi_theme)

    if [ -z "$choice" ]; then
        exit 1
    fi

    # Extract the playlist name without the 📋 icon
    playlist_name="${choice:2}"

    # Find the corresponding playlist file
    for ((i = 0; i < "${#playlist_names[@]}"; ++i)); do
        if [ "${playlist_names[$i]}" = "$choice" ]; then
            playlist_file="${playlists[$i]}"

            notification "Reproduzindo playlist: $playlist_name"

            # Play the selected playlist with mpv in shuffle mode
            mpv --shuffle --loop-playlist --vid=no "$playlist_file"

            break
        fi
    done
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -u low -i "$iDIR/music.png" "Music stopped" || {

    # Check if rofi is already running
    if pidof rofi >/dev/null; then
        pkill rofi
    fi

    # Esta é a parte que precisa ser corrigida, colocando todas as opções em uma única string
    user_choice=$(echo -e "Play from Playlists\nPlay from Online Stations\nPlay from Music directory\nShuffle Play from Music directory" | rofi -dmenu -config $rofi_theme_1)

    case "$user_choice" in
    "Play from Music directory")
        play_local_music
        ;;
    "Play from Online Stations")
        play_online_music
        ;;
    "Shuffle Play from Music directory")
        shuffle_local_music
        ;;
    "Play from Playlists")
        play_playlists
        ;;
    *)
        echo "Invalid choice"
        ;;
    esac
}
