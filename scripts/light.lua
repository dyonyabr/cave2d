local light_shader = love.graphics.newShader("assets/shaders/light.glsl")

local function check_wall(x, y, dir)
  local nx, ny = x + dir[1], y + dir[2]
  local nbdata = get_bdata(nx, ny)
  if nbdata then return nbdata[2] else return false end
end

function calc_light(px, py, cx, cy)
  local queue = { { x = px, y = py, light = max_light } }

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
