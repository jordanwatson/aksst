.onLoad <- function(){

  #  Query data from public web API
  data <- httr::content(httr::GET('https://apex.psmfc.org/akfin/data_marts/akmp/GET_TIME_SERIES_REGIONAL_AVG_TEMPS'), type = "text/csv") %>%
    rename_all(tolower) %>%
    mutate(read_date=as.Date(read_date,format="%m/%d/%Y"),
           julian=as.numeric(julian),
           esr_region=fct_relevel(esr_region,"NBS","EBS","EGOA","WGOA","SEAK Inside"),
           esr_region2=case_when(
             esr_region=="EBS" ~ "Eastern Bering Sea Shelf",
             esr_region=="NBS" ~ "Northern Bering Sea Shelf",
             esr_region=="EGOA" ~ "Eastern Gulf of Alaska",
             esr_region=="WGOA" ~ "Western Gulf of Alaska",
             esr_region=="CGOA" ~ "Central Gulf of Alaska"),
           esr_region2=fct_relevel(as.factor(esr_region2),"Northern Bering Sea Shelf","Eastern Bering Sea Shelf","Western Gulf of Alaska","Eastern Gulf of Alaska"),
           month=month(read_date),
           day=day(read_date),
           newdate=as.Date(ifelse(month==12,as.character(as.Date(paste("1999",month,day,sep="-"),format="%Y-%m-%d")),
                                  as.character(as.Date(paste("2000",month,day,sep="-"),format="%Y-%m-%d"))),format("%Y-%m-%d")),
           year2=ifelse(month==12,year+1,year)) %>%
    arrange(read_date) #%>%
  #group_by(esr_region) %>%
  #mutate(meansst3=rollmean(meansst,k=3,fill=NA), # 3-day rolling average of SST
  #       meansst5=rollmean(meansst,k=5,fill=NA), # 5-day rolling average of SST
  #       meansst7=rollmean(meansst,k=7,fill=NA)) # 7-day rolling average of SST

}

#png(paste0("figure_output/SST_Twitter_",format(Sys.Date(),"%Y_%m_%d"),".png"),width=6,height=3.375,units="in",res=300)
#myplotfun("NBS","EBS")
#dev.off()
#myplotfun("EGOA","WGOA")

#jpeg(paste0("figure_output/SST_Bering_Twitter_",format(Sys.Date(),"%Y_%m_%d"),".jpeg"),width=6,height=4,units="in",quality=100,res=300)
#myplotfun("NBS","EBS")
#dev.off()

#jpeg(paste0("figure_output/SST_GOA_Twitter_",format(Sys.Date(),"%Y_%m_%d"),".jpeg"),width=6,height=4,units="in",quality=100,res=300)
#myplotfun("EGOA","WGOA")
#dev.off()

#  Download heatmap of Alaska region
#link = "https://coastwatch.pfeg.noaa.gov/erddap/griddap/jplMURSST41anom1day.largePng?sstAnom%5B(2020-06-15T09:00:00Z)%5D%5B(50.0):(70.0)%5D%5B(-174.99):(-141.0)%5D&.draw=surface&.vars=longitude%7Clatitude%7CsstAnom&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff"
#download.file(link,destfile=paste0("Heatmap_",format(Sys.Date(),"%Y_%m_%d"),".png"),mode='wb')
