# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Defguard CLI VPN client (WireGuard with MFA), no GUI/webkit"
HOMEPAGE="https://defguard.net/ https://github.com/DefGuard/client"

# Live: the newest release binary is fetched at build time (see src_unpack), so
# a re-emerge always pulls current. No SRC_URI/Manifest; not reproducible.
PROPERTIES="live"

# AGPL-3 open core + proprietary enterprise components bundled in the binary.
LICENSE="AGPL-3.0-or-later all-rights-reserved"
SLOT="0"
KEYWORDS=""

# network-sandbox off so curl can reach GitHub during src_unpack.
RESTRICT="network-sandbox mirror bindist strip test"
QA_PREBUILT="usr/sbin/dg"

BDEPEND="net-misc/curl"

S="${WORKDIR}"

src_unpack() {
	local tag ver tarball
	tag=$(curl -fsSL https://api.github.com/repos/DefGuard/client/releases/latest \
		| grep -m1 '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/') \
		|| die "could not query latest release tag"
	[[ -n ${tag} ]] || die "empty release tag (GitHub rate limit?)"
	ver=${tag#v}
	tarball="dg-linux-x86_64-v${ver}.tar.gz"

	einfo "Fetching Defguard CLI ${tag}"
	curl -fSL -o "${WORKDIR}/${tarball}" \
		"https://github.com/DefGuard/client/releases/download/${tag}/${tarball}" \
		|| die "download of ${tarball} failed"

	tar xzf "${WORKDIR}/${tarball}" -C "${WORKDIR}" || die "extract failed"
	# Tarball holds a single versioned binary; give it a stable name.
	mv "${WORKDIR}/dg-linux-x86_64-v${ver}" "${WORKDIR}/dg" || die
}

src_install() {
	dosbin dg
}

pkg_postinst() {
	elog "Get started:  dg enroll   (run as root; then 'dg' to connect)."
	elog "dg manages the WireGuard interface directly, so it needs root and"
	elog "kernel WireGuard support (CONFIG_WIREGUARD) or a userspace fallback."
	elog
	elog "Update to the newest upstream release later by re-emerging:"
	elog "  emerge -1 net-vpn/defguard-cli"
}
