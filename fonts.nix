{ pkgs, ... }:

{

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      emacs-all-the-icons-fonts
      fira
      fira-code
      fira-code-symbols
      fira-mono
      inconsolata
      libertine
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      nerdfonts
      symbola
      unifont
    ];
  };
}
