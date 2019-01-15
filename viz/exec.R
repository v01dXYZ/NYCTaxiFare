library(parallel)
library(digest)
library(stringi)

source('config.R')
source('spatial_analysis.R')

tasks <- list(
cartography = 	plot_cartography,
radius = 	plot_radius,
avg_week =  plot_avg_week,
pcount = plot_pcount) 

compl <- function(f, x) {
				print(x %s+% " en cours de creation")
				dir.create('img', showWarnings=F)
				setwd("./img")
				f(x)
			}
	
mcmapply(compl, tasks, names(tasks), mc.preschedule=TRUE, mc.cores=5)
