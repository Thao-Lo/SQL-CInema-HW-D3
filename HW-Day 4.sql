#1 
SELECT 	
	p.id, 
    p.title,
	COALESCE(SUM(r.number_of_ticket),0) AS reserved_tickets	
FROM reservation r
RIGHT JOIN play p ON p.id = r.play_id
GROUP BY p.id	
ORDER BY reserved_tickets desc, p.id asc;

#2 transfer
SELECT
	name,
	SUM(IF(money > 0, money, 0)) AS sum_of_deposits,
	ABS(SUM(IF(money < 0, money, 0))) AS sum_of_withdrawals
FROM transfer 
GROUP BY name
ORDER BY name asc;

#3 - buses
WITH same_route AS (
	  SELECT b.id as busId,
			b.time as bus_depart,          
			p.id as passengerId, 
              p.time as passenger_arrive,
              LAG(time) OVER(partition by b.orgin, b.destination ORDER BY time) AS bus_time_ahead
            FROM bus b 
	LEFT JOIN passenger p ON b.origin = p.origin and b.destination = p.destination and b.time >= p.time
    ORDER BY b.id asc
    )
    SELECT busID,
			COUNT(passengerId) AS passengers_on_board
    FROM same_route s    
    GROUP BY busId    
    ;
    
    SELECT b.id as busId,
			b.time as bus_depart,          
			p.id as passengerId, 
              p.time as passenger_arrive            
            FROM bus b 
	LEFT JOIN passenger p ON b.origin = p.origin and b.destination = p.destination;