
-- picking random brick color
function randomBrickColor()
    local colors = {}
    for color, _ in pairs(points) do
     add(colors, color)
    end
    return colors[flr(rnd(#colors)) + 1]
   end
   
   
   -- creating many bricks
   function createBricks()
    for x = 10, 118, 15 do
     for y = 30, 70, 10 do
      local brick = createBricks(x, y)
      brick.color = randomBrickColor()
      add(bricks, brick) 
     end
    end
   end
   
   
   function createBrick (x, y)
    return {
     x0 = x - (brick_dimensions.width / 2),
     x1 = x + (brick_dimensions.width / 2),
     y0 = y - (brick_dimensions.height / 2),
     y1 = y + (brick_dimensions.height / 2),
     x = x,
     y = y
    }
   end   