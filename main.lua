require "lib.tools"
vec = require "lib.vector"

require "settings"
require "scripts.world_data"
require "scripts.world_mesh"
require "scripts.generator"
require "scripts.player"
require "scripts.camera"
require "scripts.light"

function love.load()
  generate_world()
  for cx = 0, chunk_count - 1 do
    for cy = 0, chunk_count - 1 do
      set_mesh(cx, cy, make_mesh(cx, cy))
    end
  end
  player:init_pos()
  camera:fast_center()
end

function love.update(dt)
  camera:update(dt)
  player_update(dt)
end

function love.resize()
  on_resize()
end

function love.draw()
  love.graphics.scale(scale)
  love.graphics.translate(-camera.pos.x, -camera.pos.y)

  draw_world()
  player:draw()

  love.graphics.origin()
  love.graphics.print(love.timer.getFPS(), 10, 10)
end
