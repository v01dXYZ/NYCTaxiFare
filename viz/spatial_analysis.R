plot_avg_week <- function(name)
{
	ch <- dbConnect(RClickhouse::clickhouse(), host="localhost", dbname="nyctf")
	"SELECT toMonday(datetime) AS weektime,
	 avg(fare) AS afare,
	 avg(pcount) AS apass
	 FROM fare GROUP BY weektime" -> sql_avg_week
	avg_week <- dbGetQuery(ch, sql_avg_week)
	avg_week %>% ggplot + geom_line(aes(weektime, afare))
	ggsave(name %s+% ".png")
}

plot_pcount <- function(name)
{
	ch <- dbConnect(RClickhouse::clickhouse(), host="localhost", dbname="nyctf")
	"SELECT pcount, count(*) AS count
	 FROM fare
	 GROUP BY pcount
	 ORDER BY pcount" -> sql_pc
	 pc <- dbGetQuery(ch, sql_pc)
	 pc %>% ggplot(aes(x="", y=count, fill=cut(pcount, c(0:7, 250), labels=c(0:6, "Plus grand que 6"), right=F))) + 
		geom_bar(stat="identity") + coord_polar("y", start=0) + 
		scale_fill_brewer(palette="Set1") + 
		labs(x="", y="", fill="Compte") +
		ggtitle("Nombre de courses suivant le nombre de passagers") 
	ggsave(name %s+% ".png")
}

plot_radius <- function(name)
{
	ch <- dbConnect(RClickhouse::clickhouse(), host="localhost", dbname="nyctf")
	"SELECT floor(log10(pow(ilong + 73.98, 2) + pow(ilat - 40.77, 2) + 1), 1) AS radius,
	 log10(count(*)) AS count
	 FROM fare
	 GROUP BY radius" -> sql_radius 
	radius <- dbGetQuery(ch, sql_radius)
	radius %>% ggplot() + geom_col(aes(radius, count)) +
			      labs(x="Log10 Distance quadratique avec Centrale Park", y="Log10 Comptage") 
	ggsave(name %s+% ".png")
}

plot_cartography <- function(name)
{
	ch <- dbConnect(RClickhouse::clickhouse(), host="localhost", dbname="nyctf")
	i <- dbGetQuery(ch, 'SELECT izone, count(*) as icount, avg(fare) as iafare FROM nycfare GROUP BY izone')
	o <- dbGetQuery(ch, 'SELECT ozone, count(*) as ocount, avg(fare) as oafare FROM nycfare GROUP BY ozone')
	mn <- st_intersection(st_buffer(tz[tz$zone == "Garment District", ], dist=18500),
			      tz[tz$borough == "Manhattan", ])
	box_mn <- create_mask(bb = mn)
	zoom_mn <- move_and_resize(x=tz, mask=box_mn, xy=c(911876.62308557, 201482.760004603), k=2)
	zoom_mn_contour <- move_and_resize(x=nb, mask=box_mn, xy=c(911876.62308557, 201482.760004603), k=2)
	tz2 <- inset_rbinder(list(tz, zoom_mn))

	m <- left_join(tz2, i,by=c("zone" = "izone"))
	m <- full_join(m, o, by=c("zone" = "ozone"))

	m$icount[m$icount == max(m$icount)] = 0
	m$ocount[m$ocount == max(m$ocount)] = 0
	m[, "airport"] <- ifelse(m$zone %in% c("JFK Airport", "LaGuardia Airport"), "Airport", "Non Airport")

	st_geometry(m) <- "geom"

	box <- move_and_resize(x=box_mn, mask=box_mn, xy=c(911876.62308557, 201482.760004603), k=2)
	cols <- carto.pal(pal1 = "green.pal", n1 = 3, pal2 = "red.pal", n2 = 6)
	print_cartography_io <- function(var, file)
	{
		png(file, width=3.25, height=3.25, units="in", pointsize=4, res=1200)
		plot(st_geometry(m), col=NA, border=NA,  bg = "#A6CAE0")
		plot(st_geometry(ss), col="#E3DEBF", border=NA, add=TRUE)
	
		typoLayer(m,
			  var="airport",
			  border="grey40",
			  col=c("grey", "gold"),
			  legend.title.txt="",
			  lwd = 0.25, add=TRUE)
		plot(st_geometry(nb), border="grey20", lwd=0.35, add=TRUE)
		plot(st_geometry(zoom_mn_contour), border="grey20", lwd=0.35, add=TRUE)
		plot(st_geometry(box), border="black", add=TRUE, lwd=0.3)
		propSymbolsChoroLayer(m, var=paste(var, "count", sep=""),
				     	 var2=paste(var, "afare", sep=""),
					 col=cols, add=TRUE, inches=0.05,
					 border="grey40", lwd = 0.1)
		layoutLayer(title = "Prix de la course en fonction des zones",
			    source = "NYC Taxi", frame = TRUE, col = NA, 
			    scale = NULL, coltitle = "black", south = TRUE)
		dev.off()
	}

	mclapply(list(list("i", name %s+% "-i.png"),
			list("o", name %s+% "-o.png")), function(f) do.call(print_cartography_io, f), mc.cores=2);
}
