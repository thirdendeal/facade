-- Smoke Test
-- ---------------------------------------------------------------------

local origin = "test/data/image.jpg"
local target = "test/data/image-optimize.jpg"

local fh = io.open(target)

if fh then
  fh:close()

  os.remove(target)
end

os.execute("lua source/facade.lua optimize " .. origin)
