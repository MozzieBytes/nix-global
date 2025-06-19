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
    in
    {
      nixosModules = {
        modules = importDir ./modules;
        apps = importDir ./apps;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        devConf = import ./modules/devConf.nix inputs pkgs { };
      in
      {
        formatter = devConf.formatter;
        checks.formatting = devConf.fmtChecks;
        devShells.default = pkgs.mkShell {
          buildInputs = devConf.corePackages;
        };
      }
    );
}
