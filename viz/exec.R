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

try(load('tasks.RData'), silent=TRUE)
if(!exists('tasks_md5')) { tasks_md5 <- list() }
	

compl <- function(f, x) {
			d <- digest(as.character(body(f)));
			if( d != tasks_md5[x]){
				print(x %s+% " en cours de creation")
				setwd("./build")
				f(x)
			} else {
				print(x %s+% " deja fait")
			}
			return(d)
			}
	
tasks_md5 <- list_modify(tasks_md5, !!! mcmapply(compl, tasks, names(tasks), mc.preschedule=TRUE, mc.cores=5))

save(tasks_md5, file='tasks.RData')
