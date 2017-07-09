{stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "mfizz-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/fizzed/font-mfizz/releases/download/v${version}/font-mfizz-${version}.zip";
    sha256 = "c447c9d00a7a37b78af4e86ff8f787473fd6e9812b6b5033eb23dc62ffc5e044";
  };

  buildInputs = [unzip];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = "font-mfizz-2.4.1";

  installPhase = let
    fonts_dir = "$out/share/fonts/truetype";
  in ''
    mkdir -pv ${fonts_dir}
    cp *.ttf  ${fonts_dir}
  '';

  meta = with stdenv.lib; {
    homepage = http://fizzed.com/oss/font-mfizz/;
    description = "Font Mfizz - Vector Icons for Technology and Software Geeks";
    longDescription = ''
      Font Mfizz provides scalable vector icons representing programming
      languages, operating systems, software engineering, and technology. It was
      designed as an extension to Font Awesome, it is an iconic font designed
      for technology and software geeks. It can instantly be customized — size,
      color, drop shadow, and anything that can be done with the power of
      CSS. Font Mfizz is used extensively on this site for our blog, project
      info, etc.
    '';
    license = licenses.mit;
    platforms = platforms.all;
  };
}
