{ pkgs, lib }:
with lib;
{
  DOT_BASHRC = mkDefault ''
    confCommit() (
      [ -z $1 ] && exit 1
      cd -- $1 || exit 1
      while true; do
        read -p "Do you wish to commit configuration.nix changes? [yN] " yn_conf
        case $yn_conf in
            [Yy]* )
              git update-index --no-skip-worktree configuration.nix
              ;;
        esac
        git diff
        read -p "Do you wish to commit these changes? [yN] " yn
        case $yn in
            [Yy]* )
              git add .
              git commit -m "$(date +%Y/%m/%d-%H:%M:%S)"
              git push
              break
              ;;
            * )
              break
              ;;
        esac
      done
      git update-index --skip-worktree configuration.nix
    )
    
    alias cat='bat'
  '';
}

# vim:expandtab ts=2 sw=2
