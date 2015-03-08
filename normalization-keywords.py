# -*- coding: utf-8 -*-

from pymongo import MongoClient
from nltk.stem.lancaster import LancasterStemmer

st = LancasterStemmer()

client = MongoClient()
db = client['linkedin']
collection = db['cleaned-skills']

def calculateCursorTime(limit):
    totalCount =  collection.count()
    result = totalCount / limit
    if totalCount % limit == 0:
        return result 
    else :
        return result + 1

def isUpdate(obj, keyword):
    try:
        if(None==obj["stem"]):
            print keyword
    except:
        print keyword

def insertStemWord(time):
    begin = time * limit
    cursor = collection.find().skip(begin).limit(limit)
    for obj in cursor :
        keyword = obj["_id"]
        isUpdate(obj, keyword)
        try:
            stem_keyword = st.stem(keyword)
        except:
            print "stem exception: ",  keyword
            stem_keyword = keyword
        obj["stem"] = stem_keyword
        collection.update({'_id': keyword}, obj, True)
    print (begin + limit), "finished"

limit = 1000

for x in range(0, calculateCursorTime(limit)):
    insertStemWord(x)

client.close()
