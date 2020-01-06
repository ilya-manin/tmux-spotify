if (get running of application "Spotify") then
  tell application "Spotify"
    set track_info to ""
    set track_info to track_info & repeating & "\n"
    set track_info to track_info & shuffling & "\n"
    set track_info to track_info & artist of current track & " \n"
    set track_info to track_info & name of current track & "\n"
    set track_info to track_info & album of current track & "\n"
    set track_info to track_info & id of current track & "\n"
    return track_info
  end tell
else
  return ""
end if
