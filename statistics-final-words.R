library(rmongodb)

mongo <- mongo.create()

if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")

db_skills <- "linkedin.final_skills"

query = mongo.bson.buffer.create()
query = mongo.bson.from.buffer(query)

fields = mongo.bson.buffer.create()
mongo.bson.buffer.append(fields, "value", TRUE)
fields = mongo.bson.from.buffer(fields)

counts <- vector("integer", length = 10000L)

limit_number = 1000L
all_words_count <- mongo.count(mongo, db_skills)

cursor_time = all_words_count / limit_number 
if(all_words_count %% limit_number != 0) 
    cursor_time = cursor_time + 1
cursor_time <- as.integer(cursor_time)

for(i in 1:cursor_time){
    skip_number = (i - 1) * limit_number
    cursor = mongo.find(mongo, ns = db_skills, query = query, fields = fields, limit = limit_number, skip = as.integer(skip_number))
    while (mongo.cursor.next(cursor)) {
        tmp = mongo.bson.to.list(mongo.cursor.value(cursor))
        length = (length(tmp))
        if(length==1)
            next
        count = as.integer(tmp[2])
        counts[count] <- counts[count] + 1
    }
    err <- mongo.cursor.destroy(cursor)
}

mongo.disconnect(mongo)
mongo.destroy(mongo)

counts <- counts[!is.na(counts)]
counts <- counts[counts > 0]
print(sum(counts))

count_labels <- round(counts/sum(counts) * 100, 1)
# pie(counts, main="Final Keywords", col=rainbow(length(cars)), labels=count_labels)
 pie(counts, main="Final Keywords", col=rainbow(length(cars)))