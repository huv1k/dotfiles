{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, nixpkgs }:
    let
      configuration = { pkgs, ... }: {

        users.users.lukashuvar = {
          home = "/Users/lukashuvar";
          shell = pkgs.fish;
          uid = 502;
        };

        users.knownUsers = [ "lukashuvar" ];

        # Not free applications
        nixpkgs.config.allowUnfree = true;
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.bat
          pkgs.dust
          pkgs.eza
          pkgs.fd
          pkgs.fish
          pkgs.fnm
          pkgs.fzf
          pkgs.gh
          pkgs.git
          pkgs.gitleaks
          pkgs.httpie
          pkgs.jq
          pkgs.lazygit
          pkgs.nil
          pkgs.nixd
          pkgs.nixfmt-classic
          pkgs.telegram-desktop
          pkgs.tilt
          pkgs.tree
          pkgs.vim
          pkgs.watchman
          pkgs.zoxide
          pkgs.zx
          pkgs.eza
        ];

        homebrew = {
          enable = true;
          brews = [ "mas" "stow" "git-delta" "bun" ];
          casks = [
            "1password"
            "1password-cli"
            "betterdisplay"
            "brave-browser"
            "cleanshot"
            "discord"
            "ghostty"
            "notion"
            "notion-calendar"
            "orbstack"
            "raycast"
            "shortcat"
            "spotify"
            "steam"
            "tableplus"
            "tailscale"
            "telegram"
            "vlc"
            "yaak"
            "zed"
            "imageoptim"
            # "pbctl"
          ];
          masApps = {
            "Affinity Designer" = 824171161;
            "Affinity Photo" = 824183456;
          };
          # taps = [
          #   "productboard/tools"
          # ];
          # extraConfig = ''
          #   tap "productboard/tools", "git@github.com:productboard/homebrew-tools.git"
          # '';
        };
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        system.activationScripts.postUserActivation.text = ''
          # Following line should allow us to avoid a logout/login cycle when changing settings
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';

        # TODO: change display scale
        system.defaults = {
          NSGlobalDomain = {
            AppleKeyboardUIMode = 3;
            AppleInterfaceStyle = "Dark";
            AppleShowAllExtensions = true;
          };
          dock = {
            autohide = true;
            persistent-apps = [ ];
            tilesize = 28;
            show-recents = false;
            static-only = true;
          };
          CustomUserPreferences = {
            "com.apple.symbolichotkeys" = {
              AppleSymbolicHotKeys = {
                # Disable Screenshots
                "28" = { enabled = false; };
                "29" = { enabled = false; };
                "30" = { enabled = false; };
                "31" = { enabled = false; };
                # Disable input sources switching
                "60" = { enabled = false; };
                "61" = { enabled = false; };
                # Disable 'Cmd + Space' for Spotlight Search
                "64" = { enabled = false; };
                # Disable 'Cmd + Alt + Space' for Finder search window
                "65" = { enabled = false; };
                # Simplified Chinese input method
                "262" = { enabled = false; };
              };
            };
          };
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            CreateDesktop = true;
            FXDefaultSearchScope = "SCcf"; # Search the current folder
            FXEnableExtensionChangeWarning = false;
            ShowStatusBar = true;
            _FXShowPosixPathInTitle = true;
            _FXSortFoldersFirst = true;
          };
          screencapture = { location = "~/Documents/Screenshots"; };
        };

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#hvk
      darwinConfigurations."hvk" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          # mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "lukashuvar";
              autoMigrate = true;
            };
          }
          {
            system.activationScripts.postUserActivation.text = ''
              mkdir -p ~/Developer
              mkdir -p ~/Documents/Screenshots
            '';
          }
        ];
      };
    };
}
