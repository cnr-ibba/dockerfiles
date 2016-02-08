
packages <- read.table("/root/packages.txt")
install.packages(packages[,1], , repos='https://cran.rstudio.com/')
