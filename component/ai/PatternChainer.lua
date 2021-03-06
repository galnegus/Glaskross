local Class = require "lib.hump.Class"

local PatternChainer = Class{}

function PatternChainer:init()
  self._patterns = {}
  self._i = 1
end

function PatternChainer:add(pattern)
  table.insert(self._patterns, pattern)
end

function PatternChainer:start()
  self._patterns[self._i]:start(function()
    self._i = self._i + 1
    if self._i <= #self._patterns then
      self:start()
    end
  end)
end

return PatternChainer
