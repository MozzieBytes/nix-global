{
  description = "Store of shared Global configuration values for Nix configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      importDir = import ./utils/importDir.nix inputs;
      mkDevEnv = import ./utils/mkDevEnv.nix inputs { };
    in
    {
      utils = importDir ./utils;
    }
    // (mkDevEnv (
      pkgs: corePackages: {
        devShells.default = pkgs.mkShell {
          buildInputs = corePackages;
        };
      }
    ));
}
