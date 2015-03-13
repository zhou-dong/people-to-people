var mapFunction = function(){
    emit(this.stem, this.value);
} ;

var reduceFunction = function(key, values){
    var count = 0  ;
    values.forEach(function(value){
        count += value ;
    });
    return count ;
};

var finalizeFunction = function (key, reducedValue) {
        return reducedValue;
};

db.cleaned_skills.mapReduce( mapFunction, reduceFunction, {
//    limit: 1000,
    out: { reduce: "stem_skills" },
    finalize: finalizeFunction
});
