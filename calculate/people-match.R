library(rmongodb)
library(lsa)
library(SnowballC)

Sys.setenv(LANG = "en")

init_keywords <- function(ns, prefix, appear_limit){
    result <- vector()
    names <- vector()
    time <- getCursorTime(MongoUtil(collection=ns), mongo, fetch_size)
    for(x in 1: time){
        begin = (x - 1) * fetch_size
        namespace = paste("linkedin", ns, sep=".")
        cursor = mongo.find(mongo, namespace, limit = fetch_size, skip = begin)
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

create_people_matrix <- function(){
    people <- matrix(nrow = length(init_names()))
    cursor = mongo.find(mongo, ns = "linkedin.people", limit = 5L, skip = 0L)
    while (mongo.cursor.next(cursor)) {
        value = mongo.cursor.value(cursor)
        name <-  mongo.bson.value(value, "firstname")
        id <- mongo.oid.to.string(mongo.bson.value(value, "_id"))
        person <- create_person(value)
        people <- cbind(people, person)
        colnames(people)[ncol(people)] <- name
    }
    err <- mongo.cursor.destroy(cursor)
    people <- people[,-1]
    result <- cosine(people)
    people_index = 5
    x_names <- colnames(result)
    print(x_names)
    plot(result[,people_index], main=rownames(result)[people_index], xlab="people", ylab="weight", col="red", xlim = c(1,6))
    text(result[,people_index], labels=x_names, cex=1, pos=4, col="blue")
    #plot(result, main="cosine similarity", ylab="weight", xlab="weight")
    #find_commons(x_names, people[,1], people[,2], people[,3], people[,4], people[,5])
    #p1 <- people[,1]
    #p1 <- p1[p1>0]
    #print(p1)
    #p2 <- people[,2]
    #p2 <- p2[p2>0]
    #print(p2)
    #plot(p1, xlab="keywords", ylab="weight", main=x_names[1], col="red")
    #text(p1, labels=names(p1), cex=1, pos=4, col="blue")
}

find_commons <- function(names, p1, p2, p3, p4, p5){
    print(names[2])
    print(find_common(p1, p2))
    print(names[3])
    print(find_common(p1, p3))
    print(names[4])
    print(find_common(p1, p4))
    print(names[5])
    print(find_common(p1, p5))
}

find_common <- function(p1, p2){
    result <- p1[p1==p2]
    result <- result[result>0]
}

mongo <- mongo.create()
if (!mongo.is.connected(mongo)){
    error("No connection to MongoDB")   
}

fetch_size = 1000
appear_limit = 50

ns_people = "linkedin.people"

industry <- init_keywords("industry", "industry", appear_limit)
skill <- init_keywords("skill", "skills", appear_limit)
edu <- init_keywords("edu", "educations", appear_limit)
position <- init_keywords("positions", "positions", appear_limit)

create_people_matrix()

mongo.disconnect(mongo)
mongo.destroy(mongo)