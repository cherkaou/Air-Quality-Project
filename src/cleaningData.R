library(data.table)
#On choisit le fichier qui contient les données
fic = file.choose()
data = read.csv(fic, header = TRUE, sep = ";", stringsAsFactors = FALSE)

#On supprime ces deux colonnes car elles contiennent des valeurs manquantes 
data$X = NULL
data$X.1 = NULL

#On supprime les lignes contenant des valeurs manquantes 
for(i in 1:15){
  data = subset(data, !is.na(data[i,]))
}

#On met les données sous le bon format : format de date standard + nettoyage des données
data$Date = as.Date(data$Date,format='%d/%m/%Y' )
data$CO.GT. = as.numeric(sub(",", ".", data$CO.GT.))
data$C6H6.GT. = as.numeric(sub(",", ".", data$C6H6.GT.))
data$T = as.numeric(sub(",", ".", data$T))
data$RH = as.numeric(sub(",", ".", data$RH))
data$AH = as.numeric(sub(",", ".", data$AH))


#On regroupe les données par jour en supprimant le temps et en prenant la moyenne de toutes les concentrations de gaz par jour
daily_data = copy(data)
daily_data$Time = NULL
daily_data = apply(daily_data[,2:14],2,tapply, daily_data$Date,mean )
daily_data = as.data.frame(daily_data)
setDT(daily_data, keep.rownames = "Date")
setDF(daily_data)
daily_data$Date = as.Date(daily_data$Date,format="%Y-%m-%d" )