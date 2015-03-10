library(rmongodb)
#Sys.setenv(LANG = "en")

mongo <- mongo.create()
if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")

sort = mongo.bson.buffer.create()
mongo.bson.buffer.append(sort, "weight", 1L)
sort = mongo.bson.from.buffer(sort)

counts <- vector()
names <- vector()
cursor = mongo.find(mongo, ns = "linkedin.final_skills", limit = 15L, skip = 0L, sort = sort)
while (mongo.cursor.next(cursor)) {
    value = mongo.cursor.value(cursor)
    names <- c(names, mongo.bson.value(value, '_id'))
    counts <- c(counts, mongo.bson.value(value, 'weight'))
    print(value)
}
err <- mongo.cursor.destroy(cursor)

mongo.disconnect(mongo)
mongo.destroy(mongo)

barplot(counts,col=rainbow(15L), main="Best Stems", ylab = "Count", beside=TRUE ,names.arg=names)