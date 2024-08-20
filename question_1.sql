-- How many staff are there in all of the UK stores?

SELECT SUM("staff numbers") AS "Staff in all UK Stores" FROM dim_stores WHERE country_code='GB';