{
  ...
}:
{
  age.secrets.workLaptopSshKey = {
    file = ../../secrets/work-laptop-ssh-key.age;
    path = "/home/simon/.ssh/work_laptop_id_ed25519";
    mode = "0600";
    owner = "simon";
  };

  system.activationScripts.workLaptopSshKeyPub = {
    text = ''
      install -d -m 0700 -o simon -g users /home/simon/.ssh
      if [ -f /home/simon/.ssh/work_laptop_id_ed25519 ] && [ ! -f /home/simon/.ssh/work_laptop_id_ed25519.pub ]; then
        ssh-keygen -y -f /home/simon/.ssh/work_laptop_id_ed25519 > /home/simon/.ssh/work_laptop_id_ed25519.pub
        chown simon:users /home/simon/.ssh/work_laptop_id_ed25519.pub
        chmod 0644 /home/simon/.ssh/work_laptop_id_ed25519.pub
      fi
    '';
  };
}
