CREATE OR REPLACE FUNCTION populate_tz1()
RETURNS void AS 
$func$
BEGIN 
	INSERT INTO xnycfare_den1 (SELECT 
		tmp.*,
		t1.zone as izone,
		t2.zone as ozone
		FROM 
		(SELECT id,
			fare,
			ilong,
			ilat,
			olong,
			olat,
			st_transform(st_setSRID(st_point(ilong, ilat), 4326), 2263) AS igeom,
			st_transform(st_setSRID(st_point(olong, olat), 4326), 2263) AS ogeom,
			pcount,
			date
		  FROM xnycfare
		  WHERE 
			0*13855870 <= id  AND
			id < (1)*13855870 AND
			ilat > 30 AND ilat < 50 AND
			ilong > - 80 AND ilong < -65 AND
			olat > 30 AND olat < 50 AND
			olong > - 80 AND olong < -65 
		) as tmp,
		taxi_zones as t1,
		taxi_zones as t2
		WHERE 	
			st_within(igeom, t1.geom)
			AND
			st_within(ogeom, t2.geom));
 END;                     
 $func$ LANGUAGE plpgsql; 
                          
CREATE OR REPLACE FUNCTION populate_tz2()
RETURNS void AS 
$func$
BEGIN 
	INSERT INTO xnycfare_den2 (SELECT 
		tmp.*,
		t1.zone as izone,
		t2.zone as ozone
		FROM 
		(SELECT id,
			fare,
			ilong,
			ilat,
			olong,
			olat,
			st_transform(st_setSRID(st_point(ilong, ilat), 4326), 2263) AS igeom,
			st_transform(st_setSRID(st_point(olong, olat), 4326), 2263) AS ogeom,
			pcount,
			date
		  FROM xnycfare
		  WHERE 
			1*13855870 <= id  AND
			id < (2)*13855870 AND
			ilat > 30 AND ilat < 50 AND
			ilong > - 80 AND ilong < -65 AND
			olat > 30 AND olat < 50 AND
			olong > - 80 AND olong < -65 
		) as tmp,
		taxi_zones as t1,
		taxi_zones as t2
		WHERE 	
			st_within(igeom, t1.geom)
			AND
			st_within(ogeom, t2.geom));
 END;                     
 $func$ LANGUAGE plpgsql; 
                          
CREATE OR REPLACE FUNCTION populate_tz3()
RETURNS void AS 
$func$
BEGIN 
	INSERT INTO xnycfare_den3 (SELECT 
		tmp.*,
		t1.zone as izone,
		t2.zone as ozone
		FROM 
		(SELECT id,
			fare,
			ilong,
			ilat,
			olong,
			olat,
			st_transform(st_setSRID(st_point(ilong, ilat), 4326), 2263) AS igeom,
			st_transform(st_setSRID(st_point(olong, olat), 4326), 2263) AS ogeom,
			pcount,
			date
		  FROM xnycfare
		  WHERE 
			2*13855870 <= id  AND
			id < (3)*13855870 AND
			ilat > 30 AND ilat < 50 AND
			ilong > - 80 AND ilong < -65 AND
			olat > 30 AND olat < 50 AND
			olong > - 80 AND olong < -65 
		) as tmp,
		taxi_zones as t1,
		taxi_zones as t2
		WHERE 	
			st_within(igeom, t1.geom)
			AND
			st_within(ogeom, t2.geom));
 END;                     
 $func$ LANGUAGE plpgsql; 
                          
CREATE OR REPLACE FUNCTION populate_tz4()
RETURNS void AS 
$func$
BEGIN 
	INSERT INTO xnycfare_den4 (SELECT 
		tmp.*,
		t1.zone as izone,
		t2.zone as ozone
		FROM 
		(SELECT id,
			fare,
			ilong,
			ilat,
			olong,
			olat,
			st_transform(st_setSRID(st_point(ilong, ilat), 4326), 2263) AS igeom,
			st_transform(st_setSRID(st_point(olong, olat), 4326), 2263) AS ogeom,
			pcount,
			date
		  FROM xnycfare
		  WHERE 
			3*13855870 <= id  AND
			id < (4)*13855870 AND
			ilat > 30 AND ilat < 50 AND
			ilong > - 80 AND ilong < -65 AND
			olat > 30 AND olat < 50 AND
			olong > - 80 AND olong < -65 
		) as tmp,
		taxi_zones as t1,
		taxi_zones as t2
		WHERE 	
			st_within(igeom, t1.geom)
			AND
			st_within(ogeom, t2.geom));
 END;                     
 $func$ LANGUAGE plpgsql; 
                          
