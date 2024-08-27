{
  stdenv,
  fetchurl,
  system,
  ...
}: let
  version = "0.2.12";
  url-base = "https://github.com/suzuki-shunsuke/ghalint/releases/download";
  list = {
    x86_64-darwin = {
      url = "${url-base}/v${version}/ghalint_${version}_darwin_amd64.tar.gz";
      sha256 = "sha256-iCJhLX18W58Bx61SjntxP3Jb76nGMoFdEwPOkPAb1Oc=";
    };
    aarch64-darwin = {
      url = "${url-base}/v${version}/ghalint_${version}_darwin_arm64.tar.gz";
      sha256 = "sha256-S5+C1z2lmxgaVaGqL9tPESi2/09ORlNAelqslRz4zyo=";
    };
    x86_64-linux = {
      url = "${url-base}/v${version}/ghalint_${version}_linux_amd64.tar.gz";
      sha256 = "sha256-ci00IP/0+aDXs4s2VN/N208fbirbs7ugE/LZ7tQG2dU=";
    };
    aarch64-linux = {
      url = "${url-base}/v${version}/ghalint_${version}_linux_arm64.tar.gz";
      sha256 = "sha256-ecAF/I/M0iDO9dp2oMgaJ0q981ptsZ6T7nMaQwILkK0=";
    };
  };
in
  stdenv.mkDerivation rec {
    inherit system version;

    pname = "ghalint";

    src = fetchurl {
      inherit (list.${system}) url sha256;
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      cp -vr ./ghalint $out/bin/ghalint
    '';
  }
