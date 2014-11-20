function res = convert_data_values(res)
%
% convert href to vergence, etc

res.trials.LExCm = res.trials.LEx.*res.el.href2cm;
res.trials.LEyCm = res.trials.LEy.*res.el.href2cm;
res.trials.RExCm = res.trials.REx.*res.el.href2cm;
res.trials.REyCm = res.trials.REy.*res.el.href2cm;

res.trials.LExAng = convert_screen_to_deg(res.trials.LExCm,res.el,res.trials.ipd);
res.trials.LEyAng = convert_screen_to_deg(res.trials.LEyCm,res.el,res.trials.ipd);
res.trials.RExAng = convert_screen_to_deg(res.trials.RExCm,res.el,-res.trials.ipd);
res.trials.REyAng = convert_screen_to_deg(res.trials.REyCm,res.el,-res.trials.ipd);

res.trials.vergenceH    = res.trials.LExAng - res.trials.RExAng;
res.trials.vergenceV    = res.trials.LEyAng - res.trials.REyAng;

res.trials.versionH    = mean(cat(3,res.trials.LExAng,res.trials.RExAng),3);
res.trials.versionV    = mean(cat(3,res.trials.LEyAng,res.trials.REyAng),3);
