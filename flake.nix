{
  description = "NixOS configuration with Noctalia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Warning: Noctalia v5 moved to github:noctalia-dev/noctalia and uses a
    # different native TOML configuration model. This setup intentionally stays
    # on the last v4 release because the v5 visual result is not yet a suitable
    # replacement for the existing v4 shell configuration.
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/v4.7.7";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";

    agenix.url = "github:ryantm/agenix";

    codex.url = "github:openai/codex";
    codex.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = inputs@{ self, nixpkgs, nix-flatpak, agenix, ... }: 
  let
    lib = nixpkgs.lib;

    configDir = ./modules;
    generatedModules = lib.map (file: configDir + "/${file}") 
      (lib.filter (file: lib.hasSuffix ".nix" file) 
        (lib.attrNames (builtins.readDir configDir)));

    # devShell 统一用的 pkgs
    mkPkgs = system: import nixpkgs { inherit system; };
    system = "x86_64-linux";
    pkgs = mkPkgs system;
    devShellDir = ./devshells;
  in
  {
    # 手动打包内容
    # ...

    # 系统配置
    nixosConfigurations.forge = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self; };
      
      modules = [
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak

        agenix.nixosModules.default
        ({ pkgs, ... }: {
          environment.systemPackages = [
            agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.users.zikun = { ... }: {
            imports = [
              agenix.homeManagerModules.default
              ./home/home.nix
            ];
          };
        }
      ] ++ generatedModules; 
    };

    devShells.${system} = {
      default = import (devShellDir + "/python.nix") { inherit pkgs; };
    };
  };
}
