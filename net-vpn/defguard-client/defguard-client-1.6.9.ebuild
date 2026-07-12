# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop systemd unpacker xdg

DESCRIPTION="Defguard desktop VPN client with true WireGuard MFA/2FA"
HOMEPAGE="https://defguard.net/ https://github.com/DefGuard/client"
SRC_URI="https://github.com/DefGuard/client/releases/download/v${PV}/defguard-client_${PV}_amd64.deb"

# AGPL-3 open core + proprietary enterprise components bundled in the prebuilt binary.
LICENSE="AGPL-3.0-or-later all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="bindist mirror strip test"
QA_PREBUILT="usr/bin/defguard-client usr/sbin/defguard-service"

RDEPEND="
	acct-group/defguard
	dev-util/desktop-file-utils
	dev-libs/libayatana-appindicator
	net-libs/webkit-gtk:4.1
	x11-libs/gtk+:3
"

S="${WORKDIR}"

src_install() {
	# GUI client (Exec=defguard-client in the .desktop)
	dobin usr/bin/defguard-client

	# Privileged interface daemon that actually manages WireGuard interfaces.
	dosbin usr/sbin/defguard-service

	# Tray icons the client loads at runtime, relative to /usr/lib/defguard-client.
	insinto /usr/lib/defguard-client
	doins -r usr/lib/defguard-client/resources

	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor

	domenu usr/share/applications/defguard-client.desktop

	# Upstream systemd unit (Group=defguard, ExecStart=/usr/sbin/defguard-service).
	systemd_dounit usr/lib/systemd/system/defguard-service.service

	# OpenRC equivalent.
	newinitd "${FILESDIR}"/defguard-service.initd defguard-service
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "The defguard-service daemon runs as root to manage WireGuard interfaces."
	elog "Enable it before using the client:"
	elog "  OpenRC:  rc-update add defguard-service default"
	elog "           rc-service defguard-service start"
	elog "  systemd: systemctl enable --now defguard-service"
	elog
	elog "Add your user to the 'defguard' group (then log out and back in):"
	elog "  usermod -aG defguard <user>"
	elog
	elog "Kernel WireGuard support (CONFIG_WIREGUARD) or a userspace implementation"
	elog "is required for tunnels to come up."
}
