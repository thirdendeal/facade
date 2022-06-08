-- Facade
-- ---------------------------------------------------------------------
--
-- Usage: lua source/facade.lua <input> [directory]

local mimetypes = require("mimetypes")
local path = require("path")
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
  local root, extension = path.splitext(filename)

  return root .. string .. extension
end

local function build_input(input)
  if path.isdir(input) then
    return path.each(input)
  else
    return path.each(
      input,
      {
        delay = true,
        recurse = true,
        reverse = true,
        skipdirs = true
      }
    )
  end
end

local function build_output(input, directory, command)
  local output = path.join(directory, path.basename(input))

  if path.exists(output) then
    output = prepend_ext(output, "-" .. command)
  end

  local root, extension = path.splitext(output)
  local index = 1

  while path.exists(output) do
    output = root .. "-" .. index .. extension

    index = index + 1
  end

  return path.fullpath(output)
end

-- ---------------------------------------------------------------------

local config_fh = io.open("source/config.yml")
local config

if config_fh then
  config = yaml.eval(config_fh:read("*a"))

  config_fh:close()
end

local command = arg[1]
local input = build_input(arg[2])
local directory = arg[3] or path.dirname(arg[2])

directory = path.normalize(directory)

if config and command then
  for file in input do
    local _, subtype = mime(file)
    local match = config[command][subtype]

    local file_output = build_output(file, directory, command)

    match = match:gsub("\n", " ")
    match = match:gsub("%%<input>s", file)
    match = match:gsub("%%<output>s", file_output)

    os.execute(match)
  end
end
