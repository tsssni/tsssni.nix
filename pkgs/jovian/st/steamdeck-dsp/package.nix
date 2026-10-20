{
  faust,
  removeReferencesTo,
  steamdeck-dsp,
  store-prune,
}:
store-prune steamdeck-dsp {
  post = "find lib -name '*.so' -exec ${removeReferencesTo}/bin/remove-references-to -t ${faust} {} +";
}
