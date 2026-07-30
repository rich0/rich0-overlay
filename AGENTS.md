# Agent notes for rich0-overlay

Personal Gentoo overlay. Prefer small, focused package bumps over broad refactors.

## Default delivery

When work is done, **open a pull request by default** (feature branch + `gh pr create`). Do not wait to be asked unless the user explicitly says not to open a PR.

## Dependency / distfile tarballs

Most packages only need upstream sources. Some (especially Go packages using `go-module.eclass` without a `vendor/` directory) need an extra dependency tarball hosted at `https://dist.rich0.org/distfiles/`.

When generating such a tarball:

1. Build it with the usual Gentoo recipe (for Go module deps: `GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw`, then `XZ_OPT='-T0 -9' tar -acf …-deps.tar.xz go-mod`).
2. Place the finished file under **`/utility/tmp/`** with the final distfile name (e.g. `flux2-2.9.3-deps.tar.xz`).
3. Tell the human it is ready; they will copy it onto `dist.rich0.org`.
4. Compute Manifest `DIST` hashes from that same local file (bytes must match what ends up on dist).

Do not attempt to upload to dist yourself from this environment.

## Package bumps

- Prefer a single current version ebuild when replacing a prior bump of the same package (drop the old ebuild + Manifest entries).
- Keep ebuild changes minimal: if `SRC_URI` is driven by `${PV}`, a rename is often enough.
- Update the package `Manifest` (`DIST` / `EBUILD` / `MISC` with BLAKE2B and SHA512). Portage may be unavailable; hashing with `b2sum`/`sha512sum` (or Python) is fine.
- Match existing style: copyright years, EAPI, eclasses already used in the package.
