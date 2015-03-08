var mapFunction = function(){
    if(this._id=="" || this._id==null || this._id == undefined || this._id ==" "){
        return ;
    }
    if (this.value > 1) {
        emit(this._id, this.value);
    }
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

db.stem_skills.mapReduce( mapFunction, reduceFunction, {
//    limit: 1000,
    out: { reduce: "final_skills" },
    finalize: finalizeFunction
});
