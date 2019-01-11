CREATE TABLE nycfare(
	       id bigserial NOT NULL,
	       fare numeric(10, 2) NOT NULL,
	       date timestamp NOT NULL,
	       ilong double precision NOT NULL,
	       ilat double precision NOT NULL,
	       olong double precision NOT NULL,
	       olat double precision NOT NULL,
	       pcount integer NOT NULL
);

CREATE FOREIGN TABLE xnycfare(
	       id bigserial NOT NULL,
	       fare numeric(10, 2) NOT NULL,
	       date timestamp NOT NULL,
	       ilong double precision NOT NULL,
	       ilat double precision NOT NULL,
	       olong double precision NOT NULL,
	       olat double precision NOT NULL,
	       pcount integer NOT NULL
) SERVER cstore_server
OPTIONS(compression 'pglz',
	block_row_count '40000',
	stripe_row_count '600000');

CREATE TABLE xnycfare_den
(
	id bigint NOT NULL,
	fare numeric(10, 2) NOT NULL,
	ilong double precision NOT NULL,
	ilat double precision NOT NULL,
	olong double precision NOT NULL,
	olat double precision NOT NULL,
	igeom geometry NOT NULL,
	ogeom geometry NOT NULL,
	pcount integer NOT NULL,
	date timestamp NOT NULL,
--	year integer NOT NULL,
--	week integer NOT NULL,
--	day integer NOT NULL,
--	hour integer NOT NULL,
	izone varchar(254) NOT NULL,
	ozone varchar(254) NOT NULL)
PARTITION BY RANGE (id);
-- SERVER cstore_server
-- OPTIONS(compression 'pglz',
-- 	block_row_count '40000',
-- 	stripe_row_count '600000');

 CREATE FOREIGN TABLE xnycfare_den1 PARTITION OF xnycfare_den FOR VALUES FROM (0) TO (13855870)
 SERVER cstore_server
 OPTIONS(compression 'pglz',
 	block_row_count '40000',
 	stripe_row_count '600000');

 CREATE FOREIGN TABLE xnycfare_den2 PARTITION OF xnycfare_den FOR VALUES FROM (13855870) TO (27711740)
 SERVER cstore_server
 OPTIONS(compression 'pglz',
 	block_row_count '40000',
 	stripe_row_count '600000');

 CREATE FOREIGN TABLE xnycfare_den3 PARTITION OF xnycfare_den FOR VALUES FROM (27711740) TO (41567610)
 SERVER cstore_server
 OPTIONS(compression 'pglz',
 	block_row_count '40000',
 	stripe_row_count '600000');

 CREATE FOREIGN TABLE xnycfare_den4 PARTITION OF xnycfare_den FOR VALUES FROM (41567610) TO (55423480)
 SERVER cstore_server
 OPTIONS(compression 'pglz',
 	block_row_count '40000',
 	stripe_row_count '600000');

