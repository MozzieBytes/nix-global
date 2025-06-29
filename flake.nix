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
      ...
    }:
    let
      importDir = import ./lib/importDir.nix inputs;
      mkDevEnv = import ./lib/mkDevEnv.nix inputs { };
    in
    {
      lib = importDir ./lib;
    }
    // (mkDevEnv (
      pkgs: corePackages: {
        devShells.default = pkgs.mkShell {
          buildInputs = corePackages;
        };
      }
    ));
}
