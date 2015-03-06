library(rmongodb)
library(plyr)

mongo<-mongo.create()

if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")

# DB name: linkedin; Collection name: employee
employee = "linkedin.employee"

employee_count = mongo.count(mongo, DBNS)

message("Count of Employee: ", employee_count)

query = mongo.bson.buffer.create()
#mongo.bson.buffer.append(query, "last-name", "A")
query = mongo.bson.from.buffer(query)

property = "skills"
skills = "linkedin.skills"

fields = mongo.bson.buffer.create()
mongo.bson.buffer.append(fields, property, TRUE)
fields = mongo.bson.from.buffer(fields)

print(fields)

cursor = mongo.find(mongo, ns = DBNS, query = query, fields = fields, limit = 100L)
while (mongo.cursor.next(cursor)) {
    list = mongo.bson.to.list(mongo.cursor.value(cursor))
    length = (length(list))
    if(length==1)
        next
    attributes = list[2]
    for(variable in attributes) {
        obj = mongo.bson.buffer.create()
        mongo.bson.buffer.append(obj, variable, 1)
        obj = mongo.bson.from.buffer(obj)
        print(obj)
        print(class(obj))
        mongo.update(mongo = mongo, ns = skills, obj,objNew=1)
        next
       # print(class(obj))
       # print(obj)
       # 
    }
}

mongo.disconnect(mongo)
mongo.destroy(mongo)