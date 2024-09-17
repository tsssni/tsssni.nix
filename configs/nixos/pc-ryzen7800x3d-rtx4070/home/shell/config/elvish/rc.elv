set-env EDITOR nvim
set-env http_proxy 'http://127.0.0.1:7890'
set-env https_proxy 'http://127.0.0.1:7890'

fn ls {
  |@args| e:ls --color $@args 
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

eval (starship init elvish)
