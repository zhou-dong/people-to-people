var mapFunction = function(){
    var user_id = this._id;
    var skills = this.skills;
    if (skills != null) {
        skills.forEach(function(skill){
            emit(skill, {"cat": "skill", "person": user_id}) ;
        });
    }
    var positions = this.positions;
    if (positions != null) {
        positions.forEach(function(position){
            emit(position, {"cat": "positions", "person": user_id}) ;
        });
    }
    var summary = this.summary ;
    if (summary != null) {
        summary.forEach(function(sum){
            emit(sum, {"cat": "summary", "person": user_id})
        });
    }
    var educations = this.educations;
    if (educations != null){
        educations.forEach(function(edu){
            emit(edu, {"cat": "educations", "person":user_id})
        }) ;
    }
} ;

var reduceFunction = function(key, values){
    var skill_count = 0 ;
    var pos_count = 0;
    var summary_count = 0;
    var edu_count = 0;
    for(var x = 0; x< values.length; x++){
        var val = values[x] ;
        if("skill" == val.cat){
            skill_count = skill_count + 1 ;
        } if ("positions" == val.cat) {
            pos_count = pos_count + 1;
        } if ("summary" == val.cat) {
            summary_count = summary_count +1;
        } if ("educations" == val.cat) {
            edu_count = edu_count + 1;
        }
    }
    return {skill: skill_count, position: pos_count, summary: summary_count, education: edu_count};
};

var finalizeFunction = function (key, reducedValue) {
    return reducedValue;
};

db.people.mapReduce( mapFunction, reduceFunction, {
    limit: 1000,
    out: { reduce: "keywords" },
    finalize: finalizeFunction
});
