# Filter useful data from original collection to new collection
# API for rmongodb: https://github.com/mongosoup/rmongodb

# add library
library(rmongodb)
library(plyr)

# connection with mongodb use R
mongo<-mongo.create(host="127.0.0.1")

if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")
# check is connection ok
# print(mongo.is.connected(mongo))

# show databases in MongoDB
print(mongo.get.databases(mongo))

# show collections in db of linkedin
print(mongo.get.database.collections(mongo, db = "linkedin"))

DBNS = "linkedin.employee"
# count of "linkedin.employee"
print(mongo.count(mongo, DBNS))

# define the query
query = mongo.bson.buffer.create()
#mongo.bson.buffer.append(query, "last-name", "A")
#mongo.bson.buffer.append(query, "first-name", "Amarnath Reddy")
# when complete, make object from buffer
query = mongo.bson.from.buffer(query)

# define the fields
fields = mongo.bson.buffer.create()
mongo.bson.buffer.append(fields, "skills", TRUE)
# when complete, make object from buffer
fields = mongo.bson.from.buffer(fields)

# create the cursor
cursor = mongo.find(mongo, ns = DBNS, query = query, fields = fields, limit = 100L)
#cursor = mongo.find(mongo, ns = DBNS, query = query, limit = 100L)
## iterate over the cursor
gids = data.frame(stringsAsFactors = FALSE)
while (mongo.cursor.next(cursor)) {
    # iterate and grab the next record
    # tmp = mongo.bson.to.list(mongo.cursor.value(cursor))
    tmp = mongo.cursor.value(cursor)
    print(tmp)
    # make it a dataframe
    # tmp.df = as.data.frame(t(unlist(tmp)), stringsAsFactors = F)
    # bind to the master dataframe
    # gids = rbind.fill(gids, tmp.df)
}

#query <- mongo.bson.from.JSON('{"first-name" : "Amark"}') ;
#cursor <- mongo.find(mongo, "linkedin.employee", query, limit = 5)
#while(mongo.cursor.next(cursor))
#    print(mongo.cursor.value(cursor))
#mongo.cursor.destroy(cursor)


mongo.disconnect(mongo)
mongo.destroy(mongo)