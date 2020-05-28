# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
PATH=$PATH:~/.local/bin

# dotnet telemetry disable
export DOTNET_CLI_TELEMETRY_OPTOUT=1

bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
# Add -d and new path
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
# autoload -Uz promptinit
# promptinit

# autocompletion with an arrow-key driven interface
zstyle ":completion:*" menu select
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
# zstyle ":completion:*:descriptions" format "%U%B%d%b%u" 
# zstyle ":completion:*:warnings" format "%BSorry, no matches for: %d%b" 


# autocorrection
setopt correctall
# avoid tedious typing of cd command while changing current directory (for example /etc instead of cd /etc). 
setopt autocd
# may be set to enable extended globbing (one similar to regular expressions). 
# extended globbing queries such as cp ^*.(tar are available for use. 
setopt extendedglob
# enabling autocompletion of privileged environments in privileged commands
# Warning: This will let zsh completion scripts run commands with sudo privileges. 
# You should not enable this if you use untrusted autocompletion scripts.
#zstyle ":completion::complete:*" gain-privileges 1

# Only the past commands matching the current line up to the current cursor position will be shown.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "^[[A" ]] && bindkey -- "^[[A"   up-line-or-beginning-search
[[ -n "^[[B" ]] && bindkey -- "^[[B" down-line-or-beginning-search

alias ls="ls --color -F"
alias ll="ls -la --color -lh"

alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias pacman="pacman --color auto"
alias mount-ntfs="mount.ntfs-3g -o dmask=022,fmask=133"
alias du-sorted="du -had 1 | sort -rh"
alias code="code --extensions-dir $XDG_DATA_HOME/vscode/extensions"

alias spm="sudo pacman"
alias pm="pacman"

compdef pm=pacman
compdef spm=pacman

# autocompletion of command line switches for aliases
setopt COMPLETE_ALIASES

#------------------------------
# Color
#------------------------------

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

#------------------------------
# Key Bindin
#------------------------------
# Ctrl-V in terminal followed by keypress will show key code.
#       key_code   ZLE_functions    
bindkey "^[[H"     beginning-of-line
bindkey "^[[F"     end-of-line

bindkey "^[[3~"    delete-char
bindkey "^[[2~"    overwrite-mode

bindkey "^[[1;5D"  backward-word
bindkey "^[[1;5C"  forward-word

# Check if not virtual console.
if [[ -v DISPLAY ]]; then
    # Can"t use $HOME since root
    source "/home/vit_arch/.local/share/zsh/agnoster.zsh-theme"
else
    setopt PROMPT_SUBST
    PROMPT="%~ %# "
fi

#------------------------------
# Window title
#------------------------------
# autoload -Uz vcs_info
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      # vcs_info
      print -Pn "\e]0;%~\a"
    } 
    preexec () { print -Pn "\e]0;%~ ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () { 
      # vcs_info
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
    }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
    }
    ;; 
esac

#------------------------------
# Dirs. Keeps DIRSTACKSIZE last locations.
#------------------------------
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS
## This reverts the +/- operators.
setopt PUSHD_MINUS
# dirs. End

export LS_COLORS="$LS_COLORS:ow=1;35;35:tw=1;34;35:"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
