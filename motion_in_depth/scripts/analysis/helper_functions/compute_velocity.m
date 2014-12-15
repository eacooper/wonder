function res = compute_velocity(res)
%
% take eye position data and convert to velocity

for x = 1:length(res.trials.subj)

    res.trials.LExAngVelo{x} = diff(res.trials.LExAng{x});
    res.trials.LEyAngVelo{x} = diff(res.trials.LEyAng{x});
    
    res.trials.RExAngVelo{x} = diff(res.trials.RExAng{x});
    res.trials.REyAngVelo{x} = diff(res.trials.REyAng{x});

end