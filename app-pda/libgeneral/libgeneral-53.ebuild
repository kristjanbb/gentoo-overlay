# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Some silly library used by usbmux2"
HOMEPAGE="https://github.com/tihmstar/libgeneral/"
SRC_URI="https://github.com/tihmstar/libgeneral/archive/${PV}.tar.gz -> ${P}.tar.gz"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	# remove silly git sha get that only works on tihmstar computer
	sed -i "s/m4_esyscmd(\[git rev-list[^)]*)/${PV}/" configure.ac

	default
	eautoreconf
}

src_configure() {
	econf
}
