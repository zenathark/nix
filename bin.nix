{ stdenv, fetchurl, lib, pkgs, zlib }:

stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.6";
  revision = "0";
  plainName = "${pname}-${version}.${revision}";
  name = "${plainName}-bin";
  platform = "linux-x86_64";

  src = fetchurl {
    url = "https://julialang-s3.julialang.org/bin/linux/x64/${version}/${plainName}-${platform}.tar.gz";
    sha256 = "3a27ea78b06f46701dc4274820d9853789db205bce56afdc7147f7bd6fa83e41";
  };

  buildPhase = ''
    mkdir -pv $out/lib
    ln -s "${lib.getLib pkgs.zlib}/lib/libz.so.1" "$out/lib/libz.so.1"
    for i in bin/*; do
      patchelf \
	--interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
	--set-rpath ${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:$out/lib \
	$i
    done
  '';

  installPhase = ''
    mkdir -pv $out/bin
    mkdir -pv $out/include
    mkdir -pv $out/lib
    mkdir -pv $out/share
    cp -r bin/* $out/bin
    cp -r include/* $out/include
    cp -r lib/* $out/lib
    cp -r share/* $out/share
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
  };
}
