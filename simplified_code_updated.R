#PROCESS
#1. Use FCC API to get GEOID for each shooting (separate code)
#2. Use tidycensus get_decennial() to get block demographic information specifying state
    #and county (this piece of code)
#3. Join the two dataframes based on GEOID 



#1 - create vector of citynames
cityname <- c("Albuquerque", "Atlanta1", "Atlanta2", "Austin", "Baltimore", "Boston", "Charlotte", 
           "Chicago1", "Chicago2", "Cobb_County", "Columbus1", "Columbus2", "Columbus3", 
           "Denver1", "Denver2", "Denver3", 
           "Fort_Worth1", "Fort_Worth2", "Fort_Worth3", "Forth_Worth4", "Fresno", "Gwinnett", 
           "Houston1", "Houston2", "Houston3", "Indianapolis", "King", "Las_Vegas", "LongBeach_LosAngeles", 
           "Miami", "Oklahoma1","Oklahoma2", "Oklahoma3","Oklahoma4","Orlando", "Philadelphia", 
           "Phoenix", "Portland1", "Portland2", "Portland3", "Sacramento", 
           "SaltLake1", "SaltLake2", "San_Antonio1", "San_Antonio2", "San_Antonio3", 
           "San_Diego", "San_Francisco", "San_Jose", "St_Louis", 
           "Stockton", "Tucson", "Virginia_Beach")

#2 - create vector of state names
state <- c("NM", "GA", "13", "TX", "MD", "MA", "NC", 
           "IL", "IL", "GA", "OH", "OH", "OH",
           "CO", "CO", "CO",
           "TX", "TX", "TX", "TX", "CA", "GA", 
           "TX", "TX", "TX", "18", "WA", "NV", "CA", 
           "FL", "OK", "OK", "OK", "OK", "FL", "PA", 
           "AZ", "OR", "OR", "OR", "CA", 
           "UT", "UT", "TX", "TX", "TX",
           "CA", "CA", "CA", "MO", 
           "CA", "AZ", "VA")

cityname[20]
county[20]
state[20]

#create vector of county names 
county <- c("Bernalillo", "Fulton", "089","Travis", "baltimore city", "Suffolk", "Mecklenburg",
            "Dupage", "Cook", "Cobb", "Delaware", "Fairfield",  "Franklin",
            "Denver", "059", "005", 
            "Tarrant", "Denton", "Parker", "Wise", "Fresno", "Gwinnett",
            "Harris County", "Montgomery" ,"Fort Bend", "097",  "King", "Clark", "Los Angeles",
            "Miami-Dade", "Oklahoma", "Canadian", "Cleveland", "Pottawatomie", "Orange", "Philadelphia",
            "Maricopa", "Multnomah", "Washington", "Clackamas", "Sacramento", 
            "Salt Lake", "011", "Bexar", "Medina", "Comal", 
            "San Diego", "San Francisco", "Santa Clara", "Saint Louis City", 
            "San Joaquin", "Pima", "Virginia Beach")           

library(tidycensus)
library(tidyverse)
library(rebus)
library(stringr)

#VARIABLES:
#total population = "P001001"
#total male = "P012002"
#total female = "P012026"
#total black male = "P012B003"
#total hispanic male = "P012H002"
#total black population = "P003003"
#total hispanic population = "P004001"
#total white population = "P008003" 
#total asian population = "P003005"
#total native population = "P008005"
#total bi-racial (black/white) population = "P008011"
#total black hispanic = "P005012"
#total urban population = "P002002"
#single parent household (mother present) = "P018006"
#single parent household (father present) = "P018005"

# retrieve data from sf1
for(i in 1:length(county)){
  assign(cityname[i], get_decennial(geography = "block", county = county[i], state = state[i],
                                    variables = c(totpop = "P001001",
                                                  male = "P012002",
                                                  female = "P012026",
                                                  blackmale = "P012B003",
                                                  hispmale = "P012H002",
                                                  totblack = "P003003",
                                                  tothisp = "P004001",
                                                  totwhite = "P008003",
                                                  totasian = "P003005",
                                                  totnative = "P008005",
                                                  birac = "P008011",
                                                  blackhisp = "P005012",
                                                  toturban = "P002002",
                                                  singleparent_f = "P018006",
                                                  singleparent_m = "P018005"),
                                    year = 2010) %>% spread(key = "variable", value = "value"))
}

#combining city names into one city -- assuming so that when the for loop runs for diff
#counties within a city they will be combined using rbind

Atlanta <- rbind(Atlanta1, Atlanta2)
Chicago <- rbind(Chicago1, Chicago2)
Columbus <- rbind(Columbus1, Columbus2, Columbus3)
Denver <- rbind(Denver1, Denver2, Denver3)
Fort_Worth <- rbind(Fort_Worth1, Fort_Worth2, Fort_Worth3, Forth_Worth4)
Houston <- rbind(Houston1, Houston2, Houston3)
Oklahoma <- rbind(Oklahoma1, Oklahoma2, Oklahoma3, Oklahoma4)
Portland <- rbind(Portland1, Portland2, Portland3)
SaltLake <- rbind(SaltLake1, SaltLake2)
San_Antonio <- rbind(San_Antonio1, San_Antonio2, San_Antonio3)

# store the city sf1 info in a list
cityList <- list(Albuquerque, Atlanta, Austin, Baltimore, Boston, Charlotte, 
                 Chicago, Cobb_County, Columbus, 
                 Denver, 
                 Fort_Worth, 
                 Fresno, Gwinnett, 
                 Houston, Indianapolis, King, Las_Vegas, LongBeach_LosAngeles,
                 Miami, Oklahoma, Orlando, Philadelphia, 
                 Phoenix, Portland, Sacramento, 
                 SaltLake, San_Antonio, 
                 San_Diego, San_Francisco, San_Jose, St_Louis, 
                 Stockton, Tucson, Virginia_Beach)


# join with OIS
cook <- or("^Chicago", "Cook County Sheriff's Office")
king <- or("King County", "Seattle")
los_angeles <- or("Long Beach", "Los Angeles")
other <- or("", ",,,Fatal,,,Not-Struck,39.745542,-105.006865,,,,,,,,,,,,", "Black\"")

cityname_in_OIS <- list("Albuquerque", "Atlanta", "Austin", "Baltimore", "Boston", "Charlotte", 
           cook, "Cobb County Sheriff's Office", "Columbus", 
           "Denver", 
           "Fort_Worth", "Fresno", "Gwinnett", 
           "Houston", "Indianapolis", king, "Las Vegas", los_angeles, 
           "Miami", "Oklahoma City","Orlando", "Philadelphia", 
           "Phoenix", "Portland", "Sacramento", 
           "Salt Lake City", "San Antonio", 
           "San Diego", "San Francisco", "San Jose", "St.Louis", 
           "Stockton", "Tucson", "Virginia Beach", other)


# import OIS with GEOID updated
OIS_update <- read.csv("OIS_update_new.csv")
OIS_update <- OIS_update  %>%
  mutate(Tract.Code = str_pad(OIS_update$Tract.Code, 6, side = "left", pad = "0"),
         County.Code = str_pad(OIS_update$County.Code, 3, side = "left", pad = "0"), 
         State.Code = str_pad(OIS_update$State.Code, 2, side = "left", pad = "0")) %>% 
  #select(-ï..City, -X, -X.1) %>%
  unite(GEOID, State.Code:Block.Code, sep = "", remove = F)


OIS_final <- NULL
for(i in 1:length(cityname_in_OIS)){
  temp <- OIS_update %>% 
           filter(str_detect(City, cityname_in_OIS[[i]])) %>%
           left_join(cityList[[i]], by = "GEOID")
  OIS_final <- rbind(OIS_final, temp)
}


