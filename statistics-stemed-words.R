library(rmongodb)
#Sys.setenv(LANG = "en")

mongo <- mongo.create()
if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")

sort = mongo.bson.buffer.create()
mongo.bson.buffer.append(sort, "value.counts", -1L)
sort = mongo.bson.from.buffer(sort)

counts <- vector()
stems <- vector()
cursor = mongo.find(mongo, ns = "linkedin.stemed_keywords", limit = 15L, skip = 0L, sort = sort)
while (mongo.cursor.next(cursor)) {
    value = mongo.cursor.value(cursor)
    stems <- c(stems, mongo.bson.value(value, '_id'))
    counts <- c(counts, mongo.bson.value(value, 'value.counts'))
}
err <- mongo.cursor.destroy(cursor)

mongo.disconnect(mongo)
mongo.destroy(mongo)

print(counts)

barplot(counts,col=rainbow(15L), main="Best Stems", ylab = "Count", beside=TRUE ,names.arg=stems)
