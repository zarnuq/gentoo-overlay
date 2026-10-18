# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# edition 2024
RUST_MIN_VER="1.85.0"

inherit cargo desktop git-r3 xdg

DESCRIPTION="Burp Suite-style intercepting proxy for web app pentesting, with an egui UI"
HOMEPAGE="https://github.com/zarnuq/ferrite"
EGIT_REPO_URI="https://github.com/zarnuq/ferrite.git"

# upstream ships no license yet
LICENSE="all-rights-reserved"
SLOT="0"
RESTRICT="bindist mirror"

# eframe dlopen()s GL, wayland and xkbcommon at runtime; chromium is only
# needed for the "open browser" action.
RDEPEND="
	dev-libs/wayland
	media-libs/libglvnd
	x11-libs/libxkbcommon
"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install
	domenu assets/ferrite.desktop
	doicon -s scalable assets/ferrite.svg
}
