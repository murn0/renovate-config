_: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    packages = {
      ghalint = pkgs.callPackage ./ghalint {};
    };
  };
}
