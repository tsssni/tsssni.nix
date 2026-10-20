{
  zfs,
}:
zfs.overrideAttrs (prev: {
  postPatch = prev.postPatch + ''
    sed -i 's|"/nix/store/[^"]*/bin/exportfs"|"/run/current-system/sw/bin/exportfs"|' lib/libshare/os/linux/nfs.c
  '';
  postFixup = prev.postFixup + ''
    rm -r $out/libexec/zfs/zpool.d $out/etc/zfs/zpool.d/*
  '';
})
