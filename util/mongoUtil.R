Sys.setenv(LANG = "en")

library(rmongodb)

MongoUtil <- setClass(
    "MongoUtil",
    slots = c(
        db  = "character",
        collection = "character"
    ),
    prototype=list(
        db = "linkedin"
    )
)

setGeneric(name = "getTotalCount",
           def=function(theObject, mongo){
               standardGeneric("getTotalCount")
           }
)
setMethod(f = "getTotalCount",
          signature = "MongoUtil",
          definition = function(theObject, mongo){
              namespace <- paste(theObject@db, theObject@collection, sep=".")
              result <- mongo.count(mongo, namespace)
              return(result)
          }
)

setGeneric(name = "getCursorTime",
           def = function(theObject, mongo, size){
               standardGeneric("getCursorTime")
           }
)
setMethod(f = "getCursorTime",
          signature = "MongoUtil",
          definition = function(theObject, mongo, size){
              total <- getTotalCount(util, mongo)
              result =  total / size 
              if(total %% size != 0) 
                  result = result + 1
              return (as.integer(result))
          }
)

testUtil <- function (){
    util <- MongoUtil(collection="industry")
    print(util)
    
    mongo <- mongo.create()
    
    total <- getTotalCount(util, mongo)
    cursorTime <- getCursorTime(util, mongo, 1)
    print(total)
    print(cursorTime)
    mongo.disconnect(mongo)
    mongo.destroy(mongo)
}

testUtil()