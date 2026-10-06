# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# a dependency sets rust-version = "1.88.0"
RUST_MIN_VER="1.88.0"

inherit cargo git-r3 optfeature

DESCRIPTION="Terminal file manager with previews"
HOMEPAGE="https://github.com/zarnuq/lazi"
EGIT_REPO_URI="https://github.com/zarnuq/lazi.git"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD MIT Unicode-3.0 Unlicense ZLIB"
SLOT="0"
# live ebuild: no KEYWORDS

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install --path crates/lazi
	# lazi has no built-in defaults; this is the config it falls back to.
	insinto /etc/xdg/lazi
	doins crates/lazi/config.ron
}

pkg_postinst() {
	optfeature "copying paths to the clipboard" gui-apps/wl-clipboard
	optfeature "the fzf jump picker" app-shells/fzf
	optfeature "trashing across filesystems" dev-libs/glib
}
