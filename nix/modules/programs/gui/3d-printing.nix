{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    openscad      # 3D modeling
    prusa-slicer  # 3D slicing
  ];
}
