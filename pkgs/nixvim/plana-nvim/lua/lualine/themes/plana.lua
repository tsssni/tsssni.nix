local palette = require("plana.palette")
local theme = {
  a = { fg = palette.light_green },
  b = { fg = palette.light_cyan },
  c = { fg = palette.cyan },
  x = { fg = palette.blue },
  y = { fg = palette.light_magenta },
  z = { fg = palette.light_blue },
}

return {
  normal = theme,
  insert = theme,
  visual = theme,
  command = theme,
  replace = theme,
  inactive = theme,
}
