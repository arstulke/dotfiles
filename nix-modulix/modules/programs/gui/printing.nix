{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.cups-pdf.enable = true;
}
