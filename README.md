# People To People Recommendation

## Basic Info

### Language:

- R : Statistics, Generate Graph
- Javascript: MongoDB Map-reduce
- Python: Token Normalization

### Prepraed Data

- Data Size: 2289109
- DB : MongoDB

### Used Categories

- Skills
- Positions
- Educations
- Compony or College Names

## Steps

### [1. Clean Data](https://github.com/zhou-dong/people-to-people/blob/master/clean-data.md)

1. Remove invalid characters
2. Lower case words

### [2. Generate Keywords](https://github.com/zhou-dong/people-to-people/blob/master/clean-data.md)

1. Word tokenizer
2. Token normalization

### 3. [Caculate keywords weight](https://github.com/zhou-dong/people-to-people/blob/master/calculate-weight.md)

- Method: Weight = TF * IDF

### 4. Improve: FT-Growth tree

+ For Cold start problem: Same Meaning Words (a way to fixed cold start problem).
+ If one person has just a few keywords, it is hard to recommendate people to them.
+ We generated same Meaning Words for them.
+ If two words appears together so frequency, we came assume they are same meaning.
+ In different categories, we have different same meaning words.

### 5. Repeat Step From 1-4 In Four category

 - We believe different keywords in different categories should have different weight.

### 6. Use category.keyword to represent every people
  - Every people is a vector represent by keywords {...}[0 or weight]
  - Example: person = {category1.keyword1, category1.keyword2,...category3.keyword4,...categoryN.keywordM}

### 7. Calculation the similarity of people to each other
  - Use ”cosine similarity” to calculate similarity
  - Each pair of people only compare once. We can use to method to do:
    + Use graph to figure out what should we do
    + Use book[] to book the pair have been compared

### 8. Store all the information into a table.
