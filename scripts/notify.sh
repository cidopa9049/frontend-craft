#!/usr/bin/env bash

case "$(uname -s)" in
    Darwin)
        osascript -e 'display notification "Claude Code 任务完成" with title "Claude Code"' 2>/dev/null || true
        ;;
    Linux)
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Claude Code" "Claude Code 任务完成" 2>/dev/null || true
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        powershell.exe -Command "
            \$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
            \$template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
            \$xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(\$template)
            \$text = \$xml.GetElementsByTagName('text')
            \$text[0].AppendChild(\$xml.CreateTextNode('Claude Code')) | Out-Null
            \$text[1].AppendChild(\$xml.CreateTextNode('Claude Code 任务完成')) | Out-Null
            \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
            [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$toast)
        " 2>/dev/null || true
        ;;
esac

exit 0
