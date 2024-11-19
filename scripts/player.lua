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
    local cx, cy = player.chunk_pos.x, player.chunk_pos.y

    local start_x = (cx - 1) * chunk_s
    local start_y = (cy - 1) * chunk_s
    for x = start_x, start_x + chunk_s * 3 - 1 do
      for y = start_y, start_y + chunk_s * 3 - 1 do
        local bdata = get_bdata(x, y)
        if bdata then bdata[3] = 0 end
      end
    end

    calc_light(x, y)
    local c, l, r, d, u, lu, ru, rd, ld =
        get_mesh(cx, cy),
        get_mesh(cx - 1, cy),
        get_mesh(cx + 1, cy),
        get_mesh(cx, cy + 1),
        get_mesh(cx, cy - 1),
        get_mesh(cx - 1, cy - 1),
        get_mesh(cx + 1, cy - 1),
        get_mesh(cx + 1, cy + 1),
        get_mesh(cx - 1, cy + 1)
    if c then set_mesh(cx, cy, make_mesh(cx, cy)) end
    if l then set_mesh(cx - 1, cy, make_mesh(cx - 1, cy)) end
    if r then set_mesh(cx + 1, cy, make_mesh(cx + 1, cy)) end
    if d then set_mesh(cx, cy + 1, make_mesh(cx, cy + 1)) end
    if u then set_mesh(cx, cy - 1, make_mesh(cx, cy - 1)) end
    if lu then set_mesh(cx - 1, cy - 1, make_mesh(cx - 1, cy - 1)) end
    if ru then set_mesh(cx + 1, cy - 1, make_mesh(cx + 1, cy - 1)) end
    if rd then set_mesh(cx + 1, cy + 1, make_mesh(cx + 1, cy + 1)) end
    if ld then set_mesh(cx - 1, cy + 1, make_mesh(cx - 1, cy + 1)) end
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
