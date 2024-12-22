{
  gnumake
}:
gnumake.overrideAttrs (oldAttrs: {
  configureFlags = oldAttrs.configureFlags ++ [ "--program-prefix=g" ];
})
