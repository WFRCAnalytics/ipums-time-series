
# data dictionary

#==============================================================================#
#' AC2 Data Dictionary
#'  AUTO = SOV + HOV + HOV2 + HOV3 + HOV4 + HOV56 + HOV7P
#'  PT = PT-BUS-LRT + PT-SUB + PT-CRT
#'  MOTORIZED = AUTO + PT + TAXI + MCYCLE
#'  NONMOTORIZED = BIKE + WALK
#'  TOTAL = MOTORIZED + NONMOTORIZED + OTHER + WFH
#==============================================================================#
AC2_data_dict <- tibble(
  Code = c("AA","AB","AC", "AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR"),
  Name = c("Car, truck, or van",
           "Car, truck, or van--Drove alone",
           "Car, truck, or van--Carpooled",
           "Car, truck, or van--Carpooled--In 2-person carpool",
           "Car, truck, or van--Carpooled--In 3-person carpool",
           "Car, truck, or van--Carpooled--In 4-person carpool",
           "Car, truck, or van--Carpooled--In 5- or 6-person carpool",
           "Car, truck, or van--Carpooled--In 7-or-more-person carpool",
           "Public transportation (excluding ferryboat and taxicab)",
           "Public transportation (excluding ferryboat and taxicab)--Bus, streetcar, or (since 2019) light rail",
           "Public transportation (excluding ferryboat and taxicab)--Subway or elevated rail",
           "Public transportation (excluding ferryboat and taxicab)--Railroad (until 2018) or long-distance train or commuter rail (since 2019)",
           "Taxicab",
           "Motorcycle",
           "Bicycle",
           "Walked",
           "Other means (including ferryboat)",
           "Worked from home"),
  ShortName = c("AUTO",
                "SOV",
                "HOV",
                "HOV2",
                "HOV3",
                "HOV4",
                "HOV56",
                "HOV7P",
                "PT",
                "PT-BUS-LRT",
                "PT-SUB",
                "PT-CRT",
                "TAXI",
                "MCYCLE",
                "BIKE",
                "WALK",
                "OTHER",
                "WFH")
)

