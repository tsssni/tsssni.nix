fn ls {|@args|
	e:ls --color $@args 
}

var set-base-name = {|@args|
	e:kitty @ set-tab-title (basename (pwd))
}

var set-tab-title = {|@args|
	if (> (count $@args) 0) {
		e:kitty @ set-tab-title $@args
	}
}

set-env EDITOR nvim

set-env XCURSOR_SIZE 24
set-env XCURSOR_THEME macOS
set-env QT_QPA_PLATFORMTHEME qt5ct

set-env LIBVA_DRIVER_NAME nvidia
set-env XDG_SESSION_TYPE wayland
set-env GBM_BACKEND nvidia-drm
set-env __GLX_VENDOR_LIBRARY_NAME nvidia

if (==s $E:TERM 'xterm-kitty') {
	set edit:before-readline = [ $set-base-name ]
	set edit:after-readline = [ $set-tab-title ]
}

eval (oh-my-posh init elvish -c "~/.config/oh-my-posh/config.json")
