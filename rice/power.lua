local power = {}

power.timer = {
    default_timeout = 3600,
    minimum_timeout = 15,
    alert_threshold = 60,
}

power.commands = {
    shutdown = "systemctl poweroff",
    reboot = "systemctl reboot",
    suspend = "systemctl suspend",
    kill_session = "loginctl kill-session ''",
    lock_session = "loginctl lock-session",
    -- lock_screen = "light-locker-command --lock",
    lock_screen = "i3lock -i $XDG_CONFIG_HOME/awesome/theme/wallpaper/Desktop-Burberry-Photos.jpg",
}

return power
