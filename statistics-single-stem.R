library(rmongodb)
library(igraph)
#Sys.setenv(LANG = "en")

mongo <- mongo.create()
if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")

sort = mongo.bson.buffer.create()
mongo.bson.buffer.append(sort, "value.counts", -1L)
sort = mongo.bson.from.buffer(sort)

vertexs <- vector()
names <- vector()
weights <- vector()
cursor = mongo.find(mongo, ns = "linkedin.stemed_keywords", limit = 1L, skip = 14L, sort = sort)
while (mongo.cursor.next(cursor)) {
    value = mongo.cursor.value(cursor)
    stem <- mongo.bson.value(value, '_id')
    keys = mongo.bson.from.JSON(mongo.bson.value(value, 'value.keywords'))
    keyIterator = mongo.bson.iterator.create(keys)
    while (mongo.bson.iterator.next(keyIterator)){
        keyObj = mongo.bson.iterator.value(keyIterator)
        names <- c(names, unname(keyObj["keywords"]))
        weight <- as.integer(keyObj["count"])
        weights <- c(weights, log(weight))
    }
}
err <- mongo.cursor.destroy(cursor)

mongo.disconnect(mongo)
mongo.destroy(mongo)

length <- length(names)
for (i in 1: length){
    vertexs <- c(vertexs, i)
    vertexs <- c(vertexs, length+1L)  
}

names <- c(names, stem)
names <- unlist(names)

print(vertexs)
print(names)
print(weights)

g <- graph(vertexs)
V(g)$color <- rainbow(length+1L)
V(g)$name <- names
E(g)$weight <- weights

summary(g)

plot(g, edge.width=E(g)$weight)