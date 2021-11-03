--- alacritty transform, expects a table in the shape:
--
-- @param colors {
--   fg = "#000000",
--   bg = "#000000",
--   cursor_fg = "#000000",
--   cursor_bg = "#000000",
--   black = "#000000",
--   red = "#000000",
--   green = "#000000",
--   yellow = "#000000",
--   blue = "#000000",
--   magenta = "#000000",
--   cyan = "#000000",
--   white = "#000000",
--   bright_black = "#000000",
--   bright_red = "#000000",
--   bright_green = "#000000",
--   bright_yellow = "#000000",
--   bright_blue = "#000000",
--   bright_magenta = "#000000",
--   bright_cyan = "#000000",
--   bright_white = "#000000",
--
--   Optionally also include:
--
--   dim_black = "#000000",
--   dim_red = "#000000",
--   dim_green = "#000000",
--   dim_yellow = "#000000",
--   dim_blue = "#000000",
--   dim_magenta = "#000000",
--   dim_cyan = "#000000",
--   dim_white = "#000000",
-- }

local helpers = require("lush.transform.helpers")
local check_keys = {
  "fg", "bg",
  "cursor_fg", "cursor_bg",
  "black", "red", "green", "yellow", "blue",
  "magenta", "cyan", "white",
  "bright_black", "bright_red", "bright_green", "bright_yellow", "bright_blue",
  "bright_magenta", "bright_cyan", "bright_white",
}

local base_template = [[
colors:
  primary:
    foreground: '$fg'
    background: '$bg'
  cursor:
    foreground: '$cursor_fg'
    background: '$cursor_bg'
  normal:
    black:   '$black'
    red:     '$red'
    green:   '$green'
    yellow:  '$yellow'
    blue:    '$blue'
    magenta: '$magenta'
    cyan:    '$cyan'
    white:   '$white'
  bright:
    black:   '$bright_black'
    red:     '$bright_red'
    green:   '$bright_green'
    yellow:  '$bright_yellow'
    blue:    '$bright_blue'
    magenta: '$bright_magenta'
    cyan:    '$bright_cyan'
    white:   '$bright_white']]

-- dims are autogenerated if not given, so we only
-- template these if given
local dim_template = [[
  dim:
    black:   '$dim_black'
    red:     '$dim_red'
    green:   '$dim_green'
    yellow:  '$dim_yellow'
    blue:    '$dim_blue'
    magenta: '$dim_magenta'
    cyan:    '$dim_cyan'
    white:   '$dim_white']]

local function transform(colors)
  for _, key in ipairs(check_keys) do
    assert(colors[key],
      "alacritty colors table missing key: " .. key)
  end

  local text = helpers.apply_template(base_template, colors)
  if colors["dim_black"] ~= nil then
    local dims = helpers.apply_template(dim_template, colors)
    text = text .. "\n" .. dims
  end

  return helpers.split_newlines(text)
end

return transform