# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit git-r3 python-single-r1

DESCRIPTION="TUI dependency-graph browser for Gentoo Portage"
HOMEPAGE="https://github.com/zarnuq/gendtree"
EGIT_REPO_URI="https://github.com/zarnuq/gendtree.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""  # live ebuilds are never keyworded

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
    ${PYTHON_DEPS}
    $(python_gen_cond_dep '
        sys-apps/portage[${PYTHON_USEDEP}]
    ')
"

src_install() {
	python_setup
	newbin gendtree.py gendtree
	python_fix_shebang "${ED}"/usr/bin/gendtree
	einstalldocs
}
