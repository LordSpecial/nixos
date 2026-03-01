{ pkgs, ... }:
{
  age.secrets.personalLaptopSshKey = {
    file = ../../secrets/personal-laptop-ssh-key.age;
    path = "/home/simon/.ssh/personal_laptop_id_rsa";
    mode = "0600";
    owner = "simon";
  };

  system.activationScripts.personalLaptopSshKeyPub = {
    text = ''
      install -d -m 0700 -o simon -g users /home/simon/.ssh
      if [ -f /home/simon/.ssh/personal_laptop_id_rsa ] && [ ! -f /home/simon/.ssh/personal_laptop_id_rsa.pub ]; then
        ${pkgs.openssh}/bin/ssh-keygen -y -f /home/simon/.ssh/personal_laptop_id_rsa > /home/simon/.ssh/personal_laptop_id_rsa.pub
        chown simon:users /home/simon/.ssh/personal_laptop_id_rsa.pub
        chmod 0644 /home/simon/.ssh/personal_laptop_id_rsa.pub
      fi
    '';
  };
}