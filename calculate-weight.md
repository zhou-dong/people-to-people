# Calculate Keywords Weight

- TF(t) = (Number of times term t appears in one category) / (Total number of terms in the catefgory)
- TF(t) = (Number of times term t appears in one category) / (Most frequent times a word appears in same category).
- IDF(t)= logarithmic(Total number of persons / Number of persons with term t in it)

Height Weight

| Keyword | market |microsoft |develop | busy| plan | analys | off | serv | design | custom | project | rel | fin | med | strategy |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Count | 52188 | 52555 | 50644 | 44146 | 42731 | 38805 | 37878 | 37292 | 35346 | 30470 | 29760 | 27543 | 26270 | 24878 | 24878 |
| Weight |36.785665 |36.781846 |36.781428 |36.382975 |36.209036 |35.547924 |35.351517 |35.219041 | 34.731434 |33.164123 |32.891472 |31.961031 |31.369897 |30.673079 |30.263969 |

Lowest Weight

| Keyword | c8 |conceptualización |cu | f3| fc | inventivaoriginalidadrelación | 00 | 2h | 3h | 57 | 58 | 62 | 89 | 8x | 
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Count | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 
| Weight |0.012231 |0.012231 |0.012231 |0.012231 |0.012231 |0.012231 |0.012231 |0.012231 | 0.012231 |0.012231 |0.012231 |0.012231 |0.012231 |0.012231 |0.012231 |

```json
{
	"result" : "skill",
	"timeMillis" : 1211,
	"counts" : {
		"input" : 5167,
		"emit" : 76528,
		"reduce" : 8880,
		"output" : 5448
	},
	"ok" : 1
}
{
	"result" : "edu",
	"timeMillis" : 1412,
	"counts" : {
		"input" : 5167,
		"emit" : 64226,
		"reduce" : 9248,
		"output" : 9041
	},
	"ok" : 1
}
{
	"result" : "positions",
	"timeMillis" : 7923,
	"counts" : {
		"input" : 5167,
		"emit" : 507660,
		"reduce" : 72555,
		"output" : 34133
	},
	"ok" : 1
}
{
	"result" : "industry",
	"timeMillis" : 204,
	"counts" : {
		"input" : 5167,
		"emit" : 10401,
		"reduce" : 730,
		"output" : 494
	},
	"ok" : 1
}
{
	"result" : "skill_people",
	"timeMillis" : 1473,
	"counts" : {
		"input" : 5167,
		"emit" : 76528,
		"reduce" : 10602,
		"output" : 5448
	},
	"ok" : 1
}
```
