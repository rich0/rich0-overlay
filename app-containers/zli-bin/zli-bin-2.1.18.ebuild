# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion toolchain-funcs

DESCRIPTION="Command-line interface for the zot OCI container registry"
HOMEPAGE="https://zotregistry.dev/ https://github.com/project-zot/zot"

SRC_URI="
	amd64? ( https://github.com/project-zot/zot/releases/download/v${PV}/zli-linux-amd64 -> ${P}-linux-amd64 )
	arm64? ( https://github.com/project-zot/zot/releases/download/v${PV}/zli-linux-arm64 -> ${P}-linux-arm64 )
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="strip"

QA_PREBUILT="usr/bin/zli"

src_unpack() {
	# Upstream ships a raw ELF binary, not an archive.
	local my_bin
	case ${ARCH} in
		amd64) my_bin="${P}-linux-amd64" ;;
		arm64) my_bin="${P}-linux-arm64" ;;
		*) die "Unsupported ARCH=${ARCH}" ;;
	esac
	cp "${DISTDIR}/${my_bin}" "${S}/zli" || die
	chmod +x "${S}/zli" || die
}

src_compile() {
	# Generate completions from the host-runnable binary.
	if ! tc-is-cross-compiler; then
		./zli completion bash > zli.bash || die
		./zli completion zsh  > zli.zsh  || die
		./zli completion fish > zli.fish || die
	fi
}

src_install() {
	dobin zli

	if ! tc-is-cross-compiler; then
		newbashcomp zli.bash zli
		newzshcomp zli.zsh _zli
		dofishcomp zli.fish
	fi
}
