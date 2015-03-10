# -*- coding: utf-8 -*-

from pymongo import MongoClient
from nltk.stem.lancaster import LancasterStemmer
from nltk.stem import WordNetLemmatizer

st = LancasterStemmer()
wnl = WordNetLemmatizer()

client = MongoClient()
db = client['linkedin']
collection = db['cleaned_skills']

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
            print "None stem: ", keyword
    except:
        print "error: ", keyword

def stemKeyword(keyword):
    try:
        tmp = wnl.lemmatize(keyword)
        return st.stem(tmp)
    except:
        print "stem exception: ",  keyword
        return keyword

def insertStemWord(time):
    begin = time * limit
    cursor = collection.find().skip(begin).limit(limit)
    for obj in cursor :
        keyword = obj["_id"]
        isUpdate(obj, keyword)
        obj["stem"] = stemKeyword(keyword)
        collection.update({'_id': keyword}, obj, True)
    print (begin + limit), "finished"

limit = 1000

for x in range(0, calculateCursorTime(limit)):
    insertStemWord(x)

client.close()
