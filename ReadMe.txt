Modes
-----
  normal_mode = "n",
  insert_mode = "i",
  visual_mode = "v",
  visual_block_mode = "x",
  term_mode = "t",
  command_mode = "c",

Key
---
  <M-> = Alt
  <A-> = Alt
  <C-> = Ctrl
  <S-> = Shift

stdpath()
---------
  config User configuration directory. |init.vim| is stored here. /home/luozhiya/.config/nvim/
  cache  Cache directory: arbitrary temporary storage for plugins, etc. maybe log. /home/luozhiya/.cache/nvim/
  data   User data directory. /home/luozhiya/.local/share/nvim/
  log    Logs directory (for use by plugins too). /home/luozhiya/.local/state/nvim/

completeopt
-----------
  'completeopt' 'cot'	string	(default: "menu,preview")
	A comma-separated list of options for Insert mode completion
	ins-completion.  The supported values are:
  menu	    Use a popup menu to show the possible completions.  The
    menu is only shown when there is more than one match and
    sufficient colors are available.  ins-completion-menu
  menuone  Use the popup menu also when there is only one match.
    Useful when there is additional information about the
    match, e.g., what file it comes from.
  longest  Only insert the longest common text of the matches.  If
    the menu is displayed you can use CTRL-L to add more
    characters.  Whether case is ignored depends on the kind
    of completion.  For buffer text the 'ignorecase' option is
    used.
  preview  Show extra information about the currently selected
    completion in the preview window.  Only works in
    combination with "menu" or "menuone".
noinsert  Do not insert any text for a match until the user selects
    a match from the menu. Only works in combination with
    "menu" or "menuone". No effect if "longest" is present.
noselect  Do not select a match in the menu, force the user to
    select one from the menu. Only works in combination with
    "menu" or "menuone".