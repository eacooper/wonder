function res = convert_data_values(res)
%
% convert href to vergence, etc

%cellfun(@(x) x*,res.trials.LEx,'un',0);

for x = 1:length(res.trials.subj)
    res.trials.LExCm{x} = res.trials.LEx{x}.*res.el.href2cm;
    res.trials.LEyCm{x} = res.trials.LEy{x}.*res.el.href2cm;
    res.trials.RExCm{x} = res.trials.REx{x}.*res.el.href2cm;
    res.trials.REyCm{x} = res.trials.REy{x}.*res.el.href2cm;
    
    res.trials.LExAng{x} = convert_screen_to_deg(res.trials.LExCm{x},res.el,res.trials.ipd(x));
    res.trials.LEyAng{x} = convert_screen_to_deg(res.trials.LEyCm{x},res.el,res.trials.ipd(x));
    res.trials.RExAng{x} = convert_screen_to_deg(res.trials.RExCm{x},res.el,-res.trials.ipd(x));
    res.trials.REyAng{x} = convert_screen_to_deg(res.trials.REyCm{x},res.el,-res.trials.ipd(x));
    
    res.trials.vergenceH{x}    = res.trials.LExAng{x} - res.trials.RExAng{x};
    res.trials.vergenceV{x}    = res.trials.LEyAng{x} - res.trials.REyAng{x};
    
    res.trials.versionH{x}    = mean(cat(3,res.trials.LExAng{x},res.trials.RExAng{x}),3);
    res.trials.versionV{x}    = mean(cat(3,res.trials.LEyAng{x},res.trials.REyAng{x}),3);
end
