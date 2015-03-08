import nltk
from nltk.probability import ConditionalFreqDist
from nltk.tokenize import word_tokenize

# nltk.download()

sent = "the the the dog dog some other words that we do not care about mining mined"
cfdist = ConditionalFreqDist()

#for word in word_tokenize(sent):
#    condition = len(word)
#    cfdist[condition][word] += 1


for word in word_tokenize(sent):
    print word
