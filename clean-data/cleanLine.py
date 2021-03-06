# -*- coding: utf-8 -*-

import string
import nltk

from string import maketrans
from nltk.stem.lancaster import LancasterStemmer
from nltk.stem import WordNetLemmatizer

class CleanLine:

    def _init_(self):
        CleanLine.st = st
        CleanLine.wnl = wnl
        
    # remove punctuation and digits
    def cleanLine(self, line):
        if line == None or len(line) == 0:
            return
        str_input = string.punctuation + string.digits
        str_output = "" ;
        for x in range(0, len(str_input)):
            str_output += " "
        identify = string.maketrans(str_input, str_output)
        if isinstance(line, unicode):
            line = line.encode('UTF-8')
        return line.translate(identify, "")
        #return line.translate(identify, str_input)

    def wordTokener(self, line):
        if line == None or len(line) == 0:
            return
        return nltk.word_tokenize(line)

    def lowerWords(self, words):
        if words == None or len(words) == 0:
            return
        return [element.lower() for element in words]

    def removeWordByLength(self, words, length):
        if words == None or len(words) == 0:
            return
        return [x for x in words if len(x) > length]

    def calculateCursorTime(self, total, limit):
        result = total / limit
        return result if total % limit == 0 else result + 1

    def stemWords(self, words):
        if words == None or len(words) == 0:
            return
        return [self.stemWord(x) for x in words]

    def stemWord(self, keyword):
        try:
            #return nltk.RSLPStemmer().stem(keyword)
            #return nltk.PorterStemmer().stem(keyword)
            keyword = WordNetLemmatizer().lemmatize(keyword)
            return LancasterStemmer().stem(keyword)
        except:
            return None
            #print "stem exception: ",  keyword
            #return keyword

    def execute(self, line):
        line = self.cleanLine(line)
        line = self.wordTokener(line)
        line = self.lowerWords(line)
        line = self.removeWordByLength(line, 2)
        return self.stemWords(line)

#clean = CleanLine()
#print clean.execute("Jaw$ah*arlal\Nehru Techno&logical University")
