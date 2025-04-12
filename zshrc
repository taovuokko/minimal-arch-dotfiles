


source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # Pacman-asennus


# 🎨 Paremmat värit LS / exa -komennolle (tumma tausta)
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;92:*.sh=1;93:*.out=1;91:*.c=1;94:*.py=1;95:*.txt=1;97:'

# 🎨 Värikoodit
autoload -U colors && colors
autoload -Uz vcs_info

# 🏎️ Nopeampi prompt
setopt PROMPT_SUBST




# 🚀 Perusaliasit (paremmat työkalut)
alias cat='bat --paging=never'  # Parempi cat
alias ls='exa --icons --group-directories-first'  # Parempi ls
alias ll='exa -l --icons'  # Pitkä listaus
alias la='exa -la --icons'  # Näytä myös piilotiedostot
alias grep='grep --color=auto'  # Värillinen grep
alias df='df -h'  # Ihmislukuisempi df
alias apu='bat /home/tv/helppi.md'
alias du='du -h'  # Ihmislukuisempi du
alias kuva="kitten icat"
alias update="sudo pacman -Sy --noconfirm --needed archlinux-keyring && paru -Su --noconfirm"

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word




# 🔥 Zoxide - nopeampi cd (käyttää fzf:ää)
eval "$(zoxide init zsh)"
alias cd='z'  # Käytä "z hakemisto" siirtymiseen

# 📂 1️⃣ Fuzzy Finder hakemistovaihtaja (FD + FZF + CD)
function fcd() {
  local dir
  dir=$(fd --type d . ~/ | fzf --height=20% --reverse --preview 'exa -T --color=always {}') && cd "$dir" || return
}
alias cdf='fcd'  # Helppo alias

# 📜 2️⃣ Fuzzy Finder tiedostohaku ja avaus (FD + FZF + NVIM)
function vf() {
  local file
  file=$(fd --type f | fzf --height=20% --reverse --preview "bat --color=always {}") && nvim "$file" || return
}
alias v='vf'  # Lyhyt alias

# 🔄 3️⃣ Jo avattujen tiedostojen uudelleenavaus (trackataan ja avataan fzf:llä)
export RECENT_FILES=~/.recent_files
touch "$RECENT_FILES"

function track_file() {
  echo "$1" >> "$RECENT_FILES"
  sort -u -o "$RECENT_FILES" "$RECENT_FILES"
}
alias track='track_file'  # Lisää tämä komentoihin, joilla avaat tiedostoja

function recent() {
  local file
  file=$(cat "$RECENT_FILES" | fzf --height=20% --reverse --preview "bat --color=always {}") && nvim "$file" || return
}
alias r='recent'  # Käytä "r" avatakseen viimeksi käytettyjä tiedostoja

# 🔍 4️⃣ Fuzzy Finder komennot + man-page preview
function fman() {
  local cmd
  cmd=$(compgen -c | sort -u | fzf --preview 'man {}') && man "$cmd"
}
alias manf='fman'  # Fuzzy man-haku

# 🏎️ 5️⃣ Supernopea Ctrl+R historiahaku
export FZF_DEFAULT_OPTS="--height=40% --reverse --border"
bindkey '^R' fzf-history-widget


# 🎨 Mukautettu ZSH Syntax Highlighting -värit (paremmat tummalle taustalle)
typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[default]='fg=#E6E6E6'        # Perusväri (vaaleaa harmaata)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'  # Tuntematon komento (punainen)
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#FFA500,bold'   # Sisäänrakennetut komennot (oranssi, lihavoitu) 🟠
ZSH_HIGHLIGHT_STYLES[alias]='fg=#50FA7B'          # Aliasit (vihreä)
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#BD93F9'  # Varatut sanat (lila)
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#8BE9FD'   # Aliasien perään tulevat osat (sininen)
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#FFB86C,bold'  # Prekomennot, kuten "sudo" (oranssi, bold) 🟠🔥
ZSH_HIGHLIGHT_STYLES[command]='fg=#50FA7B'        # Komennot (vihreä)
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#FF79C6'  # `$(komento)` (pinkki)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#BD93F9'       # Jokerimerkit (*, ?) (lila)
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#FF79C6' # Historiaoperaattorit (!, ^) (pinkki)
ZSH_HIGHLIGHT_STYLES[path]='fg=#8BE9FD'           # Polut ja tiedostonimet (vaaleansininen)
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#FFB86C'  # Automaattiset hakemistot (oranssi)
ZSH_HIGHLIGHT_STYLES[quoted]='fg=#F1FA8C'         # Lainausmerkeissä olevat asiat (keltainen)
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'        # Kommentit (#) (harmaa)
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#50FA7B,bold'      # Ensimmäinen argumentti (vihreä, bold)
ZSH_HIGHLIGHT_STYLES[option]='fg=#FFB86C'         # Vaihtoehdot (--help, -v) (oranssi)
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#FF79C6'    # Uudelleenohjaukset (>, <, |) (pinkki)


# 🖥️ Promptin värit
HOST_COLOR="%F{cyan}"       # Koneen nimi
DIR_COLOR="%F{blue}"        # Hakemisto
GIT_COLOR="%F{magenta}"     # Git-haara
RESET_COLOR="%f"            # Resetoi värit
PROMPT_SYMBOL="❯"           # Promptin symboli
PROMPT_COLOR="%F{green}"    # Promptin väri

# 🔥 GIT-haaran näyttäminen
precmd() { vcs_info }
zstyle ':vcs_info:*' formats " %F{yellow}[%b]%f"

# 🌈 Promptin ulkoasu
PROMPT='${HOST_COLOR}%n@%m%f ${DIR_COLOR}%~%f${vcs_info_msg_0_} ${PROMPT_COLOR}${PROMPT_SYMBOL} %f'

# 🏎️ Lisää tilaa komentoja varten
RPROMPT=''



# 🔄 Päivitä historia ja jaa istuntojen välillä
HISTSIZE=50000        # Säilytä 50 000 komentoa istunnossa
SAVEHIST=50000        # Tallenna myös tiedostoon
HISTFILE=~/.zsh_history  

# 🔄 Estetään tuplakomennot historiassa
setopt hist_ignore_all_dups   # Poista duplikaatit historiasta
setopt hist_ignore_space      # Älä tallenna komentoa, joka alkaa välilyönnillä
setopt hist_find_no_dups      # Älä näytä samaa komentoa useaan kertaan haussa
setopt hist_reduce_blanks     # Poista turhat välilyönnit
setopt share_history          # Jaa historia istuntojen välillä (toimii tmux/kittyssä)
setopt inc_append_history     # Päivitä historia reaaliajassa ilman, että pitää sulkea istuntoa

# ⬆️⬇️ Parempi nuolinäppäinten historiahaku
#bindkey "^[[A" up-line-or-search
#bindkey "^[[B" down-line-or-search


bindkey '^[[A' fzf-history-widget
bindkey '^[[B' down-line-or-search


# Lataa fzf:n widgetit Zsh:lle
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi


# 🔧 Lataa vain tarvittavat pluginit
if [[ -f ~/.zsh_plugins.sh ]]; then
    source ~/.zsh_plugins.sh
fi

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PATH="$HOME/.local/bin:$PATH"
