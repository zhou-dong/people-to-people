var mapFunction = function(){
    var key = this.stem ;
    var value = { keywords: this._id, count: this.value, counts: 0} ;
    emit(key, value);
} ;

var reduceFunction = function(key, values){
    var keyword = JSON.stringify(values);
    var length = 0;
    try {
        var json = JSON.parse(keyword);
        length += json.length ;
    } catch(e) {
    }
    var result = {counts: length, keywords: keyword};
    return result ;
};

var finalizeFunction = function (key, reducedValue) {
        return reducedValue;
};

db.cleaned_skills.mapReduce( mapFunction, reduceFunction, {
//    limit: 1000,
    out: { reduce: "stemed_keywords" },
    finalize: finalizeFunction
});
