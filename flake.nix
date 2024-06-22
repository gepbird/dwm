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
        packages.default = pkgs.dwm.overrideAttrs (o: {
          src = ./.;
          conf = ./config.h;
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
            ./patches/dwm-rofi-6.5.diff
            ./patches/dwm-focuscursor-6.4.diff
            ./patches/dwm-changeborder-6.4.diff
          ];
          postPatch = o.postPatch + (with pkgs; with lib; ''
            substituteInPlace chbright.sh \
              --replace-fail '@hck@' '${getExe hck}' \
              --replace-fail '@dunstify@' '${getExe' dunst "dunstify"}' \
              --replace-fail '@light@' '${getExe light}'
            substituteInPlace chvol.sh \
              --replace-fail '@sed@' '${getExe gnused}' \
              --replace-fail '@rg@' '${getExe ripgrep}' \
              --replace-fail '@dunstify@' '${getExe' dunst "dunstify"}' \
              --replace-fail '@pactl@' '${getExe' pulseaudio "pactl"}'
            substituteInPlace config.h \
              --replace-fail '@zsh@' '${getExe zsh}' \
              --replace-fail '@clac@' '${getExe clac}' \
              --replace-fail '@lf@' '${getExe lf}' \
              --replace-fail '@chatgpt@' '${getExe chatgpt-cli}' \
              --replace-fail '@btm@' '${getExe bottom}' \
              --replace-fail '@xkill@' '${getExe xorg.xkill}' \
              --replace-fail '@rofi@' '${getExe rofi}' \
              --replace-fail '@flameshot@' '${getExe flameshot}' \
              --replace-fail '@gromit-mpx@' '${getExe gromit-mpx}' \
              --replace-fail '@xfce4-terminal@' '${getExe xfce.xfce4-terminal}'
          '');
          buildInputs = o.buildInputs ++ (with pkgs; [
            wrapGAppsHook
          ]);
          postInstall = ''
            cp *.sh $out/bin
          '';
        });
      }
    );
}
