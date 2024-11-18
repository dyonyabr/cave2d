function generate_world()
  for x = 0, world_s - 1 do
    for y = 0, world_s - 1 do
      local side_k = (math.abs(world_s / 2 - x) / (world_s / 2 - 1)) ^ 2 +
          (math.abs(world_s / 2 - y) / (world_s / 2 - 1)) ^ 2
      local b = 0
      local is_bg = false
      local nv_bg = love.math.noise(x * bg_frq, y * bg_frq, 4096 - seed) ^ 2 + side_k ^ 5
      local nv = love.math.noise(x * frq, y * frq, seed)
      if nv_bg <= .25 then
        is_bg = true
      end

      if side_k ^ love.math.random(2, 5) < .5 then
        if nv > .66 then
          b = 1
        elseif nv > .33 then
          b = 2
        else
          b = 3
        end
      else
        b = 4
      end
      set_bdata(x, y, b, is_bg)
    end
  end
end
