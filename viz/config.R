## Library loadings
library(tidyverse)
library(DBI)
library(sf)
library(cartography)
library(rgeos)
library(mapinsetr)

## Connect to DBs
ch <- dbConnect(RClickhouse::clickhouse(), host="localhost", dbname="nyctf")
pg <- dbConnect(RPostgres::Postgres(), dbname="nyctf")

## Load polygon data
tz <- st_read(pg, layer="taxi_zones")
nb <- st_read(pg, layer="nyc_boroughs")
ss <- st_read(pg, layer="state_shrl")
