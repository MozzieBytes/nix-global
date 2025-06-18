{
  self,
  pkgs,
  treefmt-nix,
  ...
}:
(
  fmtConf:
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
    fmt = {
      formatter = treefmtEval.config.build.wrapper;
      checks.formatting = treefmtEval.config.build.check self;
    };
    inherit corePackages;
  }
)
