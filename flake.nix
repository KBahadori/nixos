{
  description = "My system config flakes yolo";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # 1) Add NUR input
    nur = {
      url = "github:nix-community/NUR";
      # Tells NUR to use the same nixpkgs you labeled `nixpkgs`
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # 2) Expose it in outputs
  outputs = { nixpkgs, ghostty, nur, nixos-cosmic, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Your existing config file
        ./configuration.nix

        # Cosmic 
       {
       nix.settings = {
        substituters = [ "https://cosmic.cachix.org/" ];
        trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
         };
       }
       nixos-cosmic.nixosModules.default
      
        # An inline module that imports the NUR module
        # so that pkgs.nur.* is available
      ({ pkgs, ... }:{
          imports = [
            # This is the built-in NUR “module” that adds the overlay for you
            nur.modules.nixos.default
          ];

          environment.systemPackages = [
            ghostty.packages.x86_64-linux.default
            pkgs.nur.repos.shadowrz.klassy-qt6

            # or for the Qt6 variant
            # pkgs.nur.repos.shadowrz."klassy-qt6"
          ];
        })
      ];
    };
  };
}

