#!/usr/bin/env bash
set -e

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xfce4 xfce4-goodies \
  tigervnc-standalone-server novnc websockify \
  openjdk-21-jre mesa-utils \
  dbus-x11 curl wget unzip procps

mkdir -p "$HOME/.vnc"
printf '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4\n' > "$HOME/.vnc/xstartup"
chmod +x "$HOME/.vnc/xstartup"

cat > "$HOME/start-desktop.sh" <<'EOF'
#!/usr/bin/env bash
mkdir -p "$HOME/.vnc"
vncserver :1 -localhost yes -geometry 1280x720 -depth 24
websockify --web=/usr/share/novnc/ 6080 localhost:5901
EOF

cat > "$HOME/check-gpu.sh" <<'EOF'
#!/usr/bin/env bash
echo "=== Java ==="
java -version
echo "=== GPU ==="
lspci | grep -Ei 'vga|3d|display' || true
command -v nvidia-smi >/dev/null && nvidia-smi || true
command -v glxinfo >/dev/null && glxinfo -B || true
EOF

chmod +x "$HOME/start-desktop.sh" "$HOME/check-gpu.sh"
echo "Setup selesai. Jalankan ~/start-desktop.sh"
