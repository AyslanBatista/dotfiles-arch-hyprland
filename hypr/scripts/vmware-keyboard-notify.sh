#!/bin/bash

# Script para notificação de modo de teclado
# Salve como ~/scripts/vm-mode-notify.sh

# Arquivo para rastrear o estado atual
STATE_FILE="/tmp/keyboard_mode"

# Inicializa o arquivo de estado se não existir
if [ ! -f "$STATE_FILE" ]; then
  echo "hyprland" >"$STATE_FILE"
fi

# Lê o estado atual
CURRENT_MODE=$(cat "$STATE_FILE")

# Alterna o modo e envia a notificação apropriada
if [ "$CURRENT_MODE" = "hyprland" ]; then
  # Notificação para modo VM
  notify-send "⚠️ Modo VMware" "Atalhos do Hyprland Desativados!" -t 3000
  echo "vm" >"$STATE_FILE"
else
  # Notificação para modo Hyprland
  notify-send "✅ Modo Hyprland" "Atalhos do Hyprland Ativados!" -t 3000
  echo "hyprland" >"$STATE_FILE"
fi

exit 0
