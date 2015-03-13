# -*- coding: utf-8 -*- 
import os, sys, json, pymongo, logging
from pymongo import MongoClient

def get_files_path_from_dir(dir_path):
    files_path = []
    for file_name in read_files_name_from_dir(dir_path):
        files_path.append(os.path.join(dir_path, file_name))
    return files_path

def read_files_name_from_dir(dir_path):
    return os.listdir(dir_path)

def load_json_file(file_path):
    try:
        return json.load(open(file_path))
    except:
        print "it is not json file: " + file_path

def insert_into_mongo(dir_path):
    for file_path in get_files_path_from_dir(dir_path):
        json_object = load_json_file(file_path)
        if json_object == None:
            continue
        collection.insert(json_object)

dir_path = raw_input("please type dir name: ")
dir_path = "/Users/dongdong/Downloads/" + dir_path 

if os.path.exists(dir_path) == False:
    logging.warning(dir_path + " is not exists")
    sys.exit()

print "begin insert into mongo "

db = MongoClient()['linkedin']
collection = db['employee']

insert_into_mongo(dir_path)

# file_path = "/Users/dongdong/Downloads/1339943811/a-2.json"
