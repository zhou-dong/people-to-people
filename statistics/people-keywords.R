library(rmongodb)
Sys.setenv(LANG = "en")

init_keywords <- function(ns, prefix, threshold){
    result <- vector()
    names <- vector()
    time <- getCursorTime(MongoUtil(collection=ns), mongo, fetch_size)
    for(x in 1: time){
        begin = (x - 1) * fetch_size
        namespace = paste("linkedin", ns, sep=".")
        cursor = mongo.find(mongo, namespace, limit = fetch_size, skip = begin)
        while (mongo.cursor.next(cursor)) {
            value = mongo.cursor.value(cursor)
            weight <- mongo.bson.value(value,"weight")
            if(as.double(weight) < threshold)
                next
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

create_people_matrix <- function(){
    result <- matrix(ncol = length(init_names()))
    cursor = mongo.find(mongo, ns = "linkedin.people", limit = 5L, skip = 0L)
    while (mongo.cursor.next(cursor)) {
        value = mongo.cursor.value(cursor)
        firstname <-  mongo.bson.value(value, "firstname")
        #lastname <-  mongo.bson.value(value, "lastname")
        #rowname <- paste(firstname, lastname, sep=" ")
        person <- create_person(value)
        result <- rbind(result, person)
        rownames(result)[nrow(result)] <- firstname
    }
    err <- mongo.cursor.destroy(cursor)
    #r2 = result[2,]
    #r3 = result[3,]
    #r4 = result[4,]
    #r5 = result[5,]
    r6 = result[6,]
    plot(r6, main=rownames(result)[6], ylab = "Weight")
    #plot(result, main="people")
    
    print(dim(result))
}

mongo <- mongo.create()
if (!mongo.is.connected(mongo)){
    error("No connection to MongoDB")   
}

fetch_size = 1000
threshold = 0.06

ns_people = "linkedin.people"

industry <- init_keywords("industry", "industry", threshold)
skill <- init_keywords("skill", "skills", threshold)
edu <- init_keywords("edu", "educations", threshold)
position <- init_keywords("positions", "positions", threshold)

create_people_matrix()

print(length(names))

mongo.disconnect(mongo)
mongo.destroy(mongo)