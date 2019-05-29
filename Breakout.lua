function _init()
 ball = {
  x = 90, 
  y = 64, 
  dx = 1,
  dy = 1,
  radius = 5
 }
 
 paddle = {
  x0 = 60,
  y0 = 120,
  x1 = 80,
  y1 = 125
 }
 
 brick_dimensions = {
  width = 10,
  height = 5
 }

 bricks = {}

 for x = 10, 118, 15 do
  for y = 50, 90, 10 do
   add(bricks, createBrick(x, y)) 
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


function _update()
	-- changing direction of ball when hitting the wall
 if (ball.x - ball.radius == 0 or ball.x + ball.radius == 128) ball.dx *= -1
 if (ball.y - ball.radius == 0 or ball.y + ball.radius == 128) ball.dy *= -1
	
 -- moving the ball
 ball.x += ball.dx
 ball.y += ball.dy
 
 -- moving the paddle
 if btn(0) and paddle.x0 != 0 then
  paddle.x0 -= 1 
  paddle.x1 -= 1
 end
 if btn(1) and paddle.x1 != 128 then
  paddle.x0 += 1
  paddle.x1 += 1
 end

 -- hitting the paddle
 if intersect(ball, paddle) then
  ball.dy = -1
  paddle.x = (paddle.x0 + paddle.x1)/2
  if (ball.x < paddle.x) then
   ball.dx = -1
  else
   ball.dx = 1
  end 
 end

 -- hitting the brick
 for brick in all(bricks) do
  if intersect(ball, brick) then
    if (ball.y < brick.y) then
      ball.dy = -1
    else
      ball.dy = 1
    end
    del(bricks, brick)
  end
 end
end



function _draw()
 cls(15)

 -- drawing a ball
 circfill(ball.x, ball.y, ball.radius, 1)

 -- drawing a paddle
 rectfill(paddle.x0, paddle.y0, paddle.x1, paddle.y1, 13)

 -- drawing bricks
 for brick in all(bricks) do
  rectfill(brick.x0, brick.y0, brick.x1, brick.y1, 4) 
 end
end