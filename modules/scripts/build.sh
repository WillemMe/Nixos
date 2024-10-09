#nix shell zsh
# Rebuild system
echo -n "Rebuilding NixOS... "
echo -ne "\033[?1049h\033[H" # enter alt-buff and clear
echo "Rebuilding NixOS..."

set +o pipefail # Disable pipafail since we check ourselves
# shellcheck disable=SC2024 #ah the irony
sudo nixos-rebuild switch --show-trace --flake $NIXOS_CONFIG_DIR 2>&1 | tee .nixos-switch.log
exit_code="${PIPESTATUS[0]}"
set -o pipefail # Re-enable pipefail

# Wait a bit before exiting buffer
echo  -e "\n\033[34mNixOS rebuild completed\033[0m (code: $exit_code)"
echo -ne "\rExit in 3" && sleep 1
echo -ne "\rExit in 2" && sleep 1
echo -ne "\rExit in 1" && sleep 1
echo -ne "\033[?1049l" # exit alt-buff

# Check exit code of nixos-rebuild and act accordingly
if [[ "${exit_code}" == 0 ]]; then
	echo -e "Done\n"
else
	echo ""
	cat .nixos-switch.log | grep --color error

	# this is needed otherwise the script would not start next time telling you "no changes detected"
	# (The weird patter is to include all subdirectories)
	sudo git restore --staged ./**/*.nix

	if read -p "Open log? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		cat .nixos-switch.log | vim - 	
	fi

	# Clean stuff and exit
	shopt -u globstar
	popd > /dev/null
	exit 1
fi
