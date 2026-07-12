# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Defguard desktop VPN client with true WireGuard MFA/2FA (latest binary)"
HOMEPAGE="https://defguard.net/ https://github.com/DefGuard/client"

# Live: the newest release .deb is fetched at build time (see src_unpack), so a
# re-emerge always pulls current. No SRC_URI/Manifest; not reproducible.
PROPERTIES="live"

# AGPL-3 open core + proprietary enterprise components bundled in the binary.
LICENSE="AGPL-3.0-or-later all-rights-reserved"
SLOT="0"
KEYWORDS=""

# network-sandbox off so curl can reach GitHub during src_unpack.
RESTRICT="network-sandbox mirror bindist strip test"
QA_PREBUILT="usr/bin/defguard-client usr/sbin/defguard-service"

RDEPEND="
	dev-util/desktop-file-utils
	dev-libs/libayatana-appindicator
	net-libs/webkit-gtk:4.1
	x11-libs/gtk+:3
"
BDEPEND="net-misc/curl"

S="${WORKDIR}"

src_unpack() {
	local tag ver deb
	tag=$(curl -fsSL https://api.github.com/repos/DefGuard/client/releases/latest \
		| grep -m1 '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/') \
		|| die "could not query latest release tag"
	[[ -n ${tag} ]] || die "empty release tag (GitHub rate limit?)"
	ver=${tag#v}
	deb="defguard-client_${ver}_amd64.deb"

	einfo "Fetching Defguard client ${tag}"
	curl -fSL -o "${WORKDIR}/${deb}" \
		"https://github.com/DefGuard/client/releases/download/${tag}/${deb}" \
		|| die "download of ${deb} failed"

	cd "${WORKDIR}" || die
	unpacker "${WORKDIR}/${deb}"
}

src_install() {
	# GUI client (Exec=defguard-client in the .desktop).
	dobin usr/bin/defguard-client

	# Privileged daemon that manages WireGuard interfaces (needs root).
	dosbin usr/sbin/defguard-service

	# Tray icons the client loads at runtime, relative to /usr/lib/defguard-client.
	insinto /usr/lib/defguard-client
	doins -r usr/lib/defguard-client/resources

	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor

	domenu usr/share/applications/defguard-client.desktop
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! getent group defguard >/dev/null 2>&1; then
		groupadd --system defguard \
			|| ewarn "Could not create 'defguard' group; create it manually."
	fi

	elog "Add your user to the 'defguard' group (then log out and back in):"
	elog "  usermod -aG defguard <user>"
	elog
	elog "The defguard-service daemon must run as root to manage WireGuard"
	elog "interfaces; set up your own service to run /usr/sbin/defguard-service."
	elog
	elog "Kernel WireGuard support (CONFIG_WIREGUARD) or a userspace implementation"
	elog "is required for tunnels to come up."
	elog
	elog "To update to the newest upstream release later: re-emerge this package"
	elog "  emerge -1 net-vpn/defguard-client"
}
