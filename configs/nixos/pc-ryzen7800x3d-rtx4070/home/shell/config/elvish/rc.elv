fn ls {|@args|
  e:ls --color $@args 
}

fn ssh-agent {
  var set_ssh_env = {|env_cmd|
    use str
    var env_var env_prec = (str:split '=' $env_cmd)
    var env_val env_expt env_tail = (str:split ';' $env_prec)
    set-env $env_var $env_val
  }
  var auth_sock_cmd agent_pid_cmd echo_cmd = (e:ssh-agent)
  $set_ssh_env $auth_sock_cmd
  $set_ssh_env $agent_pid_cmd
}

var set-base-name = {|@args|
  e:kitty @ set-tab-title (basename (pwd))
}

var set-tab-title = {|@args|
  if (> (count $@args) 0) {
    e:kitty @ set-tab-title $@args
  }
}

set E:EDITOR = nvim
set E:http_proxy = 'http://127.0.0.1:7890'
set E:https_proxy = 'http://127.0.0.1:7890'

set edit:before-readline = [ $set-base-name ]
set edit:after-readline = [ $set-tab-title ]

eval (starship init elvish)
