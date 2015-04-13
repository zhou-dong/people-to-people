Sys.setenv(LANG = "en")

library(rmongodb)
library(class)

total_count <- function(ns){
    mongo.count(mongo, ns)
}

cursor_time <- function(total, size){
    cursor_time =  total / size 
    if(total %% size != 0) 
        cursor_time = cursor_time + 1
    cursor_time <- as.integer(cursor_time)
}

init_keywords <- function(ns, prefix, appear_limit){
    result <- vector()
    names <- vector()
    total = total_count(ns)
    time <- cursor_time(total, fetch_size)
    
    for(x in 1: time){
        begin = (x - 1) * fetch_size
        cursor = mongo.find(mongo, ns, limit = fetch_size, skip = begin)
        while (mongo.cursor.next(cursor)) {
            value = mongo.cursor.value(cursor)
            count <- mongo.bson.value(value,"value")
            if(as.double(count) < appear_limit)
                next
            weight <- mongo.bson.value(value,"weight")
            name <- mongo.bson.value(value,"_id")
            names <- c(names, paste(prefix, name, sep="-"))
            result <- c(result, as.double(weight))
        }
    }
    result <- setNames(result, names)
}

init_names <- function(){
    name <- c(names(industry))
    name <- c(name, names(skill))
    name <- c(name, names(edu))
    name <- c(name, names(position))
}

new_person <- function(){
    name <- init_names()  
    person <- vector(mode = "numeric",length=length(name))
    person <- setNames(person, name)
}

create_person <- function(value){
    person <- new_person()
    person <- add_weight_to_person(value, person, "skills", skill)
    person <- add_weight_to_person(value, person, "industry", industry)
    person <- add_weight_to_person(value, person, "educations", edu)
    person <- add_weight_to_person(value, person, "positions", position)
    person <- person[!is.na(person)]
}

add_weight_to_person <- function(data, person, cat, dictionary){
    category <-  mongo.bson.find(data, cat)
    tmp = mongo.bson.value(data,cat)
    if(!is.character(tmp))
        return(person)
    iter <- mongo.bson.iterator.create(category)
    while (mongo.bson.iterator.next(iter)){
        val <- mongo.bson.iterator.value(iter)
        word_name <- paste(cat, val, sep="-")
        word_weight <- dictionary[word_name]
        person[word_name] <- word_weight
    }
    person
}

clustering <- function(){
    result <- matrix(ncol = length(init_names()))
    cursor = mongo.find(mongo, ns = "linkedin.people", limit = 50L, skip = 0L)
    while (mongo.cursor.next(cursor)) {
        value = mongo.cursor.value(cursor)
        name <-  mongo.bson.value(value, "firstname")
        id <- mongo.oid.to.string(mongo.bson.value(value, "_id"))
        person <- create_person(value)
        result <- rbind(result, person)
        colnames(result)[ncol(result)] <- name
    }
    err <- mongo.cursor.destroy(cursor)
    #result <- result[,-1]
    
    #print(dim(result))
    #print(length(result[,1])) 
    #test <- cbind(result[,1], result[,2])
    #print(dim(test))
 
   # summary(knn(result, result, result[,1], k = 1))
    
   print(result)
    
    plot(result, main="people", ylab="weight", xlab="keywords")
   
}

mongo <- mongo.create()
if (!mongo.is.connected(mongo)){
    error("No connection to MongoDB")   
}

industry <- init_keywords("linkedin.industry", "industry", appear_limit)
skill <- init_keywords("linkedin.skill", "skills", appear_limit)
edu <- init_keywords("linkedin.edu", "educations", appear_limit)
position <- init_keywords("linkedin.positions", "positions", appear_limit)

clustering()

mongo.disconnect(mongo)
mongo.destroy(mongo)