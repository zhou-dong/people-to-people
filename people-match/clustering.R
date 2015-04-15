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
    result <- matrix(ncol = length(init_names()))
    cursor = mongo.find(mongo, ns = "linkedin.people", limit = 318L, skip = 0L)
    while (mongo.cursor.next(cursor)) {
        value = mongo.cursor.value(cursor)
        name <-  mongo.bson.value(value, "firstname")
        id <- mongo.oid.to.string(mongo.bson.value(value, "_id"))
        person <- create_person(value)
        result <- rbind(result, person)
        colnames(result)[ncol(result)] <- name
    }
    err <- mongo.cursor.destroy(cursor)
    result <- result[-1,]
    
    test <- cbind(result[,1], result[,2])
    train <- cbind(result[,4], result[,5])
    
    mod15 <- knn(result, result, result[2,], k = 15, prob=TRUE)
    summary(mod15)
    
    plot(result)
    plot(result, col=ifelse(result[,1]==1,"red", "green"),xlab="x1", ylab="x2")
    
    str(mod15)
    prob <- attr(mod15, "prob")
    prob <- ifelse( mod15=="1", prob, 1-prob)
    
    matrixLength = length(result[1,])

    prob15 <- matrix(prob, matrixLength, matrixLength)
    
    contour(seq(result[2,]), seq(result[11,]), prob15, levels=0.5, labels="", xlab="x1", ylab="x2", main="15-nearest neighbour")
    points(result, col=ifelse(g==1, "red", "green"))
    
    
    print(result[2,])
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