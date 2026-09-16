// Custom bootstrap so the engine never reaches a third party.
//
// fontFallbackBaseUrl defaults to https://fonts.gstatic.com/s/, which the engine
// uses for the Noto fallback fonts it downloads when text needs a glyph the
// bundled fonts do not carry. Pointing it at this origin keeps the demo free of
// third-party requests. Nothing is served from that path, so text outside the
// bundled fonts renders as empty boxes, which no supported locale produces.
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: { fontFallbackBaseUrl: "fonts/fallback/" },
});
