let
  pkgs = import <nixpkgs> { };

  ghcVersion = "ghc865";

  haskellPackages = pkgs.haskell.packages.${ghcVersion}.override { 
    overrides = self: super: {
      # If you need a particular version of a package instead
      # of the default that nixpkgs provides, specify it here.
    };
  };

  ghcide =
    let 
      url = "https://github.com/hercules-ci/ghcide-nix/tarball/master";
    in
      (import (builtins.fetchTarball url) {})."ghcide-${ghcVersion}";


  oldDerivation = (import ./release.nix).project.env;

in pkgs.stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    haskellPackages.ghcid
    ghcide
  ];
}
