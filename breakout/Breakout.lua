function _init()
 -- state => "spawn", "game"
 ball = {
  x = 65, 
  y = 117, 
  dx = 3,
  dy = 3,
  radius = 3,
  state = "spawn"
 }
 
 paddle = {
  x0 = 50,
  x1 = 80,
  y0 = 120,
  y1 = 123
 }
 
 brick_dimensions = {
  width = 10,
  height = 5
 }

 bricks = {}
 score = 0
 lives = 3

 points = {
  [9] = 1,
  [8] = 5,
  [14] = 10
 }
end


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
  for y = 30, 50, 10 do
   local brick = createBrick(x, y)
   brick.color = randomBrickColor()
   add(bricks, brick) 
  end
 end
end


-- creating one brick
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
 -- ball state changed when pressed x or z button
 if (btn(4) or btn(5)) ball.state = "game"
 
 -- only allow the ball to bounce around if the state is in "game"
 if ball.state == "game" then
   -- changing direction of ball when hitting the wall
  if (ball.x - ball.radius <= 0 or ball.x + ball.radius >= 128) ball.dx *= -1
  if (ball.y - ball.radius <= 0) ball.dy *= -1

  -- moving the ball
  ball.x += ball.dx
  ball.y += ball.dy
 end
 
 -- moving the paddle
 -- move paddle left
 if btn(0) and paddle.x0 >= 0 then
  paddle.x0 -= 5 
  paddle.x1 -= 5
  
  -- move ball with paddle if the ball state is "spawn"
  if (ball.state == "spawn") ball.x -= 5
 end
 
 -- move paddle right
 if btn(1) and paddle.x1 <= 128 then
  paddle.x0 += 5
  paddle.x1 += 5
  
  -- move ball with paddle if the ball state is "spawn"
 	if (ball.state == "spawn") ball.x += 5
 end
 
 -- hitting the paddle
 if intersect(ball, paddle) then
  ball.dy = -3
  paddle.x = (paddle.x0 + paddle.x1)/2
  if (ball.x < paddle.x) then
   ball.dx = -3
  else
   ball.dx = 3
  end 
 end

 -- hitting the brick
 for brick in all(bricks) do
  if intersect(ball, brick) then
   if (ball.y < brick.y) then
    ball.dy = -3
   else
    ball.dy = 3
   end
   del(bricks, brick)
   score += points[brick.color]  
  end
 end

 -- respawning bricks when all are gone
 if #bricks == 0 then
  createBricks()
 end

 -- respawning ball when losing a life
 if ball.y + ball.radius >= 128 and lives > 0 then
   ball.x = (paddle.x1 + paddle.x0) / 2
   ball.y = paddle.y0 - ball.radius
   ball.state = "spawn"
   
   lives -= 1
 end

 -- if lives == 0 and ball.y + ball.radius >= 128 then 
 --  print('No more life!', 10, 10, 7)
 -- end .
end


function _draw()
 cls(0)

 -- drawing a ball
 circfill(ball.x, ball.y, ball.radius, 6)

 -- drawing a paddle
 rectfill(paddle.x0, paddle.y0, paddle.x1, paddle.y1, 13)

 -- drawing bricks
 for brick in all(bricks) do
  rectfill(brick.x0, brick.y0, brick.x1, brick.y1, brick.color)   
 end

 -- score
 print(score, 1, 1, 7)

 -- lives
 print ('lives:'..tostr(lives), 80, 1, 7)
end