# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ZIG_SLOT="0.16"

inherit git-r3 zig

DESCRIPTION="A minimal tiling window manager for the river compositor"
HOMEPAGE="https://github.com/zarnuq/reach"
EGIT_REPO_URI="https://github.com/zarnuq/reach.git"

LICENSE="GPL-3.0-or-later"
SLOT="0"

RDEPEND="
	>=gui-wm/river-0.4.5
	dev-libs/wayland
	x11-libs/pixman
	x11-libs/libxkbcommon
	media-libs/fcft
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/wayland-scanner
	dev-libs/wayland-protocols
"

src_unpack() {
	git-r3_src_unpack
	# Fetch build.zig.zon deps; src_prepare then switches to offline --system mode.
	zig_live_src_unpack
}

src_install() {
	zig_src_install

	# System-default runtime config (CONFIG_PROTECT'd). reach reads, first found:
	# $XDG_CONFIG_HOME/reach/config.zon, ~/.config/reach/config.zon, /etc/reach/config.zon.
	insinto /etc/reach
	newins config.example.zon config.zon
	dodoc config.example.zon
}
