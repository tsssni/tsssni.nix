var kitty-base = {|@args|
	e:kitty @ set-tab-title (basename (pwd))
}

var kitty-title = {|@args|
	if (> (count $@args) 0) {
		e:kitty @ set-tab-title $@args
		e:kitty @ set-window-title $@args
	}
}

if (==s $E:TERM 'xterm-kitty') {
	set edit:before-readline = [ $kitty-base ]
	set edit:after-readline = [ $kitty-title ]
}


