# -*- coding: utf-8 -*-

import json

from pymongo import MongoClient
from cleanLine import CleanLine

clean_line = CleanLine()

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
        return clean_line.execute(industry)
    except:
        count_no_industry += 1

count_no_first_name = 0
def getFirstName(obj):
    global count_no_first_name
    try:
        return obj["first-name"]
    except:
        count_no_first_name += 1


count_no_last_name = 0 
def getLastName(obj):
    global count_no_last_name
    try:
        return obj["last-name"]
    except:
        count_no_last_name += 1

count_no_summary = 0
def createSummary(obj):
    global count_no_summary
    try:
        summary = obj["summary"]
        return clean_line.execute(summary)
    except:
        count_no_summary += 1

def batch_insert_peope(time, limit): 
    peoples = []
    begin = time * limit 
    cursor = ns_employ.find().skip(begin).limit(limit)
    for obj in cursor:
        user_id = obj["_id"]
        skills = create_skills(obj)
        edus = create_educations(obj)
        positions = create_positions(obj)
        industry = create_industry(obj)
        firstname = getFirstName(obj),
        lastname = getLastName(obj)
        summary = createSummary(obj)
        people = {"user_id": user_id, "skills": skills, 
                 "educations": edus, "positions":positions,
                 "industry":industry, "firstname":firstname[0],
                 "lastname":lastname,"summary":summary}
        peoples.append(people)
    ns_people.insert(peoples)
    print "finish: ", (begin + limit)

client = MongoClient()
db = client['linkedin']
ns_people = db["people"]
ns_employ = db["employee"]

total = 0
def insert_people():
    global total
    print "begin to insert"
    limit = 2000
    try:
        total = ns_employ.count()
        times = cursor_time(total, limit)
        for time in range(0, times):
            if time == 50:
                break
            batch_insert_peope(time, limit)
    except Exception as e:
        print str(e)
    finally:
        client.close()
        print "client closed"

insert_people()

print total
total = float(total)
print "no skills: ", count_no_skill, count_no_skill / total
print "no educations: ", count_no_edu, count_no_edu / total 
print "no positions: ", count_no_position, count_no_position / total
print "no industry: ", count_no_industry, count_no_industry / total
print "no firstname: ", count_no_first_name, count_no_first_name / total
print "no lastname: ", count_no_last_name, count_no_last_name / total
print "no summary: ", count_no_summary, count_no_summary / total
