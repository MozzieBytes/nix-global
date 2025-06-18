(
  targetDir:
  let
    dirFiles = builtins.attrNames (builtins.readDir targetDir);
    nixFiles = builtins.filter (name: builtins.match ".*\\.nix$" name != null) dirFiles;
  in
  builtins.listToAttrs (
    map (name: {
      inherit name;
      value = import (targetDir + "/${name}");
    }) nixFiles
  )
)
