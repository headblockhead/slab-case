{
  description = "Tools for developing and building slab-case";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        rec {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              xc
              openscad-unstable
            ];
          };
          packages.slab-case = pkgs.stdenv.mkDerivation {
            name = "slab-case";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              openscad-unstable
            ];
            buildPhase = ''
              runHook preBuild
              openscad -D render_case=true -o left_case.stl left.scad
              openscad -D render_plate=true -o left_plate.stl left.scad
              openscad -D letter='"L"' -o left_letterplate.stl letterplate.scad
              openscad -D render_case=true -o right_case.stl right.scad
              openscad -D render_plate=true -o right_plate.stl right.scad
              openscad -D letter='"R"' -o right_letterplate.stl letterplate.scad
              openscad -D render_case=true -o hackpad_case.stl hackpad.scad
              openscad -D render_plate=true -o hackpad_plate.stl hackpad.scad
              openscad -D letter='"H"' -o hackpad_letterplate.stl letterplate.scad
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp {left,right,hackpad}_{case,plate,letterplate}.stl $out
              runHook postInstall
            '';
          };
          packages.default = packages.slab-case;
        }
      );
}
