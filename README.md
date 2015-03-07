# people-to-people
People to people recommendation project with R language.
Use Skills, Positions, Educations, Compony or College Names as keywords to recommendate people to each other.

1. Generation all the keywords
  - From original data to generate keyword which we will use in our project. 
2. Clean Data
  - Natural Language Processing
  - Take off the "stop word" (we are not quite sure shall we do that)
    + a boy => boy
    + the picutre => picture
  - Tokenizer words (Data Mining, Data mined, data mine should have same meaning).
    + lower case words (DATA, DATa, DaTa, data) => data
    + tokenizer words (Mining, mined, mine) => mine
3. For Cold start problem: Same Meaning Words (a way to fixed cold start problem).
    + If one person has just a few keywords, it is hard to recommendate people to them.
    + We generated same Meaning Words for them.
    + If two words appears together so frequency, we came assume they are same meaning.
    + In different categories, we have different same meaning words.

4. Divided keywords to different categories.
  - We believe different keywords in different categories should have different weight.

5. Caculation the weight of the keywords in each category.
  - TF
  - IDF

6. Use category.keyword to represent every people
  - Every people is a vector represent by keywords {...}[0 or weight]
  - Example: person = {category1.keyword1, category1.keyword2,...category3.keyword4,...categoryN.keywordM}

7. Calculation the similarity of people to each other
  - Use ”cosine similarity” to calculate similarity
  - Each pair of people only compare once. We can use to method to do:
    + Use graph to figure out what should we do
    + Use book[] to book the pair have been compared

8. Store all the information into a table.
