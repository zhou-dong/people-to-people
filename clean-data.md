# Data Operation

## Prepared Data

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
        
- Issue: Lots of descripions were long, can not match each other.
    
    | Count | Percent | Description |
    | :---: | :---: |:---|
    | 1     | 80.6% | 80.6% keywords only appear once |
    | 2     | 5.8%  | 5.8% of keywords appear twice |
    | 3     | 1.4%  | 1.4% of keywords appear three time |
    |other  | 12.2% | other keywords total appear 12.2% |
    
    <div style="text-align: center">
    	<img alt="keywords-data" src="img/original-keywords-data.png"/>
    	<img alt="keywords-percent" src="img/original-keywords-percent.png"/>
    </div>
    
- Solution:
    + Use NLP method to clean the data.

## Clean Data

- Remove the invalid character. Like: "\, &, $, %"
    
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
    
- `Lower Case Words`, like: DATA, DAta, Data --&gt; data
    
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
 
## Generate keywords

- `Word Tokenizer`
        
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

- Result:

	```json
	{
		"result" : "cleaned-skills",
		"timeMillis" : 18346,
		"counts" : {
			"input" : 166294,
			"emit" : 609956,
			"reduce" : 98779,
			"output" : 65165
		},
		"ok" : 1
	}
	```
    
    | Count | Percent | Description |
    | :---: | :---: |:---|
    | 1     | 54% | 54% keywords appear once |
    | 2     | 12.4%  | 12.4% of keywords appear twice |
    | 3     | 6%  | 6% of keywords appear three time |
    |other  | 27.6% | other keywords total appear 27.5% |
    
    <div style="text-align: center">
    	<img alt="keywords-data" src="img/cleaned-keywords-data.png"/>
    	<img alt="keywords-percent" src="img/cleaned-keywords-percent.png"/>
    </div>
    
    
- `Token Normalization` like: mining, mined --&gt; mine
    
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
- Result:
	
	```json
	{
		"result" : "stem_skills",
		"timeMillis" : 10073,
		"counts" : {
			"input" : 65165,
			"emit" : 65165,
			"reduce" : 8002,
			"output" : 56439
		},
		"ok" : 1
	}
	```

	| Count | Percent | Description |
    | :---: | :---: |:---|
    | 1     | 16.9% | 16.9% keywords appear once |
    | 2     | 43.3%  | 43.3% of keywords appear twice |
    | 3     | 9.4%  | 9.4% of keywords appear four time |
    |other  | 30.4% | other keywords total appear 30.4% |
    
    <div style="text-align: center">
    	<img alt="keywords-data" src="img/stem-keywords-data.png"/>
    	<img alt="keywords-percent" src="img/stem-keywords-percent.png"/>
    </div>
    
- Remove the word only appear once (which means those words no useful for recommendation)

	```json
	{
		"result" : "final_skills",
		"timeMillis" : 2557,
		"counts" : {
			"input" : 56439,
			"emit" : 22496,
			"reduce" : 0,
			"output" : 22496
		},
		"ok" : 1
	}
	```
    
    <div style="text-align: center">
    	<img alt="keywords-percent" src="img/final-keywords-data.png"/>
    	<img alt="keywords-percent" src="img/final-keywords-percent.png"/>
    </div>

- Analyze of Stemed Words:

	```json
	{
		"result" : "stemed_keywords",
		"timeMillis" : 8544,
		"counts" : {
			"input" : 71941,
			"emit" : 71941,
			"reduce" : 8353,
			"output" : 54772
		},
		"ok" : 1
	}
	```

<img alt="keywords-percent" src="img/best-stems.png"/>

- Example:

<img alt="keywords-percent" src="img/stem-program.png"/>
<img alt="keywords-percent" src="img/stem-person.png"/>

