{
  gnugrep
}:
gnugrep.overrideAttrs {
  configureFlags = [ "--program-prefix=g" ]; 
  postInstall =
    ''
      echo "#! /bin/sh" > $out/bin/egrep
      echo "exec $out/bin/grep -E \"\$@\"" >> $out/bin/egrep
      echo "#! /bin/sh" > $out/bin/fgrep
      echo "exec $out/bin/grep -F \"\$@\"" >> $out/bin/fgrep
      chmod +x $out/bin/egrep $out/bin/fgrep
    '';  
}
