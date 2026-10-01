# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# egui/eframe 0.36 set rust-version = "1.95"
RUST_MIN_VER="1.95.0"

inherit cargo git-r3

DESCRIPTION="Graphical dependency-graph browser for Gentoo Portage"
HOMEPAGE="https://github.com/zarnuq/gendtree"
EGIT_REPO_URI="https://github.com/zarnuq/gendtree.git"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 ISC OFL-1.1 UbuntuFontLicense-1.0 Unicode-3.0 ZLIB"
SLOT="0"
# live ebuild: no KEYWORDS
IUSE="wayland X"
REQUIRED_USE="|| ( wayland X )"

# Both backends are always compiled in; winit and glutin dlopen these at runtime.
RDEPEND="
	media-libs/libglvnd
	x11-libs/libxkbcommon[X?]
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXrandr
	)
"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}
