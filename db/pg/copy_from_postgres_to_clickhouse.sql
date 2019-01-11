COPY (SELECT id, fare, ilong, ilat, olong, olat, pcount, date, izone, ozone  FROM xnycfare_den) 
TO PROGRAM 'clickhouse-client --query="INSERT INTO nycfare FORMAT CSV"'
WITH CSV;
