#!/usr/bin/env sh
MINIMIZED=$(hyprctl clients | awk '/^Window.*Obsidian v/{found=1} found && /^[ \t]+floating:/{print $2; found=0}')
if [ "$MINIMIZED" = 0 ] ; then
  echo "Minimizing"
  hyprctl --batch "\
    dispatch togglefloating (obsidian);\ 
    dispatch focuswindow (obsidian);\
    dispatch resizeactive exact 250 250;\
    dispatch moveactive exact 5100 1020"
  #  dispatch focuscurrentorlast"
  exit
else
  echo "Expanding"
  hyprctl --batch "\
    dispatch togglefloating (obsidian);\
    dispatch focuswindow (obsidian)"
fi
hyprctl reload


