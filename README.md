# PolicingLabResearch
This repo is for my Fall 2020 research project conducted at Emory University. We are looking to clean, manipulate and visualize data on domestic officer involved shootings, mapping Census demographic information to each shooting incident. This research was conducted in partnership with Mengxuan Yan, a fellow student at Emory University. Further updates will follow from this semester. 


## Big Picture Goal: 
Merge Census data with the pre-existing officer-involved shooting dataset (OIS_master). More specifically, Find the smallest geographical unit (Census block) where each shooting incident occurred and gather relevant demographic features of the units from Census Bureau data

OIS_master dataset has around 4086 entries in 36 different cities across the US. The original columns are as follows:
- Incident ID
- City
- Date
- Time
- *Location (Address)
- *Coordinates (lat/long)
- Offender ID
- *Offender Race
- Offender Fatality  
- (Fatal / Struck / Not-Struck)
- *Officer Race
- *Officer Fatality
- (Fatal / Struck / Not-Struck)

* indicates missing or incomplete information. 

## Basic Process
1. Block-level GEOID: Use the Census and FCC APIs to get GEOIDs for every shooting location based off of address and coordinates respectively
2. Census Demographic Information: Use the get_decennial() function in the tidycensus package to get block-level demographic info for every block (identified by a 15-digit GEOID) in every county/state combination that had a shooting incident
3. Join the two datasets: Join the OIS_master data with the block-level Census data so that each shooting incident has relevant demographic features 

Further information can be found here: https://docs.google.com/presentation/d/1cPYxRZC9R3QHfxb1EbvBnYnOpdTCMtkQmqvCT0t5TeQ/edit?usp=sharing





