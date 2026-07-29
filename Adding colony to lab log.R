# read documents
# code to add colonies to lab log 



who_to_extract=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK25_NEC_SES_AFS_who_to_extract.csv")
SGK_25_NEC_SES_and_SFS_Lab_Log_ISY=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY.csv")



# Step 1: Extract just colony from who to extract
extract_colony<- who_to_extract[, c("Colony","sample_name")]

# Step 2: Rename the columns to match lab log
names(extract_colony) <- c("Colony","Sample.ID" )



SGK_25_NEC_SES_and_SFS_Lab_Log_ISY <- SGK_25_NEC_SES_and_SFS_Lab_Log_ISY %>% left_join(extract_colony, by = c("Sample.ID")) 



# save csv

write.csv(SGK_25_NEC_SES_and_SFS_Lab_Log_ISY, "~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY.csv")

# doing the same but adding extra info needed for maps

# read documents
# code to add colonies to lab log 



who_to_extract=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK25_NEC_SES_AFS_who_to_extract.csv")
SGK_25_NEC_SES_and_SFS_Lab_Log_ISY=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY.csv")



# Step 1: Extract just colony from who to extract
extract_moreinfo<- who_to_extract[, c("Latitude",	"Longitude","Age","sample_name")]

# Step 2: Rename the columns to match lab log
names(extract_colony) <- c("Colony","Sample.ID" )

extract_moreinfo <- extract_moreinfo %>%
  rename("Sample.ID" = "sample_name")


SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo<- SGK_25_NEC_SES_and_SFS_Lab_Log_ISY %>% left_join(extract_moreinfo, by = c("Sample.ID")) 



# save csv

write.csv(SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo, "~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo.csv")

