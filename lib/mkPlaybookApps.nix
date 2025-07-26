# Create nix run profiles for a collection of Ansible Playbooks
{ ... }:
pkgs: runtimeInputs: playbookDir:
let
  dirFiles = builtins.attrNames (builtins.readDir playbookDir);
  playbooks = builtins.filter (name: builtins.match ".*\\.(yaml|yml)$" name != null) dirFiles;
  runPlay = (
    play: playbook: {
      type = "app";
      program = toString (
        pkgs.writers.writeBash "ansible-${play}" ''
          ${pkgs.ansible}/bin/ansible-playbook ${playbook}
        ''
      );
    }
  );
in
builtins.listToAttrs (
  map (
    file:
    let
      play = builtins.replaceStrings [ ".yaml" ".yml" ] [ "" "" ] file;
      playbook = playbookDir + "/${file}";
    in
    {
      name = play;
      value = runPlay play playbook;
    }
  ) playbooks
)

