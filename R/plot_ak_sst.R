#  Create plotting function that will allow selection of 2 ESR regions
plot_ak_sst <- function(region1,region2){

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
          panel.border=element_rect(colour="black",size=0.75),
          axis.text.x=element_text(color=c("black",NA,NA,"black",NA,NA,"black",NA,NA,"black",NA,NA,NA)),
          legend.key.size = unit(0.35,"cm"),
          plot.margin=unit(c(0.65,0,0.65,0),"cm"))

  myfigure <- ggdraw(mylines_base) +
    #draw_image(paste0(.libPaths(),"/aksst/Data/fisheries_header_logo_jul2019.png"),scale=0.2,x=mylogox,y=mylogoy,hjust=0.35) +
    draw_image(system.file("data/fisheries_header_logo_jul2019.png",package="aksst"),scale=0.2,x=mylogox,y=mylogoy,hjust=0.35) +
    annotate("text",x=0.11,y=0.072,label=paste0("Data: JPL MUR SST, courtesy of NOAA Southwest Fisheries and CoastWatch West Coast; coastwatch.pfeg.noaa.gov/erddap\n           Contact: Jordan.Watson@noaa.gov, Alaska Fisheries Science Center, NOAA Fisheries (Updated: ",format(Sys.Date(),"%m-%d-%Y"),")"),
             hjust=0.1,size=2.57,family="sans",fontface=2,color=OceansBlue2)


  png(paste0("SST_",region1,"_",region2,"_",format(Sys.Date(),"%Y_%m_%d"),".png"),width=6,height=3.375,units="in",res=300)
  print(myfigure)
  dev.off()

  #myfigure
  #p <- plot(rnorm(1:10))
  #ggsave(paste0("SST_",region1,"_",region2,"_",format(Sys.Date(),"%Y_%m_%d"),".png"),width=6,height=3.375,units="in",res=300)
  #ggsave(paste0("SST_test_",format(Sys.Date(),"%Y_%m_%d"),".png"),width=6,height=3.375,units="in",dpi=300,p)
  #dev.off()

  print(paste0("SST image was saved as a .png file in your working directory ",getwd()))
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
