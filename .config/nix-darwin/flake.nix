{
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  description = "huvik's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      llm-agents,
      nixpkgs,
    }:
    let
      envUsername = builtins.getEnv "DOTFILES_USERNAME";
      envUid = builtins.getEnv "DOTFILES_UID";
      envHome = builtins.getEnv "DOTFILES_HOME";
      username = if envUsername == "" then "huvik" else envUsername;
      userHome = if envHome == "" then "/Users/${username}" else envHome;
      userUid = if envUid == "" then 501 else builtins.fromJSON envUid;
      llm-pkgs = llm-agents.packages."aarch64-darwin";
      darwinSystem = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = username;
              autoMigrate = true;
            };
          }
        ];
      };
      configuration =
        { pkgs, ... }:
        {
          # Ensure determinate systems manages installation and updates
          nix.enable = false;
          users.users.${username} = {
            home = userHome;
            shell = pkgs.fish;
            uid = userUid;
          };

          users.knownUsers = [ username ];

          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [
            pkgs.bun
            pkgs.bat
            pkgs.cloc
            pkgs.delta
            pkgs.dust
            pkgs.eza
            pkgs.fd
            pkgs.fnm
            pkgs.fzf
            pkgs.gh
            pkgs.git
            pkgs.gitleaks
            pkgs.httpie
            pkgs.jq
            pkgs.lazygit
            pkgs.mas
            pkgs.nil
            pkgs.pnpm
            pkgs.nixd
            pkgs.nixfmt
            pkgs.stow
            pkgs.ripgrep
            pkgs.tilt
            pkgs.tree
            pkgs.vim
            pkgs.watchman
            pkgs.zoxide
            pkgs.zx
            pkgs.postgresql_18
            llm-pkgs.amp
          ];

          system.primaryUser = username;
          homebrew = {
            enable = true;
            casks = [
              "1password"
              "1password-cli"
              "betterdisplay"
              "brave-browser"
              "claude"
              "claude-code"
              "cleanshot"
              "nkzw-tech/tap/codiff"
              "conductor"
              "discord"
              "ghostty"
              "imageoptim"
              "jordanbaird-ice"
              "linear"
              "mysides"
              "notion"
              "notion-calendar"
              "orbstack"
              "raycast"
              "shortcat"
              "slack"
              "spotify"
              "steam"
              "tableplus"
              "tailscale-app"
              "telegram"
              "vlc"
              "wispr-flow"
              "yaak"
              "zed"
            ];
            masApps = {
              # "Numbers" = 361304891;
              # "Pages" = 361309726;
              # "Canary Mail" = 1236045954;
            };
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "zap";
            };
          };
          # Enable alternative shell support in nix-darwin.
          programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          environment.systemPath = [ "/usr/local/bin" ];

          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.activationScripts.postActivation.text = ''
            # Avoid a logout/login cycle when changing settings
            sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
            # Disable language indicator popup
            sudo -u ${username} defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled -bool NO
            # Create user directories
            mkdir -p ${userHome}/Developer
            mkdir -p ${userHome}/Documents/Screenshots
            # Suppress "Last login" message
            touch ${userHome}/.hushlogin
            # Add Developer folder to Finder sidebar
            if ! sudo -u ${username} /usr/local/bin/mysides list | grep -q "Developer"; then
              sudo -u ${username} /usr/local/bin/mysides add Developer file://${userHome}/Developer
            fi
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
              # Disable hot corners
              wvous-tl-corner = 1;
              wvous-bl-corner = 1;
              wvous-tr-corner = 1;
              wvous-br-corner = 1;
            };
            CustomUserPreferences = {
              "com.apple.symbolichotkeys" = {
                AppleSymbolicHotKeys = {
                  # Disable Screenshots
                  # CMD + SHIFT + 3: Take screenshot of entire screen
                  "20" = {
                    enabled = false;
                  };
                  # CMD + SHIFT + 4: Take screenshot of selected area
                  "28" = {
                    enabled = false;
                  };
                  "29" = {
                    enabled = false;
                  };
                  # CMD + SHIFT + 5: Take screenshot or record screen
                  "30" = {
                    enabled = false;
                  };
                  "31" = {
                    enabled = false;
                  };
                  # Disable input sources switching
                  "60" = {
                    enabled = 1;
                    value = {
                      parameters = [
                        32
                        49
                        1572864
                      ];
                      type = "standard";
                    };
                  };
                  "61" = {
                    enabled = false;
                  };
                  # Disable 'Cmd + Space' for Spotlight Search
                  "64" = {
                    enabled = false;
                  };
                  # Disable 'Cmd + Alt + Space' for Finder search window
                  "65" = {
                    enabled = false;
                  };
                  # Simplified Chinese input method
                  "262" = {
                    enabled = false;
                  };
                };
              };
            };
            finder = {
              AppleShowAllFiles = true;
              CreateDesktop = true;
              FXDefaultSearchScope = "SCcf"; # Search the current folder
              FXEnableExtensionChangeWarning = false;
              ShowStatusBar = true;
              _FXShowPosixPathInTitle = true;
              _FXSortFoldersFirst = true;
            };
            screencapture = {
              location = "~/Documents/Screenshots";
            };
          };

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#huvik
      darwinConfigurations."huvik" = darwinSystem;
      darwinConfigurations."hvk" = darwinSystem;
    };
}
