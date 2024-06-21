{
  description = "My fork of suckless/dwm with patches and config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) fetchpatch;
      in
      {
        packages.default = pkgs.dwm.overrideAttrs {
          src = ./.;
          patches = [
            # official patches by other people
            (fetchpatch {
              name = "statusallmons";
              url = "https://dwm.suckless.org/patches/statusallmons/dwm-statusallmons-6.2.diff";
              hash = "sha256-AdngAZTKzICfwAx66sOdWD3IdsoJN8UW8eXa/o+X5/4=";
            })
            (fetchpatch {
              name = "noborder-floatingfix";
              url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
              hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";
            })
            ./patches/dwm-adjacenttag-6.2.diff
            ./patches/dwm-scratchpads-20200414-728d397b.diff
            # my official patches
            (fetchpatch {
              name = "activemonitor";
              url = "https://dwm.suckless.org/patches/activemonitor/dwm-activemonitor-20230825-e81f17d.diff";
              hash = "sha256-MEF/vSN3saZlvL4b26mp/7XyKG3Lp0FD0vTYPULuQXA=";
            })
            (fetchpatch {
              name = "resizehere";
              url = "https://dwm.suckless.org/patches/resizehere/dwm-resizehere-20230824-e81f17d.diff";
              hash = "sha256-4iy2FtOdFDJGFIZ9rpYHtcYjXBOwP5YaFz5f8l/DIN0=";
            })
            # my unofficial patches
            ./patches/dwm-rofi-6.4.diff
            ./patches/dwm-focuscursor-6.4.diff
            ./patches/dwm-changeborder-6.4.diff
          ];
        };
      }
    );
}
