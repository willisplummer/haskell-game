with import <nixpkgs> {};
mkShell {
    buildInputs = [
        glfw3
        ftgl
        freealut
        (haskell.packages.ghc865.ghcWithPackages (pkgs: [
            pkgs.gloss
            pkgs.GLFW-b
        ]))
    ];
    shellHook = ''
      expression=$(grep "export" < nixGL/result/bin/nixGL*)
      if [ -n "$expression" ]; then
        eval "$expression"
      fi
    '';
}
