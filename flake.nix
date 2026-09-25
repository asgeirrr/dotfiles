{
  description = "Oskar's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHome =
        username: homeDirectory:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit homeDirectory username; };
          modules = [ ./home.nix ];
        };
    in
    {
      homeConfigurations = {
        oskar = mkHome "oskar" "/home/oskar";
        "oskar.hollmann" = mkHome "oskar.hollmann" "/home/oskar.hollmann";
      };

      packages.${system}.home-manager = home-manager.packages.${system}.home-manager;
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
