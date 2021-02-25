# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd udev git-r3

DESCRIPTION="USB+WiFi multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
#SRC_URI="https://github.com/libimobiledevice/usbmuxd/releases/download/${PV}/${P}.tar.bz2"
EGIT_REPO_URI="https://github.com/tihmstar/usbmuxd2"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="systemd"

DEPEND="
	acct-user/usbmux
	>=app-pda/libimobiledevice-1.0:=
	>=app-pda/libplist-2.0:=
	>=app-pda/libgeneral-33
	!app-pda/usbmuxd
	virtual/libusb:1
"
RDEPEND="
	${DEPEND}
	virtual/udev
"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	# some pointless code that crashes, the whole config system probably should be ripped out..
	"${FILESDIR}/50-short-braindead-doublefree-function.patch"
)

pkg_setup() {
	# poor and dirty workaround for configuration not requiring pthread as it should..
	LDFLAGS="${LDFLAGS} -lpthread"
}

src_prepare() {
	# undo some bleeding edge fetish, libplist isn't magically going to become some less of a turd
	sed -i 's/libplist-2.0 >= 2.2.1/libplist-2.0 >= 2.2.0/' configure.ac

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with systemd) \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		--with-udevrulesdir="$(get_udevdir)"/rules.d
}

src_install() {
	default

	keepdir /var/db/lockdown
	fowners usbmux:root /var/db/lockdown
}
