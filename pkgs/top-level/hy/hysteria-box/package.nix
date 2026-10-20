{
  sing-box,
}:
(sing-box.override { withNaiveOutbound = false; }).overrideAttrs (prev: {
  pname = "hysteria-box";
  tags = [
    "with_quic"
    "with_clash_api"
    "badlinkname"
    "tfogo_checklinkname0"
  ];
  ldflags = prev.ldflags ++ [
    "-s"
    "-w"
  ];
})
