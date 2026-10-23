{
  sing-box,
}:
(sing-box.override { withNaiveOutbound = false; }).overrideAttrs {
  pname = "hysteria-box";
  tags = [
    "with_quic"
    "with_clash_api"
    "badlinkname"
    "tfogo_checklinkname0"
  ];
}
