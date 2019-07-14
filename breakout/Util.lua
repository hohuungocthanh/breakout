function intersect(circle, rect)
 rect.x = (rect.x1 + rect.x0)/2
 rect.y = (rect.y1 +rect.y0)/2
 rect.width = rect.x1 - rect.x0
 rect.height =rect.y1 -rect.y0

 local circle_distance = {}
 circle_distance.x = abs(circle.x - rect.x)
 circle_distance.y = abs(circle.y - rect.y)
 
 if (circle_distance.x > (rect.width/2 + circle.radius)) return false
 if (circle_distance.y > (rect.height/2 + circle.radius)) return false

 if (circle_distance.x <= (rect.width/2)) return true 
 if (circle_distance.y <= (rect.height/2)) return true

 local corner_distance_sq = (circle_distance.x - rect.width/2)^2 + (circle_distance.y - rect.height/2)^2

 return (corner_distance_sq <= (circle.radius^2))
end

function abs(a)
 if (a < 0) a *= -1
 return a
end

function get_magnitude(x, y)
 return (x^2 + y^2)^(1/2)
end    