// For more information on customizing Oni,
// check out our wiki page:
// https://github.com/onivim/oni/wiki/Configuration


// https://github.com/onivim/oni/wiki/How-To:-Make-Oni-closer-to-bare-Vim-experience
const activate = (oni) => {
  oni.input.unbind("<c-g>") // make C-g work as expected in vim
  oni.input.bind("<s-c-g>", () => oni.commands.executeCommand("sneak.show")) // You can rebind Oni's behaviour to a new keybinding
  oni.input.unbind("<c-p>") // Disable Fuzzy Finder keybinding because it conflicts with yankring plugin
};

module.exports = {
    activate,
    "oni.hideMenu": true, // Hide default menu, can be opened with <alt>
    "oni.loadInitVim": true, // Load user's init.vim
    "oni.useDefaultConfig": false, // Do not load Oni's init.vim
    "autoClosingPairs.enabled": false, // disable autoclosing pairs
    'commandline.mode': false, // Do not override commandline UI
    'wildmenu.mode': false, // Do not override wildmenu UI

    "statusbar.enabled": false,
    "sidebar.enabled": false,

    "tabs.mode": "buffers",
    "environment.additionalPaths": ['/usr/bin', '/usr/local/bin', '/Library/TeX/texbin'],

    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",
    "ui.colorscheme": "nord",
    "editor.fontSize": "14px",
    // "editor.fontFamily": "Monaco",

    // "oni.bookmarks": ["~/Documents"],
    "editor.completions.mode": "oni",

    // Customize UI colors
    // "colors.menu.highlight": "#eeeeee",
}
