#!/bin/bash
# Usage: $0 input.deb output.deb
# Needed envs:
#   PUBKEY - the public key path
#   KEYID (Optional) - the key ID to be added to apt, default aquanjsw
#   REPO (Optional) - the repo name, default ubuntu
#   
# In-place modification is allowed.

set -euo pipefail

tmpdir="$(mktemp -d)"
src="$1"
unpacked="$tmpdir/unpacked"
dst="$2"

pubkey="$(<$PUBKEY)"
keyid="${KEYID:-aquanjsw}"
repo="${REPO:-ubuntu}"

dpkg-deb -R "$src" "$unpacked"

cat > "$unpacked/DEBIAN/postinst" <<EOF
#!/bin/sh

set -e

gpg --yes --dearmor -o /etc/apt/trusted.gpg.d/$keyid.gpg - <<EOL
$pubkey
EOL

add-apt-repository -S deb https://aquanjsw.github.io/files/$repo stable main
EOF

chmod +x "$unpacked/DEBIAN/postinst"

cat >> "$unpacked/DEBIAN/control" <<EOF
Depends: gnupg, software-properties-common
EOF

dpkg-deb -b "$unpacked" "$dst"
rm -rf "$tmpdir"
