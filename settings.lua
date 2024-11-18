scale = love.graphics.getHeight() / 128
game_x, game_y = love.graphics.getWidth() / scale, love.graphics.getHeight() / scale

chunk_count = 16
chunk_s = 16
world_s = chunk_count * chunk_s
max_light = 8

ao_dencity = .3

seed = love.math.random(0, 4096)
frq = .2
bg_frq = .2

dirs = { { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, 0 } }
dio_dirs = { { -1, -1 }, { 1, -1 }, { 1, 1 }, { 1, -1 } }

love.graphics.setDefaultFilter("nearest", "nearest")

function on_resize()
  scale = love.graphics.getHeight() / 128
  game_x, game_y = love.graphics.getWidth() / scale, love.graphics.getHeight() / scale
end
