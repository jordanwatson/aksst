

Author: Jordan Watson (jordan.watson@noaa.gov)


This package uses the JPL MUR SST dataset to plot regional Alaska sea surface temperatures in a format that looks like the following image.

![sst image](/images/SST_Twitter_image.png)


The data are downloaded daily through the NOAA CoastWatch West Coast Node ERDDAP, and ingested at AKFIN, the Alaska Fisheries Information Network. For each day, approximately 10 million temperature records are aggregated into the Alaska Department of Fish and Game statistical management areas. Within each of these areas and on each day, the data are averaged to yield 1,758 daily average SST records (one sst record per stat area). These data are then binned into regional spatial strata as described by the NOAA Alaska Fisheries Science Center Ecosystem Status Consideration spatial strata, "Eastern Bering Sea (EBS)", "Northern Bering Sea (NBS)", "Western Gulf of Alaska (WGOA)", and the "Eastern Gulf of Alaska (EGOA)". These daily regional SST values are available via a public webAPI at AKFIN. The key step to this R package is to query this daily time series from AKFIN using this API key, and this is what is downloaded when using the `update_sst_data()` function.


The aksst package can be installed for R from github.

```
library(devtools)
install_github("jordanwatson/aksst")
```

Currently there are only a few basic functions. The data are updated daily and the full time series is updated when running the `update_sst_data()` function. A message will notify users that this may take 10-20 seconds to download the data.

```
library(aksst)
data <- update_sst_data()
```
There are four regions that can be easily examined, "EBS", "NBS", "EGOA", "WGOA". The scaling works best if Bering Sea plots are kept together and GOA plots are kept together. Current formatting is for two areas at a time. A future version may include a single area.

A single function will output a formatted jpg file to the working directory, whith the NOAA logo and some metadata at the bottom.
```
plot_ak_sst("EBS","NBS")
```

To plot a generic version to your R console, you can use the generic plotting function that omits the NOAA logo and metadata.
```
plot_ak_sst_generic("EBS","NBS")
```




For more information on the spatial strata, see descriptions in the Bering Sea and Gulf of Alaska Ecosystem Status Reports (keyword search for Watson).
https://access.afsc.noaa.gov/REFM/REEM/ecoweb/

For more information about methods, see:
A contribution in the Pacific States e-Journal for Scientific Visualizations.
https://psesv.psmfc.org/PSESV3.html
