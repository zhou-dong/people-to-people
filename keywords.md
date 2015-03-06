1. We use the properties of skills to be keywords.
    - Method: Use map-reduce to generate data from mongodb.
    - Result: 
    
        ```json
        {
                "result" : "skills",
                "timeMillis" : 108007,
                "counts" : {
                    "input" : 2289109,
                    "emit" : 1925879,
                    "reduce" : 329585,
                    "output" : 166294
                },
                "ok" : 1
        }
        ```
    - Generated data example:

        ```json
        {
            "_id" : "\"Human Resource\"",
            "value" : 1
        }
        {
            "_id" : "\"Hunter & Farmer\" mentalities",
            "value" : 1
        }
        ```
        
    - Issue: 
        + Lots of descripions were long, can not match each other.    
    - Solution:
        + Use NLP method to clean the data.

2. Use Natural Language Processing method to `Clean Data`
    - Remove the invalid character. Like: "\"
        
        ```json
        {
            "_id" : "Human Resource",
            "value" : 1
        }
        {
            "_id" : "Hunter Farmer mentalities",
            "value" : 1
        }
        ```
        
    - lower case keywords, like: DATA, DAta, Data --&gt; data
    
        ```json
        {
            "_id" : "human resource",
            "value" : 1
        }
        {
            "_id" : "hunter farmer mentalities",
            "value" : 1
        }
        ```
        
    - Divided descripions of skill to single word as key word
        
        ```json
        {
            "_id" : "human",
            "value" : 1
        }
        {
            "_id" : "resource",
            "value" : 1
        }
        {
            "_id" : "hunter",
            "value" : 1
        }
        {
            "_id" : "farmer",
            "value" : 1
        }
        {
            "_id" : "mentalities",
            "value" : 1
        }
        ```
    - Tokenizer words, like: mining, mined --&gt; mine
        
        ```json
        {
            "_id" : "mentalities",
            "value" : 1
        }
        {
            "_id" : "mental",
            "value" : 1
        }
        ``` 
    
    - After that:
        + "DAta mining", "Data Mined", "Mining DATA" --&gt; data, mine
