# in .config/fish/config.fish:
# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'


function fish_prompt
  set last_status $status

  set PROMPT_SIZE (printf '%s@%s ' (whoami) (hostname | cut -d . -f 1) | wc -c)
  if [ "$PROMPT_SIZE" -lt $COLUMNS ]  
    printf '%s@%s ' (whoami) (hostname | cut -d . -f 1)
  else
    set PROMPT_SIZE 0
  end

  set LAST_PROMPT_SIZE $PROMPT_SIZE
  set PROMPT_SIZE (math $PROMPT_SIZE + (printf '%s ' (prompt_pwd) | wc -c))
  if [ "$PROMPT_SIZE" -lt $COLUMNS ]
    set_color $fish_color_cwd
    printf '%s ' (prompt_pwd)
  else
    set PROMPT_SIZE $LAST_PROMPT_SIZE
  end
  set_color normal

  set PROMPT_SIZE (math $PROMPT_SIZE + (printf '%s ' (__fish_git_prompt) | wc -c))
  if [ "$PROMPT_SIZE" -lt $COLUMNS ]
    printf '%s ' (__fish_git_prompt)
    set_color normal
  end

end

function export
  if $argv
    set -xg ( echo $argv | cut -d = -f1 ) ( echo $argv | cut -d = -f2 )
  else
    set -xg
  end
end

set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1

set -xg ANDROID_HOME /usr/local/Cellar/android-sdk/r22.0.4
set -xg SSL_CERT_FILE /usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

function backup

  if not test $backup
    echo Backup not set
    return
  end

  set args
  set dest '/'
  set next 0
  for x in $argv
    if not test $next -eq 0
      echo "NEXT" $x $next
      set dest $x
      set next 0
    else if test "$x" = "to"
      printf "ARGS: %s, NEXT, %s, X: %s" $args $next $x
      set next 1
    else
      set args $args $x
    end
  end
  if test -d $backup/$dest
    echo copying $args to $dest
    cp -r $args $backup/$dest 
  else 
    echo creating $backup/$dest
    mkdir -p  $backup/$dest
    and echo copying $args to $backup/$dest
    and cp -r $args $backup/$dest
  end
end

