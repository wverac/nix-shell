{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Python interpreter required to bootstrap
          python313Packages.python
          # Executes some shell code to initialize a venv in $venvDir before the shell
          python313Packages.venvShellHook
          # Dependencies  from nixpkgs, which will add them to PYTHONPATH
          python313Packages.colored
          python313Packages.send2trash
          python313Packages.requests
          python312Packages.pylint
          # Packages to be installed locally
          git
          openssl
          curl
        ];

        shellHook = ''
          echo "w00t!"
          python --version
        '';
        # ENV vars
        LABENV = "nebuchadnezzar";
      };
    };

  };
}
