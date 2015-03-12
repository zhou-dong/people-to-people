library(rmongodb)
Sys.setenv(LANG = "en")

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

total_count <- function(ns){
    mongo.count(mongo, ns)
}

cursor_time <- function(total, size){
    cursor_time =  total / size 
    if(total %% size != 0) 
        cursor_time = cursor_time + 1
    cursor_time <- as.integer(cursor_time)
}

new_person <- function(){
    name <- c(names(industry), names(skill))
    name <- c(name, names(edu))
    name <- c(name, names(position))
    person <- vector(mode = "numeric",length=length(name))
    person <- setNames(person, name)
}

create_person <- function(obj){
    
}


mongo <- mongo.create()
if (!mongo.is.connected(mongo)){
    error("No connection to MongoDB")   
}

fetch_size = 1000
appear_limit = 5

ns_people = "linkedin.people"

industry <- init_keywords("linkedin.industry", "industry", appear_limit)
skill <- init_keywords("linkedin.skill", "skill", appear_limit)
edu <- init_keywords("linkedin.edu", "edu", appear_limit)
position <- init_keywords("linkedin.positions", "position", appear_limit)

person <- new_person()
print(person)

mongo.disconnect(mongo)
mongo.destroy(mongo)