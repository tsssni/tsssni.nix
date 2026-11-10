{
  moonlight-qt,
  ffmpeg-decode,
}:
(moonlight-qt.override { ffmpeg = ffmpeg-decode; }).overrideAttrs {
  pname = "moonlight-luna";
}
