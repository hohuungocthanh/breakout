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