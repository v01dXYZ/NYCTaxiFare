all:
	Rscript -e "library(RSclient); c <- RS.connect(); RS.server.eval(c, 'setwd("$(CURDIR)")'); RS.server.source(c, 'exec.R'); RS.close(c)"
clean:
	Rscript -e 'library(RSclient); c <- RS.connect(); RS.server.eval(c, "tasks_md5 <<- list()"); RS.close(c)'
	rm -f tasks.RData

launch-server:
	R CMD Rserve --RS-enable-control -
