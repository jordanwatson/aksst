#  Create plotting function that will allow selection of 2 ESR regions
update_and_plot_ak_sst <- function(region1,region2){

  print("Package aksst is querying the latest sea surface temperature data. This may take 10-20 seconds depending on your internet speed.")

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
    arrange(read_date)

  #  Load 508 compliant NOAA colors
  OceansBlue1='#0093D0'
  OceansBlue2='#0055A4' # rebecca dark blue
  CoralRed1='#FF4438'
  SeagrassGreen1='#93D500'
  SeagrassGreen4='#D0D0D0' # This is just grey
  UrchinPurple1='#7F7FFF'
  WavesTeal1='#1ECAD3'

  #  Assign colors to different time series.
  current.year.color <- OceansBlue1
  last.year.color <- WavesTeal1
  mean.color <- "black"

  #  Set default plot theme
  theme_set(theme_cowplot())

  #  Specify legend position coordinates
  mylegx <- 0.525
  mylegy <- 0.865

  #  Specify NOAA logo position coordinates
  mylogox <- 0.045
  mylogoy <- 0.285

  #  Set year criteria to automatically identify the current and previous years
  current.year <- max(data$year)
  last.year <- current.year-1
  mean.years <- 2003:2012
  mean.lab <- "Mean 2003-2012"

    mylines_base <- ggplot() +
    geom_line(data=data %>% filter(year2<last.year & esr_region%in%(c(region1,region2))),
              aes(newdate,meansst,group=factor(year2),col='mygrey'),size=0.3) +
    geom_line(data=data %>% filter(year2==last.year & esr_region%in%(c(region1,region2))),
              aes(newdate,meansst,color='last.year.color'),size=0.75) +
    geom_line(data=data %>%
                filter(year%in%mean.years & esr_region%in%(c(region1,region2))) %>%
                group_by(esr_region2,newdate) %>%
                summarise(meantemp=mean(meansst,na.rm=TRUE)),
              aes(newdate,meantemp,col='mean.color'),size=0.5) +
    geom_line(data=data %>% filter(year2==current.year & esr_region%in%(c(region1,region2))),
              aes(newdate,meansst,color='current.year.color'),size=0.95) +
    facet_wrap(~esr_region2,ncol=2) +
    scale_color_manual(name="",
                       breaks=c('current.year.color','last.year.color','mygrey','mean.color'),
                       values=c('current.year.color'=current.year.color,'last.year.color'=last.year.color,'mygrey'=SeagrassGreen4,'mean.color'=mean.color),
                       labels=c(current.year,last.year,paste0('2002-',last.year-1),mean.lab)) +
    ylab("Mean Sea Surface Temperature (C)") +
    xlab("") +
    scale_x_date(date_breaks="1 month",
                 date_labels = "%b",
                 expand = c(0.025,0.025)) +
    theme(legend.position=c(mylegx,mylegy),
          legend.text = element_text(size=8,family="sans"),
          legend.background = element_rect(fill="white"),
          legend.title = element_blank(),
          strip.text = element_text(size=10,color="white",family="sans",face="bold"),
          strip.background = element_rect(fill=OceansBlue2),
          axis.title = element_text(size=10,family="sans"),
          axis.text = element_text(size=10,family="sans"),
          panel.border=element_rect(colour="black",size=0.75),
          axis.text.x=element_text(color=c("black",NA,NA,"black",NA,NA,"black",NA,NA,"black",NA,NA,NA)),
          legend.key.size = unit(0.35,"cm"),
          plot.margin=unit(c(0.65,0,0.65,0),"cm"))



  ggdraw(mylines_base) +
    draw_image("Data/fisheries_header_logo_jul2019.png",scale=0.2,x=mylogox,y=mylogoy,hjust=0.35) +
    #annotate("text",x=0.115,y=0.085,label=paste0("Contact: Jordan.Watson@noaa.gov, Alaska Fisheries Science Center, NOAA Fisheries (data: JPL MUR SST, ",format(Sys.Date(),"%m-%d-%Y"),")"),
    #         hjust=0.1,size=2.59,family="sans",fontface=2,color=OceansBlue2)
    annotate("text",x=0.11,y=0.072,label=paste0("Data: JPL MUR SST, courtesy of NOAA Southwest Fisheries and CoastWatch West Coast; coastwatch.pfeg.noaa.gov/erddap\n           Contact: Jordan.Watson@noaa.gov, Alaska Fisheries Science Center, NOAA Fisheries (Updated: ",format(Sys.Date(),"%m-%d-%Y"),")"),
             hjust=0.1,size=2.57,family="sans",fontface=2,color=OceansBlue2)
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
