-- Facade
-- ---------------------------------------------------------------------

local mimetypes = require("mimetypes")
local yaml = require("yaml")

-- ---------------------------------------------------------------------

local function mime(name)
  local guess = mimetypes.guess(name)

  local array = {}

  for word in guess:gmatch("%a+") do
    table.insert(array, word)
  end

  return array[1], array[2]
end

local function prepend_ext(filename, string)
  return filename:gsub("(%.%w*)$", string .. "%1")
end

-- ---------------------------------------------------------------------

local config_fh = io.open("source/config.yml")
local config

if config_fh then
  config = yaml.eval(config_fh:read("*a"))

  config_fh:close()
end

local command = arg[1]
local input = arg[2]
local output = arg[3] or prepend_ext(input, "-" .. command)

if config and command and input then
  local _, subtype = mime(input)

  local match = config[command][subtype]

  match = match:gsub("\n", " ")
  match = match:gsub("%%<input>s", input)
  match = match:gsub("%%<output>s", output)

  os.execute(match)
end
