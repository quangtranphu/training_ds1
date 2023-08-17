library(plumber)
library(caret)
library(jsonlite)
library(yaml)

# Utilise post method to send JSON unseen data, in the same 
# format as our dataset

#--------------------------------------------------
# Read in model 
#--------------------------------------------------
model <- readRDS('tree.rds')

#* Test connection
#* @get /connection-status

function(){
  list(status = "Connection to Iris species API successful", 
       time = Sys.time(),
       username = Sys.getenv("USERNAME"))
}

#* Predict an Iris species
#* @serializer json
#* @post /predict

function(req, res){
  data.frame(predict(model, newdata = as.data.frame(req$body), type="prob"))
}

#* @plumber
function(pr){
  pr %>% 
    pr_set_api_spec(read_yaml("openapi.yaml"))
}