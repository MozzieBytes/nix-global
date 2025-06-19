(
  targetDir:
  let
    dirFiles = builtins.attrNames (builtins.readDir targetDir);
    nixFiles = builtins.filter (name: builtins.match ".*\\.nix$" name != null) dirFiles;
  in
    builtins.listToAttrs (
      map (file: 
        let
          name = builtins.replaceStrings [".nix"] [""] file;
        in {
          inherit name;
          value = import (targetDir + "/${file}");
        }) nixFiles
    )
)
