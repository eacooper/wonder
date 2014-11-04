function [Eall,Sall] = combine_multiple_subjects(pathname, filename)


Etmp.condition = [];
Etmp.trial = [];
Etmp.isNear = [];
Etmp.isCorrect = [];
Etmp.foundSaccade = [];
Etmp.blinking = [];

Etmp.trackFix = [];
Etmp.rampSize = [];
Etmp.probes = [];

Etmp.LExAng = [];
Etmp.LEyAng = [];
Etmp.RExAng = [];
Etmp.REyAng = [];

Etmp.vergenceH = [];
Etmp.vergenceV = [];

Etmp.versionH = [];
Etmp.versionV = [];

Etmp.subj = [];

for f = 1:length(filename)
    t = load([pathname filename{f}]);
    
    Etmp.subj = [Etmp.subj repmat(f,1,length(t.Eall.isNear))];
    
    Etmp.condition = [Etmp.condition t.Eall.condition];
    Etmp.trial = [Etmp.trial t.Eall.trial];
    Etmp.isNear = [Etmp.isNear t.Eall.isNear];
    Etmp.isCorrect = [Etmp.isCorrect t.Eall.isCorrect];
    Etmp.foundSaccade = [Etmp.foundSaccade t.Eall.foundSaccade];
    
    Etmp.blinking = [Etmp.blinking t.Eall.blinking];
    
    Etmp.trackFix = [Etmp.trackFix t.Eall.trackFix];
    Etmp.rampSize = [Etmp.rampSize t.Eall.rampSize];
    Etmp.probes = [Etmp.probes t.Eall.probes];
    
    Etmp.LExAng = [Etmp.LExAng t.Eall.LExAng];
    Etmp.LEyAng = [Etmp.LEyAng t.Eall.LEyAng];
    Etmp.RExAng = [Etmp.RExAng t.Eall.RExAng];
    Etmp.REyAng = [Etmp.REyAng t.Eall.REyAng];
    
    Etmp.vergenceH = [Etmp.vergenceH t.Eall.vergenceH];
    Etmp.vergenceV = [Etmp.vergenceV t.Eall.vergenceV];
    
    Etmp.versionH = [Etmp.versionH t.Eall.versionH];
    Etmp.versionV = [Etmp.versionV t.Eall.versionV];
end

Eall = Etmp;
Sall = t.Sall;

Sall.subj = 'all';