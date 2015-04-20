Sys.setenv(LANG = "en")

library(rmongodb)
library(class)
library(igraph)
library(ElemStatLearn)

fetch_size = 1000
threshold = 0.06

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

clustering <- function(){
    result <- matrix(nrow = length(init_names()))
    cursor = mongo.find(mongo, ns = "linkedin.people", limit = 6L, skip = 0L)
    while (mongo.cursor.next(cursor)) {
        value = mongo.cursor.value(cursor)
        name <-  mongo.bson.value(value, "firstname")
        id <- mongo.oid.to.string(mongo.bson.value(value, "_id"))
        person <- create_person(value)
        result <- cbind(result, person)
        colnames(result)[ncol(result)] <- name
    }
    err <- mongo.cursor.destroy(cursor)
    result <- result[,-1]
    
    result.features = result
    View(result.features)

    results <- kmeans(result.features, 3)
    print(results)
    plot(result[,4], result[,2], col=results$cluster, xlab = "x weight", ylab = "y weight", main="Clustering")
}

mongo <- mongo.create()
if (!mongo.is.connected(mongo)){
    error("No connection to MongoDB")   
}

industry <- init_keywords("industry", "industry", threshold)
skill <- init_keywords("skill", "skills", threshold)
edu <- init_keywords("edu", "educations", threshold)
position <- init_keywords("positions", "positions", threshold)

clustering()

mongo.disconnect(mongo)
mongo.destroy(mongo)