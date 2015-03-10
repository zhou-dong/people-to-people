var mapFunction = function(){
    
    var reg = new RegExp(/\[|\~|\`|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\-|\_|\+|\=|\||\\|\[|\]|\{|\}|\;|\:|\,|\<|\.|\>|\/|\?\]|\“|\”/g) ;
    var keywords = this._id.replace(reg, " ");
    
    var reg0 = new RegExp('"',"g");
    keywords = keywords.replace(reg0," ") ;
    
    var reg1 = new RegExp("'","g");
    keywords = keywords.replace(reg1," ") ;
    
    keywords = keywords.split(" ");
    for(var i=0; i< keywords.length; i++){
        var keyword = keywords[i] ;
        keyword = keyword.toLowerCase() ;
        emit(keyword, this.value);
    };

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

db.skills.mapReduce( mapFunction, reduceFunction, {
//    limit: 1000,
    out: { reduce: "cleaned_skills" },
    finalize: finalizeFunction
});
