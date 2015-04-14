util <- MongoUtil(collection="industry")
mongo <- mongo.create()

print(util)

total <- getTotalCount(util, mongo)
cursorTime <- getCursorTime(util, mongo, 2)

print(total)
print(cursorTime)
mongo.disconnect(mongo)
mongo.destroy(mongo)