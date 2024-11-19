local function check_wall(x, y, dir)
  local nx, ny = x + dir[1], y + dir[2]
  local nbdata = get_bdata(nx, ny)
  if nbdata then return nbdata[2] else return false end
end

function calc_light(px, py, max)
  local queue = { { x = px, y = py, light = max } }

  while #queue > 0 do
    local current = table.remove(queue, 1)
    local x, y, light = current.x, current.y, current.light

    local bdata = get_bdata(x, y)
    if bdata then
      if (light <= 0 or bdata[3] >= light) then
        goto continue
      end
      bdata[3] = light
      local n = { get_bdata(x - 1, y), get_bdata(x, y - 1), get_bdata(x, y + 1), get_bdata(x + 1, y),
        get_bdata(x - 1, y - 1), get_bdata(x + 1, y + 1), get_bdata(x + 1, y - 1), get_bdata(x - 1, y + 1) }
      for i = 1, 8 do
        if n[i] then
          if not n[i][2] then
            if n[i][3] < light then
              n[i][3] = light
            end
          end
        end
      end
    end

    for _, dir in ipairs(dirs) do
      local nx, ny = x + dir[1], y + dir[2]
      if check_wall(x, y, dir) then
        table.insert(queue, { x = nx, y = ny, light = light - 1 })
      end
    end

    ::continue::
  end
end

function calc_all_light()
  local cx, cy = player.chunk_pos.x, player.chunk_pos.y

  local sources = {}
  local start_x = (cx - 2) * chunk_s
  local start_y = (cy - 2) * chunk_s
  local end_x = start_x + 5 * chunk_s - 1
  local end_y = start_y + 5 * chunk_s - 1
  for x = start_x, end_x do
    for y = start_y, end_y do
      local bdata = get_bdata(x, y)
      if bdata then
        local b = bdata[1]
        local block = blocks[b]
        local prop = block.prop
        if table_has(prop, "light") then sources[#sources + 1] = { x = x, y = y, light_level = prop.light_level } end
        bdata[3] = 0
      end
    end
  end

  calc_light(player.map_pos.x, player.map_pos.y, 4)
  for i = 1, #sources do
    calc_light(sources[i].x, sources[i].y, sources[i].light_level)
  end
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
