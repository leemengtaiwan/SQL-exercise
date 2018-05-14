

SELECT V.label, SUM(O."admin.sold_price") AS "Sales"
FROM marketenterprise.outlets AS O
  JOIN marketenterprise.outlet_venders AS V
  ON O."admin.outlet_vender_id" = V.oid__id
WHERE O."admin.outlet_status" = 'sold'
  AND O."admin.sold_price" IS NOT NULL
GROUP BY 1
ORDER BY "Sales" DESC
LIMIT 5;




SELECT *
FROM marketenterprise.outlet_venders
WHERE oid__id = '54579a31dcf0561a3e7b0214'


SELECT
