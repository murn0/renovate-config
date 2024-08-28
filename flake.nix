{
  description = "renovateの共有設定";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.url = "github:cachix/git-hooks.nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
        ./packages
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        lib,
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            config.packages.ghalint
            just
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        pre-commit = {
          check.enable = true;
          settings = {
            hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              ghalint = {
                enable = true;
                files = "^.github/workflows/";
                types = ["yaml"];
                entry = "${config.packages.ghalint}/bin/ghalint run";
              };
              renovate-config-validator = {
                enable = true;
                files = "(^|/).?(renovate|default)(?:rc)?(?:\.json5?)?$";
                entry = "${pkgs.renovate}/bin/renovate-config-validator --strict";
              };
            };
          };
        };
      };
    };
}
