update_sst_data <- function(){

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
