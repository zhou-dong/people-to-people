var mapFunction = function(){
    var key = this.stem ;
    var value = { keyword: this._id, count: this.value} ;
    emit(key, value);
} ;

var reduceFunction = function(key, values){
    return JSON.stringify(values) ;
};

var finalizeFunction = function (key, reducedValue) {
        return reducedValue;
};

db.cleaned_skills.mapReduce( mapFunction, reduceFunction, {
//    limit: 1000,
    out: { reduce: "stemed_keywords" },
    finalize: finalizeFunction
});
