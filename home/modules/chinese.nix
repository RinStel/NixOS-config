{ pkgs, ...}:

{
  home.file.".local/share/fonts/noto-cjk-sans".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts";
  home.file.".local/share/fonts/noto-cjk-serif".source = "${pkgs.noto-fonts-cjk-serif}/share/fonts";
}
