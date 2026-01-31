let
  workLaptop = "age1tztwvdu3hq0h8mea5h4spyp0drwlmas3tja4x036sulvqr4zcyvqdwmcag";
in
{
  "secrets/aquila-office.nmconnection.age".publicKeys = [ workLaptop ];
  "secrets/Potentially-Safe-Network.nmconnection.age".publicKeys = [ workLaptop ];
  "secrets/git-credentials-lordspecial.age".publicKeys = [ workLaptop ];
  "secrets/git-credentials-aquilaspace.age".publicKeys = [ workLaptop ];
  "secrets/work-laptop-ssh-key.age".publicKeys = [ workLaptop ];
}
