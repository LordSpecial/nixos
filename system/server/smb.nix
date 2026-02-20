{
  services.samba = {
    enable = true;
    openFirewall = false;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "specialserver";
        "netbios name" = "specialserver";
        "security" = "user";
        "map to guest" = "Bad User";
      };

      BackupDrive = {
        "path" = "/backup-tank";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "guest only" = "yes";
      };

      NewServer = {
        "path" = "/backup-tank";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "guest only" = "no";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = false;
  };
}
