# Keywords appear in category

var mapFunction = function(){
    var values = this.skills;
//    var values = this.educations;
//    var values = this.positions;
//    var values = this.industry;
    if (values != null) {
        values.forEach(function(val){
            if (val != null && val != "null"){
                emit(val, 1) ;
            }
        });
    }
} ;

var reduceFunction = function(key, values){
    var result = 0 ;
    values.forEach(function(val){
        result += val ;
    });
    return result ;
};

var finalizeFunction = function (key, reducedValue) {
    return reducedValue;
};

db.people.mapReduce( mapFunction, reduceFunction, {
    out: { reduce: "skill" },
//    out: { reduce: "edu" },
//    out: { reduce: "positions" },
//    out: { reduce: "industry" },
    finalize: finalizeFunction
});
