{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    openfoam-v2406-repo = {
      type = "git";
      url = "https://develop.openfoam.com/Development/openfoam";
      ref = "OpenFOAM-v2406";
      submodules = true;
      flake = false;
    };
    openfoam-v2312-repo = {
      type = "git";
      url = "https://develop.openfoam.com/Development/openfoam";
      ref = "OpenFOAM-v2312";
      submodules = true;
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {

#        cfmesh-cfdof = pkgs.callPackage (import ./cfmesh-cfdof) { openfoam = openfoam.${system}; };
#        cfmesh-cfdof-unstable = cfmesh-cfdof.override { version = "unstable"; };

#        hisa = pkgs.callPackage (import ./hisa) { openfoam = openfoam.${system}; };
#        hisa-unstable = hisa.override { version = "unstable"; };

        openfoam-v2406 = pkgs.callPackage (import ./openfoam-com) { src-flake = inputs.openfoam-v2406-repo; version = "2406"; };

        openfoam-v2312 = pkgs.callPackage (import ./openfoam-com) { src-flake = inputs.openfoam-v2312-repo; version = "2312"; };


        default = openfoam-v2406;
      };
    })[ "x86_64-linux" "aarch64-linux" ]);
  };
}
