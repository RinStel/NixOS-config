{
  description = "NixOS configuration with Noctalia";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
     # inputs.quickshell.follows = "quickshell";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: 
  let
    lib = nixpkgs.lib;
    configDir = ./modules;
    generatedModules = lib.map (file: "${configDir}/${file}") 
      (lib.filter (file: lib.hasSuffix ".nix" file) 
        (lib.attrNames (builtins.readDir configDir)));
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      
      modules = [
        ./configuration.nix
      ] ++ generatedModules; 
    };
  };
}
