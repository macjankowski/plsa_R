
setwd('/Users/mjankowski/doc/plsa_R')
source('../pub_lda/preprocessing.R')
source('../pub_lda/dimRed.R')
source('../pub_lda/classification.R')
source('../pub_lda/validation.R')
source('../pub_lda/choose_model.R')
source('./plsa_em.R')

################################## PLSA ################################



topic_number <- 10

filePath = './apps_desc.csv'

data <- read.csv(filePath, sep=";")  
dim(data)

dataAll <- cleanData(data)
rm(data)

labelMapping <- data.frame(label = c("ANDROID_TOOL", "KEYBOARD", "GAME", "NONE", "WIDGET", "USE_INTERNET", 
                                     "DOCUMENT_EDITOR", "LOCATE_POSITION", "APP_LIBRARY", "INTERNET_BROWSER", 
                                     "MESSAGING", "WALLPAPER", "WEATHER", "USE_CONTACTS", "BACKUP", "WORKOUT_TRACKING", 
                                     "CALENDAR", "MONEY", "GPS_NAVIGATION", "FLASHLIGHT", "HOME_LOCK_SCREEN", 
                                     "SMS", "JOB_SEARCH", "EBANKING", "CONTACT_MANAGER"), label = c(0:24))

dataAllLabelsNumeric <- labelsToNumeric(dataAll, labelMapping)
rm(labelMapping)

names(dataAllLabelsNumeric)[names(dataAllLabelsNumeric) == "label.1"] = "label"

dim(dataAllLabelsNumeric)
partitioned <- partitionData(dataAllLabelsNumeric)
rm(dataAllLabelsNumeric)

dim(partitioned$train)
dim(partitioned$test)

tfidfData <- prepareTfIdfWithLabels(partitioned, sparseLevel=0.98)
rm(partitioned)

tf <- t(tfidfData$cleanedTrainMatrix)
tf
dim(tf)
M <- dim(tf)[2]
V <- dim(tf)[1]
M
V
K <- topic_number
K

m_tf <- as.matrix(tf)
rm(tf)
rm(tfidfData)


l300 <- plsaEM(K=10, m_tf, iter = 20)

liks <- sapply(c(10,20,50,100, 200), function(k) plsaEM(K=k, m_tf, iter = 20))

liks_with_300 = c(liks, l300)

plot(c(10,20,50,100, 200, 300), liks_with_300)






