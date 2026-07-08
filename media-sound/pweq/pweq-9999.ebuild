# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit git-r3 python-single-r1

DESCRIPTION="Tkinter GUI to generate PipeWire filter-chain parametric EQ sinks"
HOMEPAGE="https://github.com/zarnuq/pweq"
EGIT_REPO_URI="https://github.com/zarnuq/pweq.git"

LICENSE="MIT"
SLOT="0"
# live ebuild: no KEYWORDS (mask with '*/*::zarnuq **' as you already do)

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# stdlib-only script; the only hard needs are a Python built with tkinter and
# PipeWire at runtime (the script shells out to the pw-* tools).
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-lang/python[tk]
	')
	media-video/pipewire
"

src_install() {
	# installs pweq-gen.py as /usr/bin/pweq with the shebang fixed to the
	# selected Python target
	python_newscript pweq-gen.py pweq
	einstalldocs
}
