{
	description = "Macstar system Darwin Flake";
	inputs = {
		# Use `github:NixOS/nixpkgs/nixpkgs-25.05-darwin` to use Nixpkgs 25.05.
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		# Use `github:nix-darwin/nix-darwin/nix-darwin-25.05` to use Nixpkgs 25.05.
		nix-darwin.url = "github:nix-darwin/nix-darwin/master";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		mac-app-util.url = "github:hraban/mac-app-util";	  
		nix-homebrew.url = "github:zhaofengli/nix-homebrew";
		home-manager.url = "github:nix-community/home-manager";
		# Optional: Declarative tap management
		homebrew-core = {
			url = "github:homebrew/homebrew-core";
			flake = false;
		};
		homebrew-cask = {
			url = "github:homebrew/homebrew-cask";
			flake = false;
		};
	};
	outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, home-manager, nix-homebrew, homebrew-core, homebrew-cask, ... }:
	let
	configuration = { pkgs,config,python313Packages, ... }: {
		# List packages installed in system profile. To search by name, run:
		# $ nix-env -qaP | grep wget
		environment.systemPackages = with pkgs; [
			btop
			cowsay
			curl
			curl
			ddate
			devenv
			fastfetch
			fish
			ffmpeg
			fortune-kind
			gdu
			gh
			git
			git
			htop
			lolcat
			lynx
			mc
			metasploit
			mkalias 
			neovim
			nix-search-cli
			nmap
			pay-respects
			scdl
			sl
			stow
			tree
			wget
		];
		homebrew = {
			enable = true;
			onActivation = {
				autoUpdate = true;
				cleanup = "zap";
				upgrade = true;
			};
			brews = [
				"http-server"
				"mas"
			];
			casks = [
				"brave-browser"
				"cleanupbuddy"
				"cog-app"
				"discord"
				"ente-auth"
				"firefox"
				"fleet"
				"fontbase"
				"ghostty"
				"gimp"
				"git-it"
				"github"
				"grandperspective"
				"iina"
				"kitty"
				"libreoffice"
				"multitouch"
				"onyx"
				"orion"
				"pearcleaner"
				"porting-kit"
				"proton-mail-bridge"
				"protonvpn"
				"retroarch"
				"steam"
				"swift-quit"
				"vimr"
				"wireshark-app"
				"yubico-authenticator"
				"zenmap"
			];
			masApps = {
				"Bitdefender Virus Scanner" = 500154009;
				"Brotato:Premium" = 1668755109;
				"Developer" = 640199958;
				"Diagrams" = 1276248849; 		
				"GarageBand" = 682658836;
				"iMovie" = 408981434;
				"iStatistica Pro" = 1447778660;
				"Keynote" = 409183694;
				"Nitro" = 1591292532;
				"Numbers" = 409203825;
				"Pages" = 409201541;
				"Proton Pass for Safari" = 6502835663;
				"Remote Activity Monitor" = 6449398596;
				"Remote Desktop Scanner Pro" = 6447154313;
				"Steam Link" = 1246969117;
				"System Toolkit Pro" = 6471391855;
				"System Dashboard Pro" = 1672838414;
				"Xcode" = 497799835;
				};
		};
		fonts.packages = [
			pkgs.nerd-fonts.jetbrains-mono
			pkgs.nerd-fonts.open-dyslexic
		];

		# Necessary for using flakes on this system.
		nix.settings.experimental-features	= [ "nix-command" "flakes" ];
	  	nix.settings.download-buffer-size = 524288000;	
		# Enable alternative shell support in nix-darwin.
		# programs.fish.enable = true;

		# WHD enable primary user for homebrew
		system.primaryUser = "poiuyt"; 

		# Set Git commit hash for darwin-version.
		system.configurationRevision = self.rev or self.dirtyRev or null;

		# Used for backwards compatibility, please read the changelog before changing.
		# $ darwin-rebuild changelog
		system.stateVersion = 6;

		# The platform the configuration will be used on.
		nixpkgs.hostPlatform = "aarch64-darwin";

		#Needed for determinate nix WHD 250926
		nix.enable = false;
		};
		in
		{
			# Build darwin flake using:
			# $ darwin-rebuild build --flake .#ministar
			darwinConfigurations."ministar" = nix-darwin.lib.darwinSystem {
				modules = [ 
				configuration
				mac-app-util.darwinModules.default 
				nix-homebrew.darwinModules.nix-homebrew {
				nix-homebrew = {
					# Install Homebrew under the default prefix
					enable = true;
					# Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
					enableRosetta = true;
					# User owning the Homebrew prefix
					user = "poiuyt";
					# Automatically migrate existing Homebrew installations
					autoMigrate = true;
					# Optional: Declarative tap management
					taps = {
						"homebrew/homebrew-core" = homebrew-core;
						"homebrew/homebrew-cask" = homebrew-cask;
					};
					# Optional: Enable fully-declarative tap management
					#
					# With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
					mutableTaps = false;
					};
				}
				# Optional: Align homebrew taps config with nix-homebrew
				({config, ...}: {
					homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
				})
			];
		};
	};
}

