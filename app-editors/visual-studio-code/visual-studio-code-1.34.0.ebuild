# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"

SRC_URI="
	x86? ( https://update.code.visualstudio.com/${PV}/linux-ia32/stable ->  ${P}-x86.tar.gz )
	amd64? ( https://update.code.visualstudio.com/${PV}/linux-x64/stable -> ${P}-amd64.tar.gz )
	"
RESTRICT="mirror strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="global-menu libsecret qt5"

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/cairo
	gnome-base/gconf
	x11-libs/libXtst
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	libsecret? ( app-crypt/libsecret[crypt] )
	global-menu? (
		dev-libs/libdbusmenu
		qt5? (
			dev-libs/libdbusmenu-qt
		)
	)
"

DOCS=( resources/app/LICENSE.rtf )

QA_PRESTRIPPED="opt/${PN}/code"
QA_PREBUILT="opt/${PN}/code"

pkg_setup(){
	use amd64 && S="${WORKDIR}/VSCode-linux-x64" || S="${WORKDIR}/VSCode-linux-ia32"
}

src_install(){
	pax-mark m code
	mkdir -p "${D}/opt/${PN}"
	cp -r . "${D}/opt/${PN}/"
	dosym "/opt/${PN}/bin/code" "/usr/bin/${PN}"
	make_desktop_entry "${PN}" "Visual Studio Code" "${PN}" "Development;IDE"
	newicon "resources/app/resources/linux/code.png" ${PN}.png
	einstalldocs
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
