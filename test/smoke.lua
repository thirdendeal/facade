-- Smoke Test
-- ---------------------------------------------------------------------

local path = require("path")

-- ---------------------------------------------------------------------

local input = "./test/data/input/"
local output = "./test/data/output/"

path.each(
  output,
  function(file)
    path.remove(file)
  end,
  {
    recurse = true,
    reverse = true
  }
)

local arguments = 'optimize "' .. input .. '" "' .. output .. '"'

for _ = 1, 4 do
  os.execute("lua ./source/facade.lua " .. arguments)
end
