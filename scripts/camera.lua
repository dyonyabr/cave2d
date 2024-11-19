camera = {
  target = vec(0, 0),
  pos = vec(0, 0)
}

local speed = 35

function camera:fast_center()
  camera.target = vec(player.pos.x, player.pos.y)
  camera.pos = camera.target - vec(game_x, game_y) / 2
end

function camera:update(dt)
  camera.target = vec(player.pos.x, player.pos.y)
  camera.pos = camera.pos:lerp(camera.target - vec(game_x, game_y) / 2, dt * 5)
end
