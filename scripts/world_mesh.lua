local cell = {
  { { 0, 0 }, { 8, 0 }, { 8, 8 }, { 1, 2, 3 } },
  { { 0, 0 }, { 8, 8 }, { 0, 8 }, { 1, 3, 4 } },
  { { 8, 0 }, { 8, 8 }, { 0, 8 }, { 2, 3, 4 } },
  { { 8, 0 }, { 0, 8 }, { 0, 0 }, { 2, 4, 1 } },
}

local atlas = love.graphics.newImage("assets/textures/atlas.png")

function make_mesh(cx, cy)
  local verts = {}
  local start_x = cx * chunk_s
  local start_y = cy * chunk_s
  for x = start_x, start_x + chunk_s - 1 do
    for y = start_y, start_y + chunk_s - 1 do
      local index = pos2i(x, y, world_s)
      local bdata = world.map[index]
      local b = bdata[1]
      local block = blocks[b]
      local uv = block.uv
      local prop = block.prop
      local is_bg = bdata[2]
      local light = (bdata[3]) / max_light
      if b ~= 0 then
        uvx, uvy = (uv) % 16, math.floor((uv) / 16)
        for t = 1, 2 do
          local ao = get_ao(x, y, not is_bg)
          local iof = 0
          if ao[3] ~= 0 or ao[1] ~= 0 then iof = 2 end
          local gx, gy = x * 8, y * 8
          for v = 1, 3 do
            local i = cell[t + iof][4][v]
            local col = 1
            if not table_has(prop, "light") then
              col = get_tile_colors(x, y, ao[i], is_bg, t == 2)
              local n1, n2, n3 = 0, 0, 0
              if i == 1 then
                local nb1, nb2, nb3 = get_bdata(x - 1, y), get_bdata(x, y - 1), get_bdata(x - 1, y - 1)
                if nb1 then n1 = nb1[3] end
                if nb2 then n2 = nb2[3] end
                if nb3 then n3 = nb3[3] end
              elseif i == 2 then
                local nb1, nb2, nb3 = get_bdata(x + 1, y), get_bdata(x, y - 1), get_bdata(x + 1, y - 1)
                if nb1 then n1 = nb1[3] end
                if nb2 then n2 = nb2[3] end
                if nb3 then n3 = nb3[3] end
              elseif i == 3 then
                local nb1, nb2, nb3 = get_bdata(x + 1, y), get_bdata(x, y + 1), get_bdata(x + 1, y + 1)
                if nb1 then n1 = nb1[3] end
                if nb2 then n2 = nb2[3] end
                if nb3 then n3 = nb3[3] end
              elseif i == 4 then
                local nb1, nb2, nb3 = get_bdata(x - 1, y), get_bdata(x, y + 1), get_bdata(x - 1, y + 1)
                if nb1 then n1 = nb1[3] end
                if nb2 then n2 = nb2[3] end
                if nb3 then n3 = nb3[3] end
              end
              n1, n2, n3 = n1 / max_light, n2 / max_light, n3 / max_light
              col_m = (n1 + n2 + n3 + light) / 4
              col = col * col_m
            end
            verts[#verts + 1] = {
              cell[t + iof][v][1] + gx, cell[t + iof][v][2] + gy,
              (uvx + cell[t + iof][v][1] / 8) / 16, (uvy + cell[t + iof][v][2] / 8) / 16,
              col, col, col, 1
            }
          end
        end
      end
    end
  end
  local mesh = love.graphics.newMesh(verts, "triangles", "dynamic")
  mesh:setTexture(atlas)
  return mesh
end

function get_tile_colors(x, y, ao, is_bg, shade)
  local col
  if is_bg then
    col = .5 - .5 * ao * ao_dencity
  else
    col = ao * ao_dencity * 4
  end
  return col
end

function is_ao(x, y, not_bg)
  if x < 0 or x >= world_s or y < 0 or y >= world_s then return 0 end
  return ((get_bdata(x, y)[1] ~= 0 and get_bdata(x, y)[2] == not_bg) and 1 or 0)
end

function get_ao(x, y, not_bg)
  local a = is_ao(x - 1, y, not_bg) + is_ao(x - 1, y - 1, not_bg) + is_ao(x, y - 1, not_bg)
  local b = is_ao(x, y - 1, not_bg) + is_ao(x + 1, y - 1, not_bg) + is_ao(x + 1, y, not_bg)
  local c = is_ao(x - 1, y, not_bg) + is_ao(x - 1, y + 1, not_bg) + is_ao(x, y + 1, not_bg)
  local d = is_ao(x, y + 1, not_bg) + is_ao(x + 1, y + 1, not_bg) + is_ao(x + 1, y, not_bg)
  return { a, b, d, c }
end
