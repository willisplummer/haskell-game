let
  pkgs = import <nixpkgs> {};

  ghcVersion = "ghc863";

  haskellPackages = pkgs.haskell.packages.${ghcVersion}.override { 
    overrides = self: super: {
      # If you need a particular version of a package instead
      # of the default that nixpkgs provides, specify it here.
    };
  };

  ghcide =
    let 
      url = "https://github.com/cachix/ghcide-nix/tarball/master";
    in
      (import (builtins.fetchTarball url) {})."ghcide-${ghcVersion}";

in pkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = [
        pkgs.glfw3
        pkgs.ftgl
        pkgs.freealut
        haskellPackages.ghcid
        ghcide
    ];
    shellHook = ''
      expression=$(grep "export" < nixGL/result/bin/nixGL*)
      if [ -n "$expression" ]; then
        eval "$expression"
      fi
    '';
}
