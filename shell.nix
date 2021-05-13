{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  elixirDrv = elixir.override {
    version = "1.11.4";
    rev = "308255bda81e7f76f9bec838cef033e8e869981b";
    sha256 = "1y8fbhli29agf84ja0fwz6gf22a46738b50nwy26yvcl2n2zl9d8";
  };
in mkShell {
  name = "conts_dev";
 
  # define packages to install with special handling for OSX
  buildInputs = [
    readline
    curl
    # my elixir derivation
    elixirDrv
  ] ++ lib.optional stdenv.isLinux [ 
        inotify-tools 
        # observer gtk engine
        gtk-engine-murrine 
      ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]);


  # define shell startup command
  shellHook = ''
    # create local tmp folders
    mkdir -p .nix-mix
    mkdir -p .nix-hex

    # elixir local PATH
    # this allows mix to work on the local directory
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
    # to not conflict with your host elixir
    # version and supress warnings about standard
    # libraries
    export ERL_LIBS=$HEX_HOME/lib/erlang/lib
  '';
}
