// Use map-reduce to generate "skill keywords" from mongodb
// DB name: linkedin, Collection Name: employee, category = skills

var mapFunction = function(){
    for(var i in this.skills){
        var key = this.skills[i] ;
        var value = Number(1) ;
        emit(key, value);      
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

db.employee.mapReduce( mapFunction, reduceFunction, {
//    limit: 1000,
    out: { reduce: "skills" },
    finalize: finalizeFunction
});
