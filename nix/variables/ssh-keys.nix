let
  keys = {
    "arne@arne-desktop" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJg+GUBJMuJiNJeEMiNdqNXyKHjf4IoBTv+oCJF8QJbL arne@arne-desktop";
    "arne@arne-ideapad" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsQKnt/wHeRjRSZOh1Y3r2Kif362My/xA+KHI5s9ShL arne@arne-ideapad";
    "root@darts-rpi" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5rgQZL51Y1sczqUWIx2Lh2JCr7PciFs586kXEXOoqr root@darts-rpi";
  };
in
  keys
  // {
    trusted-admins = [keys."arne@arne-desktop" keys."arne@arne-ideapad"];
  }
