# Slab Case

[![Nix Flake](https://img.shields.io/badge/NIX%20FLAKE-5277C3.svg?logo=NixOS&logoColor=white)](https://nixos.org) [![xc compatible](https://xcfile.dev/badge.svg)](https://xcfile.dev) [![OpenSCAD](https://img.shields.io/badge/OPENSCAD-8d8d8d.svg?logo=openscad&logoColor=#FFF662)](https://openscad.org)

The 3D-models and downloads for the [Slab keyboard project](https://github.com/headblockhead/slab).

STL downloads are in the releases section.

## Building the STLs

This project uses [OpenSCAD](https://openscad.org) and [Nix](https://nixos.org), run `nix develop` for a development environment, and `nix build` to build the STLs.

## Tasks

> [!IMPORTANT]
> You must be in the `nix develop` shell for these tasks to work!

### Build models

Uses openscad to create STL files from the scad files.

```bash
openscad -D render_case=true -o left_case.stl left.scad
openscad -D render_plate=true -o left_plate.stl left.scad
openscad -D render_case=true -o right_case.stl right.scad
openscad -D render_plate=true -o right_plate.stl right.scad
openscad -D render_case=true -o hackpad_case.stl hackpad.scad
openscad -D render_plate=true -o hackpad_plate.stl hackpad.scad
```

## Supplies
- 3D printer (or a 3D printing service)
- Keyswitches - Cherry MX compatible or Kailh Choc compatible
- Keycaps - Cherry MX compatible or Kailh Choc compatible
- M3 screws countersunk machine screws - 12mm depth.
- M3 knurled brass inserts - 5.7mm depth.
- Soldering iron - for installing inserts.
