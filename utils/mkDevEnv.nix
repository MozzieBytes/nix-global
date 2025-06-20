{
  self,
  nixpkgs,
  flake-utils,
  treefmt-nix,
  ...
}:
fmtConf: mkEnv:
flake-utils.lib.eachDefaultSystem (
  system:
  let
    fmtDefaults = {
      projectRootFile = "flake.nix";

      programs.nixfmt.enable = true;
      programs.mdformat.enable = true;
      settings.global.excludes = [
        ".envrc"
        "hardware-configuration.nix"
      ];
    };
    pkgs = import nixpkgs { inherit system; };
    treefmtEval = treefmt-nix.lib.evalModule pkgs (fmtConf // fmtDefaults);
    treefmtPrograms = builtins.attrValues treefmtEval.config.build.programs;
    corePackages =
      with pkgs;
      [
        git
        nil
      ]
      ++ treefmtPrograms;
  in
  {
    formatter = treefmtEval.config.build.wrapper;
    checks.formatting = treefmtEval.config.build.check self;
  }
  // (mkEnv pkgs corePackages)
)
