from pymongo import MongoClient
from cleanLine import CleanLine

clean_line = CleanLine()

client = MongoClient()
db = client['linkedin']
ns_people = db["employee"]

def cursor_time(total, limit):
    result = total / limit
    return result if total % limit == 0 else result + 1

def create_keywords(line):
    result = []
    for word in line:
        result += clean_line.execute(word)
    return result

def create_keywords_from_dict_list(dict_list):
    result = []
    for dicts in dict_list:
        for x in dicts:
            val = dicts[x]
            if isinstance(val, bool):
                continue        
            tmp = clean_line.execute(dicts[x])
            if None != tmp:
                result += tmp
    return result
            
count_no_skill = 0 
def create_skills(obj):
    global count_no_skill
    try:
        skills = obj["skills"]
        return create_keywords(skills)
    except:
        count_no_skill += 1

count_no_edu = 0
def create_educations(obj):
    global count_no_edu
    try:
        edus = obj["educations"]
        return create_keywords_from_dict_list(edus)
    except:
        count_no_edu += 1

count_no_position = 0
def create_positions(obj):
    global count_no_position
    try:
        positions = obj["positions"]
        return create_keywords_from_dict_list(positions)
    except:
        count_no_position += 1

count_no_industry = 0
def create_industry(obj):
    global count_no_industry
    try:
        industry = obj["industry"]
        print industry
        return clean_line.execute(industry)
    except:
        count_no_industry += 1

begin = 0 
limit = 100
cursor = ns_people.find().skip(begin).limit(limit)

for obj in cursor:
    user_id = obj["_id"]
 #   print create_skills(obj)
 #   print create_educations(obj)
 #   print create_positions(obj)
    print create_industry(obj)

print count_no_skill
print count_no_edu
print count_no_position
print count_no_industry

client.close()
