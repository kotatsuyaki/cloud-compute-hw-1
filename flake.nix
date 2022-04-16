{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
    utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, utils, ... } @ inputs:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        deps = with pkgs; [
          texlive.combined.scheme-full
          pandoc
          librsvg
        ];
        dev-deps = with pkgs; [
          rnix-lsp
        ];
        fonts-conf = pkgs.makeFontsConf {
          fontDirectories = [ pkgs.source-han-serif ];
        };
      in
      {
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "main.pdf";
          src = ./.;
          buildInputs = deps;
          buildPhase = "make";
          installPhase = ''
            mkdir -p $out
            cp main.pdf $out
          '';
          FONTCONFIG_FILE = fonts-conf;
        };
        devShell = pkgs.mkShell {
          buildInputs = deps ++ dev-deps;
        };
      });
}
