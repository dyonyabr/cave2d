function lerp(a, b, t)
  return a + (b - a) * t
end

function lerp_angle(a, b, t)
  local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
  return a + diff * t
end

function posmod(a, b)
  return ((a % b) + b) % b
end

function clamp(val, lower, upper)
  assert(val and lower and upper, "not very useful error message here")
  if lower > upper then lower, upper = upper, lower end
  return math.max(lower, math.min(upper, val))
end

function table_has(tbl, element)
  for _, value in pairs(tbl) do
    if value == element then
      return true
    end
  end
  return false
end

function pos2i(x, y, size)
  return x + y * size
end

function i2pos(i, size)
  return i % size, math.floor(i / size)
end
