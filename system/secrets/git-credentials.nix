{
  ...
}:
{
  age.secrets.git-credentials-lordspecial = {
    file = ../../secrets/git-credentials-lordspecial.age;
    owner = "simon";
    group = "users";
    mode = "0400";
  };

  age.secrets.git-credentials-aquilaspace = {
    file = ../../secrets/git-credentials-aquilaspace.age;
    owner = "simon";
    group = "users";
    mode = "0400";
  };

  system.activationScripts.gitCredentials = {
    text = ''
      install -d -m 0700 -o simon -g users /home/simon/.config/git
      install -m 0600 -o simon -g users /run/agenix/git-credentials-lordspecial /home/simon/.config/git/credentials-lordspecial
      install -m 0600 -o simon -g users /run/agenix/git-credentials-aquilaspace /home/simon/.config/git/credentials-aquilaspace
    '';
  };
}
