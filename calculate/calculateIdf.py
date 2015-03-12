# -*- coding: utf-8 -*-

import math

from pymongo import MongoClient

def cursor_time(total, limit):
    result = total / limit
    return result if total % limit == 0 else result + 1

def totalPeople():
    return ns_people.count()

def batchUpdate(time, limit, total_peopel): 
    begin = time * limit 
    cursor = ns_words.find().skip(begin).limit(limit)
    for obj in cursor:
        word_id = obj["_id"]
        frequency = dictionary[word_id]
        obj["idf"] = math.log10(total_peopel / frequency)
        obj["weight"] = obj["tf"] * obj["idf"]
        ns_words.update({"_id": word_id}, obj, True)
    print begin + limit, "finish"

client = MongoClient()
db = client['linkedin']
ns_people = db["people"]

dictionary = {}
def initDict():
    print "begin to load dict"
    total_count_dict = ns_people.count()
    dict_cursor_time = cursor_time(total_count_dict, limit)
    for time in range(0, dict_cursor_time):
        begin = time * limit
        cursor = ns_people.find().skip(begin).limit(limit)
        for obj in cursor:
            dictionary[obj["_id"]] = obj["value"]
    print "finish load dict"

def checkUpdate(times, limit):
    for time in range(0, times):
        begin = time * limit 
        cursor = ns_words.find().skip(begin).limit(limit)
        for obj in cursor:
            if obj["idf"] == None:
                print obj["_id"], "not update"

def executeUpdate(times, limit, total_peopel):
    for x in range(0, times):
        batchUpdate(x, limit, total_peopel)

limit = 100
def execute():
    print "begin to update"
    try:
       total = ns_words.count()
       times = cursor_time(total, limit)
       initDict()
       total_peopel = totalPeople()
       executeUpdate(times, limit, total_peopel)
       checkUpdate(times, limit)
    except Exception as e:
        print str(e)
    finally:
        client.close()
        print "client closed"

#ns_words = db["skill"]
#ns_words = db["edu"]
#ns_words = db["industry"]
ns_words = db["positions"]

#ns_people = db["skill_people"]
#ns_people = db["edu_people"]
#ns_people = db["industry_people"]
ns_people = db["positions_people"]

execute()
