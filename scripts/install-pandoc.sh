#!/bin/sh
# Install a pinned pandoc under ~/.local when the build machine has none.
# Used by the root Makefile: the Cloudflare Pages build image has no pandoc,
# and cv/ needs it. The download is checked against a pinned SHA-256.
set -eu

version=3.11
sha256_amd64=37edb3bbcf722f921a009941bf5874e2e0c09263226c9b4a2d980788cb062ab6
sha256_arm64=56ed5566ec41d22ec9ee0704e6ac0b98ba102e92384efd5306173a22d314c79a

dest=${1:-$HOME/.local}

case "$(uname -m)" in
	x86_64) arch=amd64; sum=$sha256_amd64 ;;
	aarch64 | arm64) arch=arm64; sum=$sha256_arm64 ;;
	*) echo "install-pandoc: no pandoc build for $(uname -m)" >&2; exit 1 ;;
esac

file=pandoc-$version-linux-$arch.tar.gz
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "installing pandoc $version ($arch) into $dest"
curl -fsSL -o "$tmp/$file" "https://github.com/jgm/pandoc/releases/download/$version/$file"
(cd "$tmp" && echo "$sum  $file" | sha256sum -c -)
mkdir -p "$dest"
tar -xzf "$tmp/$file" -C "$dest" --strip-components=1
