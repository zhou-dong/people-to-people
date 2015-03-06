---
layout: page
title: key words
tagline: -- Just do it, it will pay!
---
{% include JB/setup %}

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
        {
            "_id" : "\"ITIL\" Information technology Infrastructure Library",
            "value" : 1
        }
        {
            "_id" : "\"Liquidación de Sueldos y Jornales y cargas Sociales\"UBA",
            "value" : 1
        }
        {
            "_id" : "\"Médiation singulière\" Coach certifié CNAM",
            "value" : 1
        }
        {
             "_id" : "#Fluent English and Indonesian Language",
            "value" : 1
        }
        ```
    - Issue: 
        + Lots of descripions were long, can not match each other.
        + Have invalid character like: "\"
    - Solution:
        + Use NLP method to clean the data.

2. Use Natural Language Processing method to clean the data
    - Remove the invalid character
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
    - Divided descripions of skill to single word as key word
        ```json
        {
            "_id" : "Human",
            "value" : 1
        }
        {
            "_id" : "Resource",
            "value" : 1
        }
        {
            "_id" : "Hunter",
            "value" : 1
        }
        {
            "_id" : "Farmer",
            "value" : 1
        }
        {
            "_id" : "mentalities",
            "value" : 1
        }
        ```
    - Tokenizer words
