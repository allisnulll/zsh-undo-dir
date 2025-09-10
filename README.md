# Zsh-Undo-Dir
Undo and redo current working directory changes

![gif](assets/example.gif)

## How to Install
### Manually:
1. Change your directory to wherever you would like to install the plugin

    *Example*:
    ```sh
    cd ~/.zsh/plugins
    ```

2. Run these commands:
    ```sh
    git clone https://github.com/allisnulll/zsh-undo-dir
    echo "source $PWD/zsh-undo-dir/zsh-undo-dir.plugin.zsh" >> $HOME/.zshrc
    ```
    *(All this does is clone the repository and source the script at the end of your `.zshrc` file)*

### With a Plugin Manager:
#### Zinit
1. Source `zinit.zsh` at the start of your `.zshrc` *(This will depend on where you installed Zinit)*
    ```sh
    source /usr/share/zinit/zinit.zsh
    ```

1. Use *Zinit* to add the plugin by adding this line to the end of your `.zshrc`
```sh
zinit light allisnulll/zsh-undo-dir
```

## Keybinds:
```sh
bindkey -M emacs "^o" undo_dir
bindkey -M vicmd "^o" undo_dir
bindkey -M viins "^o" undo_dir
bindkey -M emacs "^[[1;2R" redo_dir
bindkey -M vicmd "^[[1;2R" redo_dir
bindkey -M viins "^[[1;2R" redo_dir
```

The default keybinds are meant to be similar to the keymaps for jumplists in **Vim**, but can be mapped to whatever you want.

### How to make the default keybinds work
Terminal emulators interpret *Ctrl-I* to be the same key as *Tab*. This is a problem when you want to retain the functionality of the *Tab* key while also binding *Ctrl-I* to something else. The way that I circumvent this is by having my terminal remap *Ctrl-I* to *F13* and to map ***redo_dir*** to *F13* instead.

You can run `cat` and press the desired key to see what characters the terminal receives. As long as it receives different characters for *Tab* and *Ctrl-I*, then they can act separately.

**Example Wezterm Config:**
```lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.keys = {{
    key = "i",
    mods = "CTRL",
    action = wezterm.action.SendKey({ key = "F13" }),
}}

return config
```
