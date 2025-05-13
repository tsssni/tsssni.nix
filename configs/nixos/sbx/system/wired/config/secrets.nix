let
	publicKeys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINs7JUeKdbtr8B1tAdyNIlRjedkVreAtKERKvAb4ltAq dingyongyu2002@foxmail.com"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJax0Eo+863xqIl7cHSAQKY8NP/cK3ea8R6OiIUWCtzT dingyongyu2002@foxmail.com"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZEdiw08uuZzGZm7D224Wi2WA8RbPqqPkwlTcu5AZEv root@sbx"
	];
in {
	"sbx-cert.age".publicKeys = publicKeys;
	"sbx-key.age".publicKeys = publicKeys;
	"sbx-name.age".publicKeys = publicKeys;
	"sbx-passwd.age".publicKeys = publicKeys;
	"sbx-server.age".publicKeys = publicKeys;
	"sbx-cloudflare.age".publicKeys = publicKeys;
}
