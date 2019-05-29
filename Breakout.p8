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
 if (intersect(ball, paddle)) ball.dy *= -1
end


function _draw()
	cls(15)
 circfill(ball.x, ball.y, ball.radius, 1)
 rectfill(paddle.x0, paddle.y0, paddle.x1, paddle.y1, 13)
end