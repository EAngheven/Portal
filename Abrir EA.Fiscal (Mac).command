#!/bin/bash
# EA.Fiscal para macOS: instala o actualiza la aplicación y la abre.
ORIGEN="$(cd "$(dirname "$0")" && pwd)"
DESTINO="$HOME/Applications/EA.Fiscal"
if [ -d "$HOME/Applications/ConciliaMX" ] && [ ! -d "$DESTINO" ]; then mv "$HOME/Applications/ConciliaMX" "$DESTINO" && rm -f "$DESTINO/ConciliaMX.html" "$HOME/Desktop/ConciliaMX.command"; fi
DATOS="$DESTINO/datos"
mkdir -p "$DESTINO" "$DATOS"
if [ -f "$ORIGEN/EA.Fiscal.html" ] && [ "$ORIGEN" != "$DESTINO" ]; then
  cp -f "$ORIGEN/EA.Fiscal.html" "$DESTINO/EA.Fiscal.html"
  xattr -d com.apple.quarantine "$DESTINO/EA.Fiscal.html" 2>/dev/null
fi
if [ ! -f "$DESTINO/EA.Fiscal.html" ]; then
  echo "No se encontró EA.Fiscal.html. Descomprime todo el ZIP y vuelve a abrir este archivo."
  read -r -p "Presiona Enter para cerrar... " _
  exit 1
fi
if [ "$ORIGEN" != "$HOME/Desktop" ] && [ -d "$HOME/Desktop" ]; then
  cp -f "$0" "$HOME/Desktop/EA.Fiscal.command" && chmod +x "$HOME/Desktop/EA.Fiscal.command"
  xattr -d com.apple.quarantine "$HOME/Desktop/EA.Fiscal.command" 2>/dev/null
fi
URL="file://$(printf '%s' "$DESTINO/EA.Fiscal.html" | sed 's/%/%25/g; s/ /%20/g')"
APP=""
for a in "/Applications/Google Chrome.app" "$HOME/Applications/Google Chrome.app" "/Applications/Microsoft Edge.app" "$HOME/Applications/Microsoft Edge.app" "/Applications/Chromium.app"; do
  if [ -d "$a" ]; then APP="$a"; break; fi
done
if [ -n "$APP" ]; then
  open -na "$APP" --args --app="$URL" --user-data-dir="$DATOS" --no-first-run --no-default-browser-check
  echo "EA.Fiscal se abrió. Puedes cerrar esta ventana de Terminal."
  echo "La próxima vez usa el archivo EA.Fiscal del Escritorio."
else
  echo "No se encontró Google Chrome ni Microsoft Edge."
  echo "Instala cualquiera de los dos (son gratuitos) y vuelve a abrir este archivo."
  read -r -p "Presiona Enter para cerrar... " _
fi
