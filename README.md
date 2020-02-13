# haskell-game

to run locally:

- install stack
- install nix-shell

```
$ nix-env -iA cachix -f https://cachix.org/api/v1/install
$ cachix use ghcide-nix
```

- open a nix shell (`nix-shell`)
- in the shell, run `stack build`
- in the shell, run `stack exec haskell-game-exe`
