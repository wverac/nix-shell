{
  description = "sysBOFH modular nix-shell environment with profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:wverac/nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor = forAllSystems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });

  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      isLinux = pkgs.stdenv.isLinux;
      isDarwin = pkgs.stdenv.isDarwin;

      # Helper function to filter packages based on platform
      platformFilter = linuxPkgs: darwinPkgs:
        if isLinux then linuxPkgs
        else if isDarwin then darwinPkgs
        else [];
    in {
      # Minimal NixVim environment
      nixvim = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixvim.packages.${system}.default
          neovim
          ripgrep
          fd
          fzf
          tree
          bat
          eza
          zoxide
        ];
        shellHook = ''
          alias vim="nvim"
          alias vi="nvim"
          alias v="nvim"
          echo "NixVim profile loaded - minimal development environment"
        '';
        LABENV = "nixvim";
      };

      # DevOps tools environment
      devops = pkgs.mkShell {
        buildInputs = with pkgs; [
          python312Packages.python
          python312Packages.venvShellHook
          python312Packages.colored
          python312Packages.send2trash
          python312Packages.requests
          python312Packages.pylint
          python312Packages.pandas
          python312Packages.slack-sdk
          python312Packages.numpy
          python312Packages.clustershell
          python312Packages.beautifulsoup4
          python312Packages.selenium
          python312Packages.pillow

          ansible
          awscli
          terraform
          kubectl
          kubernetes-helm
          docker-compose
          vault
          consul
          nomad
          packer
          vagrant
          sshuttle
          lazygit
          git
          jq
          yq
          curl
          wget
          openssl
          gnupg
          direnv
          tmux
          screen
        ];
        shellHook = ''
          echo "DevOps profile loaded - full DevOps toolkit"
          python --version
        '';
        LABENV = "devops";
      };

      # BOFH system administration environment
      bofh = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Network troubleshooting
          nmap
          tcpdump
          traceroute
          mtr
          iperf3
          netcat
          socat
          dig
          dnsutils
          whois
          ngrep
          bandwhich
          nethogs
          iftop
          bmon

          # System monitoring
          htop
          btop
          gotop
          lsof

          # Filesystem & disk tools
          ncdu
          du-dust
          duf
          smartmontools
          ddrescue
          testdisk
          photorec
          e2fsprogs

          # File tools
          file
          binutils
          hexdump
          xxd
          strings

          # Compression & archives
          p7zip
          unrar
          unzip
          xz
          bzip2
          gzip
          tar
          cpio

          # Misc utilities
          tmux
          screen
          bc
          jq
          yq
          xmlstarlet
          pv
          expect
          socat
        ] ++ (platformFilter [
          # Linux-only packages
          wireshark-cli
          ethtool
          atop
          iotop
          sysstat
          dstat
          vmstat
          strace
          ltrace
          perf-tools
          hdparm
          extundelete
          foremost
          scalpel
          xfsprogs
          btrfs-progs
          zfs

          # Security & forensics (Linux-only)
          aide
          rkhunter
          chkrootkit
          lynis
          clamav
          fail2ban
          ossec
          tripwire
          sleuthkit
          volatility3
          binwalk
          radare2
          ghidra
          john
          hashcat
          aircrack-ng
          metasploit
          burpsuite

          # System info & hardware (Linux-only)
          inxi
          lshw
          dmidecode
          pciutils
          usbutils
          hwinfo
          lm_sensors
          stress
          stress-ng
          memtester

          # Process management (Linux-only)
          psmisc
          procps
          killall
          pgrep
          pkill
          nice
          renice

          # GPU tools (Linux-only)
          nvtop
          nvidia-system-monitor
          gpustat
        ] [
          # macOS alternatives or compatible tools
          # Most network and file tools work on macOS
          # but system-level tools are Linux-specific
        ]);
        shellHook = ''
          echo "BOFH profile loaded - system administration & troubleshooting toolkit"
          ${if isLinux then ''echo "Warning: This profile includes security testing tools. Use responsibly."'' else ''echo "Note: Some Linux-specific tools are not available on macOS"''}
        '';
        LABENV = "bofh";
      };

      # Combined environment with all profiles
      all = pkgs.mkShell {
        buildInputs = with pkgs; [
          # NixVim packages
          nixvim.packages.${system}.default
          neovim
          ripgrep
          fd
          fzf
          tree
          bat
          eza
          zoxide

          # DevOps packages
          python312Packages.python
          python312Packages.venvShellHook
          python312Packages.colored
          python312Packages.send2trash
          python312Packages.requests
          python312Packages.pylint
          python312Packages.pandas
          python312Packages.slack-sdk
          python312Packages.numpy
          python312Packages.clustershell
          python312Packages.beautifulsoup4
          python312Packages.selenium
          python312Packages.pillow
          ansible
          awscli
          terraform
          kubectl
          kubernetes-helm
          docker-compose
          vault
          consul
          nomad
          packer
          vagrant
          sshuttle
          lazygit
          git
          jq
          yq
          curl
          wget
          openssl
          gnupg
          direnv
          tmux
          screen

          # BOFH packages (cross-platform)
          nmap
          tcpdump
          traceroute
          mtr
          iperf3
          netcat
          socat
          dig
          dnsutils
          whois
          ngrep
          bandwhich
          nethogs
          iftop
          bmon
          htop
          btop
          gotop
          lsof
          ncdu
          du-dust
          duf
          smartmontools
          ddrescue
          testdisk
          photorec
          e2fsprogs
          file
          binutils
          hexdump
          xxd
          strings
          p7zip
          unrar
          unzip
          xz
          bzip2
          gzip
          tar
          cpio
          bc
          xmlstarlet
          pv
          expect
        ] ++ (platformFilter [
          # Linux-only packages for 'all' profile
          wireshark-cli
          ethtool
          atop
          iotop
          sysstat
          dstat
          vmstat
          strace
          ltrace
          perf-tools
          hdparm
          extundelete
          foremost
          scalpel
          xfsprogs
          btrfs-progs
          zfs
          aide
          rkhunter
          chkrootkit
          lynis
          clamav
          fail2ban
          ossec
          tripwire
          sleuthkit
          volatility3
          binwalk
          radare2
          ghidra
          john
          hashcat
          aircrack-ng
          metasploit
          burpsuite
          inxi
          lshw
          dmidecode
          pciutils
          usbutils
          hwinfo
          lm_sensors
          stress
          stress-ng
          memtester
          psmisc
          procps
          killall
          pgrep
          pkill
          nice
          renice
          nvtop
          nvidia-system-monitor
          gpustat
        ] []);
        shellHook = ''
          echo "All profiles loaded - complete environment"
          alias vim="nvim"
          alias vi="nvim"
          python --version
        '';
        LABENV = "all";
      };

      # Default shell (legacy compatibility - uses devops profile)
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Python interpreter required to bootstrap
          python312Packages.python
          # Executes some shell code to initialize a venv in $venvDir before the shell
          python312Packages.venvShellHook
          # Dependencies from nixpkgs, which will add them to PYTHONPATH
          python312Packages.colored
          python312Packages.send2trash
          python312Packages.requests
          python312Packages.pylint
          python312Packages.pandas
          python312Packages.slack-sdk
          python312Packages.numpy
          python312Packages.clustershell
          python312Packages.beautifulsoup4
          python312Packages.selenium
          python312Packages.pillow
          python312Packages.clustershell
          # Packages to be installed locally
          file
          cdrtools
          ansible
          awscli
          sshuttle
          sharutils
          msmtp
          bc
          mtr
          nmap
          dnsutils
          gnupg
          iperf3
          gotop
          which
          p7zip
          terraform
          git
          openssl
          curl
          lazygit
          jq
        ] ++ (platformFilter [
          # Linux-only packages for default profile
          libguestfs-with-appliance
          ethtool
          inxi
        ] []);

        shellHook = ''
          echo "w00t! (default profile)"
          python --version
        '';
        LABENV = "nebuchadnezzar";
      };
    });
  };
}