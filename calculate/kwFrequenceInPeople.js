# Keywords appear in how many people

var mapFunction = function(){
//    var values = this.skills;
//    var values = this.educations
//    var values = this.positions
    var values = this.industry
    var user_id = this._id
    if (values != null) {
        values.forEach(function(val){
            if (val != null && val != "null"){
                emit(val, user_id + "-") ;
            }
        });
    }
} ;

var reduceFunction = function(key, values){
    var result = "" ;
    values.forEach(function(val){
        result +=  val;
    });
    return result ;
};

var finalizeFunction = function (key, value) {
    var result = [];
    var json = {};
    var list = value.split("-");
    for(var i = 0; i < list.length; i++){
        var tmp = list[i] ;
        if(tmp == ""){
            continue;
        }
        if(!json[tmp]){
            result.push(tmp);
            json[tmp] = 1;
         } 
    }
    return result.length;
//return {ids:list, useful: result};
};

db.people.mapReduce( mapFunction, reduceFunction, {
//    out: { reduce: "skill_people" },
//    out: { reduce: "edu_people" },
//    out: { reduce: "positions_people" },
    out: { reduce: "industry_people" },
    finalize: finalizeFunction
});
