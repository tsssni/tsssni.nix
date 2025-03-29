use ./env
use ./kitty

fn ls {|@args|
	e:ls --color $@args 
}

eval (oh-my-posh init elvish -c "~/.config/oh-my-posh/config.json")
