{
  linuxPackages,
}:
linuxPackages.nvidiaPackages.latest.overrideAttrs (prev: {
  meta = prev.meta // {
    hydraPlatforms = [ ];
  };
  postFixup = (prev.postFixup or "") + ''
    rm -r \
      $out/lib/libcudadebugger.so* \
      $out/lib/libglxserver_nvidia.so* \
      $out/lib/libnvidia-{ngx,nvvm,nvvm70,opencl,ptxjitcompiler,tileiras,vksc-core}.so* \
      $out/lib/libnvoptix.so* \
      $out/lib/nvoptix.bin \
      $out/lib/nvidia/wine \
      $out/etc/OpenCL \
      $bin/lib/xorg
    rm $firmware/lib/firmware/nvidia/$version/*_tu10x.bin
  '';
})
