player = {
  dir = vec(0, 0),
  velocity = vec(0, 0),
  pos = vec(0, 0),
  map_pos = vec(0, 0),
  chunk_pos = vec(0, 0),
  speed = 1,
}

function player:init_pos()
  player.pos = vec(world_s / 2 * 8, world_s / 2 * 8)
  player:set_chunk_pos(chunk_count / 2, chunk_count / 2)
  player:set_map_pos(world_s / 2, world_s / 2)
end

function player:set_map_pos(x, y)
  if player.map_pos.x ~= x or player.map_pos.y ~= y then
    player.map_pos = { x = x, y = y }
    cx, cy = player.chunk_pos.x, player.chunk_pos.y
    calc_all_light()
  end
end

function player:set_chunk_pos(x, y)
  if player.chunk_pos.x ~= x or player.chunk_pos.y ~= y then
    player.chunk_pos = { x = x, y = y }
  end
end

function define_pos()
  player:set_chunk_pos(math.floor(player.pos.x / (8 * chunk_s)), math.floor(player.pos.y / (8 * chunk_s)))
  player:set_map_pos(math.floor(player.pos.x / 8), math.floor(player.pos.y / 8))
end

function movement(dt)
  player.dir = vec(
    (love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0),
    (love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0)
  ):normalized()
  player.velocity = player.velocity:lerp(player.dir * player.speed, dt * 20)

  player.pos = player.pos + player.velocity
end

function player_update(dt)
  movement(dt)
  define_pos()
end

function player:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.circle("fill", player.pos.x, player.pos.y, 3)
end

function break_block()
  x, y = player.map_pos.x, player.map_pos.y
  local bdata = get_bdata(x, y)
  if not bdata[2] then
    set_bdata(x, y, 2, true, true)
  end
end

function set_block()
  x, y = player.map_pos.x, player.map_pos.y
  local bdata = get_bdata(x, y)
  if bdata[2] then
    set_bdata(x, y, 5, false, true)
  end
end

function player:input(k)
  if k == "return" then break_block() end
  if k == "rshift" then set_block() end
end
