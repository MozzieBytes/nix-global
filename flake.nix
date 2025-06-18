{
  description = "Store of shared Global configuration values for Nix configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs@{
    self,
    nixpkgs,
    flake-utils,
    treefmt-nix,
    }:
    let
      importDir = import ./utils/importDir.nix;
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
        devConf = import ./modules/devConf.nix (inputs // { inherit pkgs; }) { };
      in
        {
        formatter = devConf.fmt.formatter;
        checks.formatting = devConf.fmt.checks.formatting;
        devShells.default = pkgs.mkShell {
          buildInputs = devConf.corePackages;
        };
      }
    );
}
