function intersect(circle, rect)
 rect.x = (x1 + x0)/2
 rect.y = (y1 + y0)/2
 rect.width = x1 - x0
 rect.height = y1 - y0

 local circleDistance = {}
 circleDistance.x = math.abs(circle.x - rect.x)
 circleDistance.y = math.abs(circle.y - rect.y)

 
 if (circleDistance.x > (rect.width/2 + circle.radius)) return false
 if (circleDistance.y > (rect.height/2 + circle.radius)) return false

 if (circleDistance.x <= (rect.width/2)) return true 
 if (circleDistance.y <= (rect.height/2)) return true

 local cornerDistance_sq = (circleDistance.x - rect.width/2)^2 + (circleDistance.y - rect.height/2)^2;

 return (cornerDistance_sq <= (circle.radius^2)) 