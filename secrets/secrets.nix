let
  # Single shared key for all trusted devices
  # Store this key securely in your password manager
  sharedKey = "age1tztwvdu3hq0h8mea5h4spyp0drwlmas3tja4x036sulvqr4zcyvqdwmcag";
in
{
  # Network connections
  "secrets/aquila-office.nmconnection.age".publicKeys = [ sharedKey ];
  "secrets/Potentially-Safe-Network.nmconnection.age".publicKeys = [ sharedKey ];

  # Git credentials - shared across devices
  "secrets/git-credentials-lordspecial.age".publicKeys = [ sharedKey ];
  "secrets/git-credentials-aquilaspace.age".publicKeys = [ sharedKey ];

  # SSH keys - per machine but all encrypted with shared key
  "secrets/work-laptop-ssh-key.age".publicKeys = [ sharedKey ];
  "secrets/personal-laptop-ssh-key.age".publicKeys = [ sharedKey ];
}
