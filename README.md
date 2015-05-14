# people to people

### Language

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
- Industry

## steps:

### 1. Clean Data

1. Remove invalid characters
2. Lower case words

### 2. Divided to 4  category

- Skill
- Position
- Education
- Industry

### 3. Generate Keywords

1. Word tokenizer
2. Token normalization

### 4. Caculate keywords weight

- Method: Weight = TF * IDF

<!--
### 5. Improve: Same Meaning Words 

+ Method: FT-Growth tree
+ For Cold start problem: Same Meaning Words (a way to fixed cold start problem).
+ If one person has just a few keywords, it is hard to recommendate people to them.
+ We generated same Meaning Words for them.
+ If two words appears together so frequency, we came assume they are same meaning.
+ In different categories, we have different same meaning words.

### 5. Repeat Step From 1-4 In Four category

 - We believe different keywords in different categories should have different weight.
-->

### 5. Represent person
 
 - Use category.keyword to represent
 - Each people is a vector by keywords {...}[0 or weight]
 - person = {category1.keyword1, category1.keyword2,...,categoryN.keywordM}

### 6. Calculate the similarity

 - use ”cosine similarity” to calculate similarity
 - use graph to figure out what should we do

### 7. Show Result

### 8. More

 - Because our result is sparse, so the result is not that great.
 - We can use SVD to Reduce the dimension to improve our result.
