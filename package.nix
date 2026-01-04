{
  bottom,
  clac,
  dunst,
  dwm,
  ente-auth,
  fetchpatch2,
  flameshot,
  gnused,
  gromit-mpx,
  hck,
  lf,
  lib,
  light,
  pulseaudio,
  ripgrep,
  rofi,
  wrapGAppsHook3,
  xfce4-terminal,
  xorg,
  zsh,
}:

dwm.overrideAttrs (o: {
  src = ./.;
  conf = ./config.h;
  patches = [
    # official patches by other people
    (fetchpatch2 {
      name = "statusallmons";
      url = "https://dwm.suckless.org/patches/statusallmons/dwm-statusallmons-6.2.diff";
      hash = "sha256-rYuRi65ZzhuxLAPvIuxxB2KZmkl9Fyav+fwbclB89kQ=";
    })
    (fetchpatch2 {
      name = "noborder-floatingfix";
      url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
      hash = "sha256-AjKKP3DJ4AFwcqwaRqzryxkVZymrW/AtUK51ELhzbQ8=";
    })
    ./patches/dwm-adjacenttag-6.2.diff
    ./patches/dwm-scratchpads-20200414-728d397b.diff
    ./patches/dwm-attachbelow-6.2.diff
    # my official patches
    (fetchpatch2 {
      name = "activemonitor";
      url = "https://dwm.suckless.org/patches/activemonitor/dwm-activemonitor-20230825-e81f17d.diff";
      hash = "sha256-j/s3tbDZe613Fprxprti+Q/Ym4g3ddoYhOFdHX+qH7o=";
    })
    (fetchpatch2 {
      name = "resizehere";
      url = "https://dwm.suckless.org/patches/resizehere/dwm-resizehere-20230824-e81f17d.diff";
      hash = "sha256-A+kMobZ4jD3xnEQgdeQ40SuWeimbDdNHpzLxQ/5+HAc=";
    })
    # my unofficial patches
    ./patches/dwm-rofi-6.5.diff
    ./patches/dwm-focuscursor-6.4.diff
    ./patches/dwm-changeborder-6.4.diff
    ./patches/dwm-noquittestmode-6.5.diff
  ];
  buildInputs = o.buildInputs ++ [
    bottom
    clac
    ente-auth
    flameshot
    gnused
    gromit-mpx
    lf
    rofi
    wrapGAppsHook3
    xfce4-terminal
    xorg.xkill
    zsh
  ];
  postInstall = ''
    cp chbright.sh $out/bin/chbright.sh
    wrapProgram $out/bin/chbright.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          light
          dunst
          hck
        ]
      }
    cp chvol.sh $out/bin/chvol.sh 
    wrapProgram $out/bin/chvol.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          pulseaudio
          dunst
          ripgrep
        ]
      }
  '';
})
