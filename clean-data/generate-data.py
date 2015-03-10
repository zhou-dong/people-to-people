from pymongo import MongoClient


def cursor_time(total, limit):
    result = total / limit
    return result if total % limit == 0 else result + 1

def create_skill_keyword():

