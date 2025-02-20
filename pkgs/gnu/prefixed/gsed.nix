{ 
  gnused
}:
gnused.overrideAttrs { 
	configureFlags = [ "--program-prefix=g" ]; 
}
