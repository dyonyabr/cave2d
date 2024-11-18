camera = {
  pos = { x = world_s / 2 * 8, y = world_s / 2 * 8 },
  draw_pos = {
    x = world_s / 2 * 8 - game_x / 2,
    y = world_s / 2 * 8 - game_y / 2
  },
  map_pos = { x = world_s / 2, y = world_s / 2 },
  chunk_pos = { x = chunk_count / 2, y = chunk_count / 2 },
}

local speed = 35

local function set_map_pos(x, y)
  if camera.map_pos.x ~= x or camera.map_pos.y ~= y then
    camera.map_pos = { x = x, y = y }
    local cx, cy = camera.chunk_pos.x, camera.chunk_pos.y

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

local function set_chunk_pos(x, y)
  if camera.chunk_pos.x ~= x or camera.chunk_pos.y ~= y then
    camera.chunk_pos = { x = x, y = y }
  end
end

function move_screen(k)
  local dir = {
    x = (k == "d" and 1 or 0) - (k == "a" and 1 or 0),
    y = (k == "s" and 1 or 0) - (k == "w" and 1 or 0),
  }

  camera.pos.x, camera.pos.y = camera.pos.x + dir.x * 128, camera.pos.y + dir.y * 128
end

function camera_update(dt)
  local dir = {
    x = (love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0),
    y = (love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0),
  }

  local dlen = (dir.x ^ 2 + dir.y ^ 2) ^ .5
  if dlen > 0 then
    dir.x, dir.y = dir.x / dlen, dir.y / dlen
  end

  camera.pos.x, camera.pos.y = camera.pos.x + dir.x * dt * speed, camera.pos.y + dir.y * dt * speed

  camera.draw_pos.x = lerp(camera.draw_pos.x, camera.pos.x - game_x / 2, dt * 20)
  camera.draw_pos.y = lerp(camera.draw_pos.y, camera.pos.y - game_y / 2, dt * 20)

  set_chunk_pos(math.floor(camera.pos.x / (8 * chunk_s)), math.floor(camera.pos.y / (8 * chunk_s)))
  set_map_pos(math.floor(camera.pos.x / 8), math.floor(camera.pos.y / 8))
end
