{
  config,
  pkgs,
  lib,
  ...
}:
let
  devDir = "${config.home.homeDirectory}/dev";
  repos = [
    {
      name = "aq-system-orchestration-module";
      url = "https://github.com/AquilaSpace/aq-system-orchestration-module";
    }
    {
      name = "aq-gas";
      url = "https://github.com/AquilaSpace/aq-gas";
    }
    {
      name = "amr";
      url = "https://github.com/AquilaSpace/amr";
    }
    {
      name = "aq-raspi-setup";
      url = "https://github.com/AquilaSpace/aq-raspi-setup";
    }
    {
      name = "aq-csc-module";
      url = "https://github.com/AquilaSpace/aq-csc-module";
    }
    {
      name = "aq-smiladon-interface";
      url = "https://github.com/AquilaSpace/aq-smiladon-interface";
    }
    {
      name = "aq-standard-definitions";
      url = "https://github.com/AquilaSpace/aq-standard-definitions";
    }
    {
      name = "aq-mppt";
      url = "https://github.com/AquilaSpace/aq-mppt";
    }
    {
      name = "aq-thermal-hub";
      url = "https://github.com/AquilaSpace/aq-thermal-hub";
    }
    {
      name = "aq-fsc-module";
      url = "https://github.com/AquilaSpace/aq-fsc-module";
    }
  ];
in
{
  home.activation.cloneAquilaRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -eu
    DEV_DIR="${devDir}"
    $DRY_RUN_CMD mkdir -p "$DEV_DIR"

    clone_repo() {
      local name="$1"
      local url="$2"
      local dest="$DEV_DIR/$name"

      if [ -d "$dest/.git" ]; then
        return 0
      fi

      if [ -e "$dest" ]; then
        echo "Skipping $name: $dest exists but is not a git repo" >&2
        return 0
      fi

      if ! $DRY_RUN_CMD ${pkgs.git}/bin/git clone "$url" "$dest"; then
        echo "Warning: failed to clone $url" >&2
      fi
    }

    ${lib.concatStringsSep "\n" (map (repo: "clone_repo \"${repo.name}\" \"${repo.url}\"") repos)}
  '';
}
