-- libs
Signal = require 'lib.hump.signal'
Timer = require "lib.hump.timer"
Gamestate = require "lib.hump.Gamestate"
HC = require "lib.HC"
require "lib.gradient"

require "Entities"
require "EntityCreator"
require "gamestate.Game"
require "gamestate.Menu"

function love.load()
  io.stdout:setvbuf("no")

  shader = love.graphics.newShader("shader.fs")
  canvas = love.graphics.newCanvas()
  love.graphics.setBackgroundColor(0, 0, 0)

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function love.update(dt)
  Timer.update(dt)
end