uniform number scale;
uniform number center_x;
uniform number center_y;
uniform number radius;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  // vec4 pixel = Texel(texture, texture_coords );
  // return pixel * color;


  number dist = length(screen_coords / scale - vec2(center_x, center_y));
  vec4 pixel = vec4(0, 0, 0, pow(dist/radius, 1));

  return pixel;
}