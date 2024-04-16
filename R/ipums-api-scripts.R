
# this function will rename and unzip the nhgis download
rename_unzip_files <- function(download_extract, topics, i) {
  
  # determine variable names
  table_url <- download_extract$download_links$table_data$url
  table_zip <- sub(".*/", "", basename(table_url))
  table_name <-  sub("^(.*?)_.+$", "\\1", table_zip)
  name_replace <- topics[i]
  data_path <- file.path("data")
  
  # unzip downloaded data
  unzip(zipfile = table_zip, exdir = data_path)
  
  # all items to rename
  all_items <- c(list.files(data_path, full.names = TRUE, recursive = TRUE),
                 list.dirs(data_path, full.names = TRUE, recursive = TRUE))
  
  #iIterate over each item
  for (item in all_items) {
    base_name <- basename(item)
    new_name <- gsub(table_name, name_replace, base_name)
    new_name <- gsub("_csv", "", new_name)
    new_path <- file.path(dirname(item), new_name)
    file.rename(item, new_path)
  }
  
  #remove original zip file
  file.remove(table_zip)
}


# function to downlaod the data from nhgis based on a vector of table names, a vector of geographies, and a list of the years of interest
download_data <- function(t,g,a){
  
  for (i in seq_along(t)) {
    # format request
    nhgis_ext2 <- define_extract_nhgis(
      description = "Time Series Download",
      time_series_tables = tst_spec(
        t[i], 
        geog_levels = g,
        years = a
      )
    )
    
    # submit and download requested data
    nhgis_ext_submitted2 <- submit_extract(nhgis_ext2,api_key = apikey)
    downloadable_extract2 <- wait_for_extract(nhgis_ext_submitted2, api_key = apikey)
    data_files2 <- download_extract(downloadable_extract2, api_key = apikey)
    
    rename_unzip_files(downloadable_extract2, t, i)
  }
}


# function to create a file geodatabase layer for a specific metric
create_save_places_2022_layer <- function(data_table, data_code, data_descrip, places_2022){
  # read in the time series data
  csv_data <- read_csv(paste0("data/",data_table,"/",data_table,"_ts_nominal_place.csv")) %>%
    filter(STATE == 'Utah') %>%
    select(
      -matches("GJOIN(201[0-9]|202[0-1])"),
      -matches("NAME(201[0-9]|202[0-1])"),
      -c("STATE", "STATEFP", "STATENH", "PLACEA"),
      -ends_with("M"),
      -NHGISCODE
    )
  
  # clean up and widen data
  csv_data_wide <- csv_data %>%
    pivot_longer(
      cols = -c(GJOIN2022, PLACE, NAME2022),
      names_to = "CODEYEAR",
      values_to = "VAL"
    ) %>%
    mutate(
      Code = substr(CODEYEAR, 4, 5),
      Year = as.integer(paste0("20",substr(CODEYEAR, 6, 7)))#,
      #ShortName = AC2_data_dict$ShortName[match(Code, AC2_data_dict$Code)],
      #Name = AC2_data_dict$Name[match(Code, AC2_data_dict$Code)]
    ) %>%
    select(-CODEYEAR, Code, PLACE)
  
  # select metric and format table
  csv_data_select <- csv_data_wide %>%
    filter(Code == data_code) %>%
    pivot_wider(
      id_cols = c(GJOIN2022, PLACE),
      names_from = Year,
      values_from = VAL
    ) %>%
    rename_with(
      ~paste0("ACS5_", .x),
      starts_with("20")  # Assuming the years start with "20"
    )
  
  # join to geometry
  csv_data_gis <- places_2022 %>%
    left_join(csv_data_select, by=c("GISJOIN" = "GJOIN2022"))
  
  # save to gdb
  layer_name   <- paste0(data_table,"_",data_code,"_",data_descrip)
  arc.write(paste0("outputs/NHGIS-Time-Series.gdb/",layer_name), csv_data_gis, overwrite = TRUE)
}