{
  pkgs,
  lib,
  ...
}: {
  hm.programs.ranger = {
    enable = true;
  };

  hm.programs.fish = {
    functions.ranger-cd = ''
      set tempfile (mktemp -t ranger-cdXXXXXX)
      ${pkgs.ranger}/bin/ranger --choosedir=$tempfile $argv
      if test -f "$tempfile"
        set rangerdir (cat $tempfile)
        if test -n "$rangerdir" -a "$rangerdir" != (pwd)
          cd -- $rangerdir
        end
        rm -f -- $tempfile
      end
    '';
  };
}
