{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # 3D modeling
    openscad

    # 3D slicing
    unstable.bambu-studio
  ];
}
