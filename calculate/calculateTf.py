# -*- coding: utf-8 -*-

from pymongo import MongoClient

def cursor_time(total, limit):
    result = total / limit
    return result if total % limit == 0 else result + 1

def maxCount():
    maxCountWord = ns.find().sort("value", -1).limit(1)[0]
    return maxCountWord["value"]

def batchUpdate(time, limit, max_count): 
    begin = time * limit 
    cursor = ns.find().skip(begin).limit(limit)
    for obj in cursor:
        val = obj["value"]
        obj["tf"] = val / max_count
        ns.update({"_id": obj["_id"]}, obj, True)
    print begin + limit, "finish"

client = MongoClient()
db = client['linkedin']

#ns = db["skill"]
#ns = db["edu"]
#ns = db["industry"]
ns = db["positions"]

def checkUpdate(times, limit):
    for time in range(0, times):
        begin = time * limit 
        cursor = ns.find().skip(begin).limit(limit)
        for obj in cursor:
            if obj["tf"] == None:
                print obj["_id"], "not update"

def executeUpdate(times, limit, max_count):
    for x in range(0, times):
        batchUpdate(x, limit,max_count)


def execute():
    print "begin to update"
    limit = 100
    try:
        total = ns.count()
        max_count = maxCount()
        times = cursor_time(total, limit)
        executeUpdate(times, limit, max_count)
        checkUpdate(times, limit)
    except Exception as e:
        print str(e)
    finally:
        client.close()
        print "client closed"


execute()
