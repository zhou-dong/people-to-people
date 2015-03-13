from pymongo import MongoClient
from nltk.stem.lancaster import LancasterStemmer
from nltk.stem import WordNetLemmatizer

st = LancasterStemmer()
wnl = WordNetLemmatizer()

def calculateCursorTime(self, total, limit):
    result = total / limit
return result if total % limit == 0 else result + 1

def calculateCursorTime(total, limit):
    result = total / limit
    if total % limit == 0 :
        return result
    else :
        return result + 1

def stemKeyword(keyword):
    try:
        tmp = wnl.lemmatize(keyword)
        return st.stem(tmp)
    except:
        print "stem exception: ",  keyword
        return keyword

def fetchKeywords(limit):
    print "begin to fetch keywords"
    result = {}
    total = ns_keyword.count()
    cursor_time = calculateCursorTime(total, limit)
    for x in range(0, cursor_time):
        begin = x * limit
        cursor = ns_keyword.find().skip(begin).limit(limit)
        for obj in cursor:
            result[obj["_id"]] = obj["weight"]
    print "finish fetch keyword"
    return result

def createPeople(limt):
    print "begin to generate people"
    total = ns_people.count()
    cursor_time = calculateCursorTime(total, limit)
    for x in range(0, cursor_time):
        begin = x * limit
        cursor = ns_people.find().skip(begin).limit(limit)
        for obj in cursor:
            user_id = obj["_id"]
            

    print "finish generate people"


limit = 1000

client = MongoClient()
db = client['linkedin']
ns_keyword = db["final_skills"]
ns_people = db["employee"]

keywords = fetchKeywords(limit)
keywords_length = len(keywords)

print keywords_length

client.close()

