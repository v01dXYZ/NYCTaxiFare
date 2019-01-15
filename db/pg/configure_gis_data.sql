CREATE INDEX taxi_zone_geom_gis ON taxi_zones USING GIST(geom);
