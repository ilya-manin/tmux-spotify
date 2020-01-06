#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH="/usr/local/bin:$PATH:/usr/sbin"

open_spotify() {
  $(open -a Spotify)
}

toggle_play_pause() {
  $(osascript -e "tell application \"Spotify\" to playpause")
}

previous_track() {
  $(osascript -e "tell application \"Spotify\" to previous track")
}

next_track() {
  $(osascript -e "tell application \"Spotify\" to next track")
}

toggle_repeat() {
  if [ "$1" == "true" ]; then
    $(osascript -e "tell application \"Spotify\" to set repeating to false")
  else
    $(osascript -e "tell application \"Spotify\" to set repeating to true")
  fi
}

toggle_shuffle() {
  if [ "$1" == "true" ]; then
    $(osascript -e "tell application \"Spotify\" to set shuffling to false")
  else
    $(osascript -e "tell application \"Spotify\" to set shuffling to true")
  fi
}

show_menu() {
  local arr=""
  IFS=$'\n' arr=($(osascript "$CURRENT_DIR/../apple_scripts/get_current_state.applescript"))
  local is_repeat_on=${arr[0]}
  local is_shuffle_on=${arr[1]}
  local artist=${arr[2]}
  local track_name=${arr[3]}
  local album=${arr[4]}
  local id=${arr[5]}

  local repeating_label=""
  local shuffling_label=""

  if [ "$is_repeat_on" == "true" ]; then
    repeating_label="Turn off repeat"
  else
    repeating_label="Turn on repeat"
  fi

  if [ "$is_shuffle_on" == "true" ]; then
    shuffling_label="Turn off shuffle"
  else
    shuffling_label="Turn on shuffle"
  fi

  if [ "$id" == "" ]; then
    $(tmux display-menu -T "#[align=centre fg=green]Spotify" -x R -y P \
        "Open Spotify"     o "run -b 'source \"$CURRENT_DIR/spotify.sh\" && open_spotify'" \
        "" \
        "Close menu"       q "" \
    )
  elif [[ $id == *":episode:"* ]]; then
    $(tmux display-menu -T "#[align=centre fg=green]Spotify" -x R -y P \
        "" \
        "-#[nodim]Episode: $track_name" "" "" \
        "-#[nodim]Podcast: $album"      "" "" \
        "" \
        "Copy URL"         c "run -b 'printf \"%s\" $id | pbcopy'" \
        "Open Spotify"     o "run -b 'source \"$CURRENT_DIR/spotify.sh\" && open_spotify'" \
        "Play/Pause"       p "run -b 'source \"$CURRENT_DIR/spotify.sh\" && toggle_play_pause'" \
        "Previous"         b "run -b 'source \"$CURRENT_DIR/spotify.sh\" && previous_track'" \
        "Next"             n "run -b 'source \"$CURRENT_DIR/spotify.sh\" && next_track'" \
        "$repeating_label" r "run -b 'source \"$CURRENT_DIR/spotify.sh\" && toggle_repeat $is_repeat_on'" \
        "$shuffling_label" s "run -b 'source \"$CURRENT_DIR/spotify.sh\" && toggle_shuffle $is_shuffle_on'" \
        "" \
        "Close menu"       q "" \
    )
  else
    $(tmux display-menu -T "#[align=centre fg=green]Spotify" -x R -y P \
        "" \
        "-#[nodim]Track: $track_name" "" "run -b 'printf \"%s\" $quoted_track_name | pbcopy'" \
        "-#[nodim]Artist: $artist"    "" "" \
        "-#[nodim]Album: $album"      "" "" \
        "" \
        "Copy URL"         c "run -b 'printf \"%s\" $id | pbcopy'" \
        "Open Spotify"     o "run -b 'source \"$CURRENT_DIR/spotify.sh\" && open_spotify'" \
        "Play/Pause"       p "run -b 'source \"$CURRENT_DIR/spotify.sh\" && toggle_play_pause'" \
        "Previous"         b "run -b 'source \"$CURRENT_DIR/spotify.sh\" && previous_track'" \
        "Next"             n "run -b 'source \"$CURRENT_DIR/spotify.sh\" && next_track'" \
        "$repeating_label" r "run -b 'source \"$CURRENT_DIR/spotify.sh\" && toggle_repeat $is_repeat_on'" \
        "$shuffling_label" s "run -b 'source \"$CURRENT_DIR/spotify.sh\" && toggle_shuffle $is_shuffle_on'" \
        "" \
        "Close menu"       q "" \
    )
  fi
}
