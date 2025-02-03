{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system:
      {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {

          cfmesh-cfdof = pkgs.callPackage (import ./cfmesh-cfdof) { openfoam = openfoam.${system}; };
          cfmesh-cfdof-unstable = cfmesh-cfdof.override { version = "unstable"; };

          hisa = pkgs.callPackage (import ./hisa) { openfoam = openfoam.${system}; };
          hisa-unstable = hisa.override { version = "unstable"; };

          openfoam = pkgs.callPackage (import ./openfoam-com) { };
        };
      }
    )[ "x86_64-linux" "aarch64-linux" ]);
  };
}
