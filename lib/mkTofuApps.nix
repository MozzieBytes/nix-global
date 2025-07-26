# Create nix run profiles for opentofu commands against a target project
{ ... }:
pkgs: src:
let
  tfCommands = [
    "init"
    "plan"
    "validate"
    "apply"
    "destroy"
  ];
  runTfCommand = (
    command: {
      type = "app";
      program = toString (
        pkgs.writers.writeBash "${command}" ''
              set -e
              projectDir="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
          ${pkgs.opentofu}/bin/tofu -chdir="$projectDir/${src}" ${command}
        ''
      );
    }
  );
in
builtins.listToAttrs (
  map (cmd: {
    name = cmd;
    value = runTfCommand cmd;
  }) tfCommands
)
