# let
#   pkgs = import <nixpkgs> {};

#   ghcVersion = "ghc865";

#   haskellPackages = pkgs.haskell.packages.${ghcVersion}.override { 
#     overrides = self: super: {
#       # If you need a particular version of a package instead
#       # of the default that nixpkgs provides, specify it here.
#     };
#   };

#   ghcide =
#     let 
#       url = "https://github.com/cachix/ghcide-nix/tarball/master";
#     in
#       (import (builtins.fetchTarball url) {})."ghcide-${ghcVersion}";

# in pkgs.stdenv.mkDerivation {
#     name = "env";
#     buildInputs = [
#         pkgs.ghc
#         pkgs.glfw3
#         pkgs.ftgl
#         pkgs.freealut
#         haskellPackages.ghcid
#         # ghcide
#     ];
#     shellHook = ''
#       expression=$(grep "export" < nixGL/result/bin/nixGL*)
#       if [ -n "$expression" ]; then
#         eval "$expression"
#       fi
#     '';
# }

with import <nixpkgs> {};
let
  stack-1_9_3 =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/bc94dcf500286495e3c478a9f9322debc94c4304.tar.gz";
      sha256 = "1siqklf863181fqk19d0x5cd0xzxf1w0zh08lv0l0dmjc8xic64a";
    }) { }).stack;

in
  mkShell {
      buildInputs = [
          clang
          glfw
          ftgl
          freealut
          gcc
          stack-1_9_3
          (haskell.packages.ghc865.ghcWithPackages (pkgs: [
              pkgs.gloss
              pkgs.GLFW-b
              pkgs.gloss-rendering
              pkgs.mtl
          ]))
      ];
  }

