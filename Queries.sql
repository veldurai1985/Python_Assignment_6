/* QUESTION: How can you isolate (or group) the transactions of each cardholder */ 

SELECT 
	cd.card_holder_id
	,count(t.transaction_id)
	,round(sum(cast(amount as integer)))

FROM credit_card as cd
LEFT JOIN transaction as t on cd.card_number = t.card_number

group by cd.card_holder_id
order by cd.card_holder_id

/* QUESTON: Consider the time period 7:00 a.m. to 9:00 a.m.
		What are the top 100 highest transactions during this time period?
		Do you see any fraudulent or anomalous transactions?
		If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame. */

select distinct 
t.*
, m.merchant_category_id
, mc.category_name 

from transaction as t
left join  merchant as m on t.merchant_id = m.merchant_id
left join merchant_category as mc on m.merchant_category_id = mc.merchant_category_id

where CAST(t.transaction_date AS TIME) >= '07:00:00'
and CAST(t.transaction_date AS TIME) <= '09:00:00'

order by t.amount desc
limit 100

/* COMMENTS: Top 8 transactions seem to be fraudulent. Large amount being spent in the morning time in places such as bar, restaurant and bar. */



/* QUESTION: Some fraudsters hack a credit card by making several small payments (generally less than $2.00), which are typically ignored by cardholders. 
Count the transactions that are less than $2.00 per cardholder.  */

SELECT 
	cd.card_holder_id
	, count(transaction_id) 

FROM credit_card as cd
LEFT JOIN transaction as t on cd.card_number = t.card_number and t.amount < 2.00 

group by cd.card_holder_id
order by cd.card_holder_id

/* Is there any evidence to suggest that a credit card has been hacked? Explain your rationale. */ 

select distinct  
t.*
, m.merchant_category_id
, mc.category_name 

from transaction as t
join  merchant as m on t.merchant_id = m.merchant_id
join merchant_category as mc on 
	m.merchant_category_id = mc.merchant_category_id 

where t.amount < 2.00 

order by t.amount desc

/* Comments: Small trasnactions in place such as restaurant, bar and pub seems to fraudulent */

/* What are the top 5 merchants prone to being hacked using small transactions? */ 

select distinct m.merchant_id
, m.merchant_name
, mc.category_name
, count(transaction_id) as count_of_transaction

from transaction as t
join  merchant as m on t.merchant_id = m.merchant_id
join merchant_category as mc on  m.merchant_category_id = mc.merchant_category_id 

where t.amount < 2.00 

group by m.merchant_id
, m.merchant_name
, mc.category_name

order by count(transaction_id) desc 
limit 5 ; 