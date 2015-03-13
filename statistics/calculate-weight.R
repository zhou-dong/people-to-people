library(rmongodb)
library(igraph)
#Sys.setenv(LANG = "en")

max_count <- function(){
    sort = mongo.bson.buffer.create()
    mongo.bson.buffer.append(sort, "value", -1L)
    sort = mongo.bson.from.buffer(sort)
    cursor = mongo.find(mongo, ns = ns, limit = 1L, skip = 0L, sort = sort)
    while (mongo.cursor.next(cursor)) {
        value = mongo.cursor.value(cursor)
    }
    err <- mongo.cursor.destroy(cursor)
    mongo.bson.value(value, 'value')
}

cursor_time <- function(){
    cursor_time = all_words_count / limit_number 
    if(all_words_count %% limit_number != 0) 
        cursor_time = cursor_time + 1
    cursor_time <- as.integer(cursor_time)
}

calculateTf <- function(count){
    count / max
}

calculateIdf <- function(count){
    log(max/count)
}

calculateWeight <- function(count){
    calculateTf(count) * calculateIdf(count) * 100L
}

updateLimitData <- function(time_count){
    skip_number = (time_count - 1) * limit_number
    cursor = mongo.find(mongo, ns, limit = limit_number, skip = skip_number)
    while (mongo.cursor.next(cursor)) {
        
        value = mongo.cursor.value(cursor)
        id <- mongo.bson.value(value, '_id')
        
        tmpWeight <- mongo.bson.value(value, 'weight')
        
        try(if(NULL!=tmpWeight){next},silent = TRUE)
        
        criteria <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(criteria, "_id", id)
        criteria <- mongo.bson.from.buffer(criteria)
        
        count <- mongo.bson.value(value, 'value')
        weight <- calculateWeight(count)
        
        objNew <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(objNew, "value", count)
        mongo.bson.buffer.append(objNew, "weight", weight)
        objNew <- mongo.bson.from.buffer(objNew)
        
        mongo.update(mongo,ns,criteria,objNew)
    }
    
    print(skip_number)
}

ns = "linkedin.final_skills"
mongo <- mongo.create()
if (!mongo.is.connected(mongo)){
    error("No connection to MongoDB")   
}

all_words_count <- mongo.count(mongo, ns)
max <- max_count()
limit_number = 1000L
cursors <- cursor_time()

for(i in 1: cursors){
    updateLimitData(i)  
}

mongo.disconnect(mongo)
mongo.destroy(mongo)