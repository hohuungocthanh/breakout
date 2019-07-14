pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 -- state -> "welcome", "game", "end"
 state = "welcome"
 
 resetGame()
 
 brick_dimensions = {
  width = 10,
  height = 5
 }

 points = {
  [9] = 1,
  [8] = 5,
  [14] = 10
 }
end



function resetGame()
 score = 0
 lives = 3
 
 -- ball state => "spawn", "game"
 ball = {
  x = 65, 
  y = 117, 
  dx = 3,
  dy = 3,
  radius = 2,
  state = "spawn"
 }
 
 ball.speed = getMagnitude(ball.dx, ball.dy)
 
 paddle = {
  x0 = 50,
  x1 = 80,
  y0 = 120,
  y1 = 123
 }
 
 bricks = {}
end 

function _update()
 if (state == "welcome") welcome()
 if (state == "game") game()
 if (state == "end") endGame()
end


function _draw()
 if (state == "welcome") drawWelcome()
 if (state == "game") drawGame()
 if (state == "end") drawEndGame()
end


function drawWelcome()
 cls(0)
 print("Welcome")
 print("Press z to start", 0, 80, 7)
 print("Then press x to shoot ball", 0, 90, 7) 
end


function drawGame() 
	cls(0)

 -- drawing a ball
 circfill(flr(ball.x), flr(ball.y), ball.radius, 6)

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


function drawEndGame()
 cls(0)
 print("You died", 0, 30, 7)
 print("Your score is:"..tostr(score), 0, 50, 7)
 print("Press z to restart", 0, 80, 7)
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


function welcome()
 if (btn(4)) state = "game"
end


function game() 
 -- ball state changed when pressed x or z button
 if (btn(5)) ball.state = "game"
 
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
  paddle.x = (paddle.x0 + paddle.x1)/2
  paddle.y = (paddle.y1 + paddle.y0)/2
  
  ball.dx = abs(ball.x - paddle.x)
  ball.dy = abs(ball.y - paddle.y)
  
  local newSpeed = getMagnitude(ball.dx, ball.dy)
  local speedRatio = ball.speed / newSpeed
  
  ball.dy *= speedRatio * -1
  ball.dx *= speedRatio
  
  if (ball.x < paddle.x) then
   ball.dx *= -1 
  end 
 end

 -- hitting the brick
 for brick in all(bricks) do
  if intersect(ball, brick) then
   ball.dy = abs(ball.dy)
   if (ball.y < brick.y) ball.dy *= -1 
   del(bricks, brick)
   score += points[brick.color]  
  end
 end

 -- respawning bricks when all are gone
 if #bricks == 0 then
  createBricks()
 end

 -- respawning ball when losing a life
 if ball.y + ball.radius >= 128 then
 
 	if lives > 0 then
   ball.x = (paddle.x1 + paddle.x0) / 2
   ball.y = paddle.y0 - ball.radius
   ball.state = "spawn"
   
   lives -= 1
  
  -- no more lives
  else 
	 state = "end"
  end
 end
end


function endGame()
 if btn(4) then
  state = "game"
  resetGame()
 end
end

function intersect(circle, rect)
 rect.x = (rect.x1 + rect.x0)/2
 rect.y = (rect.y1 +rect.y0)/2
 rect.width = rect.x1 - rect.x0
 rect.height =rect.y1 -rect.y0

 local circleDistance = {}
 circleDistance.x = abs(circle.x - rect.x)
 circleDistance.y = abs(circle.y - rect.y)
 
 if (circleDistance.x > (rect.width/2 + circle.radius)) return false
 if (circleDistance.y > (rect.height/2 + circle.radius)) return false

 if (circleDistance.x <= (rect.width/2)) return true 
 if (circleDistance.y <= (rect.height/2)) return true

 local cornerDistance_sq = (circleDistance.x - rect.width/2)^2 + (circleDistance.y - rect.height/2)^2

 return (cornerDistance_sq <= (circle.radius^2))
end

function abs(a)
 if (a < 0) a *= -1
 return a
end

function getMagnitude(x, y)
 return (x^2 + y^2)^(1/2)
end    
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
