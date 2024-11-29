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
          python312Packages.python
          # Executes some shell code to initialize a venv in $venvDir before the shell
          python312Packages.venvShellHook
          # Dependencies  from nixpkgs, which will add them to PYTHONPATH
          python312Packages.colored
          python312Packages.send2trash
          python312Packages.requests
          python312Packages.pylint
          python312Packages.pandas
          python312Packages.slack-sdk
          python312Packages.numpy
          # Packages to be installed locally
          file
          cdrtools
          ansible
          awscli
          libguestfs-with-appliance
          sshuttle
          sharutils
          msmtp
          bc
          mtr
          ethtool
          nmap
          dnsutils
          gnupg
          iperf3
          gotop
          which
          p7zip
          inxi
          terraform
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
