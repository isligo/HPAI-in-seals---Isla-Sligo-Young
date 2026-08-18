# read documents
q_pcr=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/qPCR/sgk25afs1.isy_Analysis Data.csv")
SGK_25_NEC_SES_and_SFS_Lab_Log_ISY=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY.csv")

# Step 1: Extract just the 'Well' and 'Cq' and 'Sample.ID' columns from q_pcr
qpcr_subset <- q_pcr[, c("Well", "Cq", "Sample")]
# Step 2: Rename the columns to match lab log
names(qpcr_subset) <- c("qPCR.Plate.Location", "Cq.Value","Sample.ID" )


# Match lablog locations and NEW qPCR document
match_rows <- match(
  SGK_25_NEC_SES_and_SFS_Lab_Log_ISY$Sample.ID, 
  qpcr_subset$Sample.ID)

# Extract the matching new Cq values into a temporary variable
new_cq_values <- qpcr_subset$Cq.Value[match_rows]

# 3. Identify rows that actually found a match in your new document
has_new_match <- !is.na(match_rows)

# 4. Overwrite OR fill those matched rows with the newest data
SGK_25_NEC_SES_and_SFS_Lab_Log_ISY$Cq.Value[has_new_match] <- new_cq_values[has_new_match]
# should be able to just reuse same code even if some cq values are already filled in 
# save csv

write.csv(SGK_25_NEC_SES_and_SFS_Lab_Log_ISY, "~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY.csv")



