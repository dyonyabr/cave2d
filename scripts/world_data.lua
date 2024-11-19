local mesh_shader = love.graphics.newShader("assets/shaders/smooth_light.glsl")

world = { map = {}, meshes = {} }
function get_bdata(x, y)
  return world.map[pos2i(x, y, world_s)]
end

function set_bdata(x, y, b, is_bg, update)
  world.map[pos2i(x, y, world_s)] = { b, is_bg, 0 }
  if update then
    calc_all_light()
  end
end

function get_mesh(cx, cy)
  return world.meshes[pos2i(cx, cy, chunk_count)]
end

function set_mesh(cx, cy, mesh)
  world.meshes[pos2i(cx, cy, chunk_count)] = mesh
end

function draw_world()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setShader(mesh_shader)
  for cx = 0, chunk_count - 1 do
    for cy = 0, chunk_count - 1 do
      love.graphics.draw(get_mesh(cx, cy))
    end
  end
  love.graphics.setShader()
end
