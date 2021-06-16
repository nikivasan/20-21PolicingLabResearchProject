# PolicingLabResearch Fall 2020
### By Niki Vasan and Mengxuan Yan

The project was conducted in two stages, Stage 1 being the process used to gather the relevant Census demographic information and Stage 2 being joining the data to our original dataset with the use of force incidients. See our final [slide deck](https://github.com/nikivasan/PolicingLabResearch/blob/master/Fall2020/Policing%20Lab%20Research%20Presentation.pdf) that encompasses our methods and results for more information.

## Stage 1: simplified_code_updated.R

This is the more efficient code that we used to gather the Census information. We originally used the get_decennial() function from the package tidycensus (API call to the decennial Census) on each county-state combination individually for a total of the 37 cities and obtained block-level data from the Decennial Census: Summary File 1 (2010), sf1. 
Used variables beginning with “P” which give us population info down to the block level. Each observation in the result is a block that has a 15-digit GEOID as the identifier and variables we want. However, repeating this process individually for each of the 37 cities was tedious so we created an efficient and replicable version of the code where we looped over vectors containing the counties and respective states and assigned the result to the city names.
We then saved all the cities to a list to later join with the OIS_master. 

## Stage 2: google maps API

In order to join OIS_master with the dataset from above, we needed the GEOID of the existing observations in OIS_master. We first tried the US Census Geocoder which takes an address batch as an input and returns the GEOID of each address. However, many addresses were formatted incorrectly so we had around 1600 NA values for the GEOID column (40%). We then used the Federal Communications Commission (FCC) geocoding API which takes coordinates as an input and 
this cut the number of NAs in the GEOID column down to 559. Finally, we used the ggmaps package with the Google Maps API to find coordinates of remaining data points that had incorrectly formatted addresses and no coordinates. Then we could use the FCC API again to find the GEOID; this resulted in only 3 missing GEOIDs. 






