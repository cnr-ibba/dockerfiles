library(dplyr)
library(reshape2)
options(warn=-1)  # turn off unneccesary NON-EXISTING NA warnings


# =========================================================================
# function get_crime_data
#
# @description: get data from FBI url: http://www.ucrdatatool.gov/Search/Crime/State/StatebyState.cfm
#               CSV data can be obtained by querying:
#                   - for 50 states (except District of Columbia)
#                   - "Violent crime rates" and "property crime rates"
#               The saved CSV is conveniently provided in this project as "data.csv"
# @return: reshaped dataframe of crime statistics by state, year and crime
# =========================================================================

get_crime_data <- function(file) {
    states <- c("Alabama"="AL",
                "Alaska"="AK",
                "Arizona"="AZ",
                "Arkansas"="AR",
                "California"="CA",
                "Colorado"="CO",
                "Connecticut"="CT",
                "Delaware"="DE",
                "Florida"="FL",
                "Georgia"="GA",
                "Hawaii"="HI",
                "Idaho"="ID",
                "Illinois"="IL",
                "Indiana"="IN",
                "Iowa"="IA",
                "Kansas"="KS",
                "Kentucky"="KY",
                "Louisiana"="LA",
                "Maine"="ME",
                "Maryland"="MD",
                "Massachusetts"="MA",
                "Michigan"="MI",
                "Minnesota"="MN",
                "Mississippi"="MS",
                "Missouri"="MO",
                "Montana"="MT",
                "Nebraska"="NE",
                "Nevada"="NV",
                "New Hampshire"="NH",
                "New Jersey"="NJ",
                "New Mexico"="NM",
                "New York"="NY",
                "North Carolina"="NC",
                "North Dakota"="ND",
                "Ohio"="OH",
                "Oklahoma"="OK",
                "Oregon"="OR",
                "Pennsylvania"="PA",
                "Rhode Island"="RI",
                "South Carolina"="SC",
                "South Dakota"="SD",
                "Tennessee"="TN",
                "Texas"="TX",
                "Utah"="UT",
                "Vermont"="VT",
                "Virginia"="VA",
                "Washington"="WA",
                "West Virginia"="WV",
                "Wisconsin"="WI",
                "Wyoming"="WY")
    
    # load data from csv
    df <- read.csv(file=file, header=FALSE, stringsAsFactors=FALSE, na.strings=c("", ".", "NA"))
    
    # clean malformed csv data
    colnames(df) <- df[4, ]  # column header is in row 4
    df <- df[, colSums(is.na(df)) < nrow(df)]  # remove columns containing all NAs in malformed csv
    df <- df %>% 
        rename(year = Year) %>%
        mutate(year = as.integer(year)) %>%
        na.omit() %>%  # removes header rows (years not coerced to integer)
        filter(year >= 1965)  # manual observation: csv data is incomplete for years < 1965
    years <- unique(df$year)  # get number of years to add states column
    
    # reshape df from wide to long
    df <- df %>%
        mutate(state = rep(unname(states), each=length(years)),
               state_name = rep(names(states), each=length(years)))  # add states column
    df <- melt(df, id=c("year", "state", "state_name")) %>%  # melt from wide to long
        rename(crime = variable) %>%
        mutate(crime = as.character(crime),
               value = as.numeric(value)) %>%
        filter(crime != "Population") %>%
        arrange(-year, crime, state)
    return(df)
}