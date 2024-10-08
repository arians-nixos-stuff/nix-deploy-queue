{
  description = "A nix based deploy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAll = f: lib.genAttrs lib.systems.flakeExposed (system: f self.packages.${system} nixpkgs.legacyPackages.${system});
    in
    {
      checks = forAll (_: pkgs: { });

      packages = forAll (selfPackages: pkgs: {
        grafana = pkgs.grafana;
        default = selfPackages.grafana;

        deploy = pkgs.writeShellApplication {
          name = "deploy";
          text = ''
            echo "Deploying..."
            env
            sleep 50
            exit
          '';
        };
      });

      devShells = forAll (_: pkgs: { });

    };
}
