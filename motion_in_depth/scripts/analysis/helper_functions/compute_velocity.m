function res = compute_velocity(res)
%
% take eye position data and convert to velocity

for x = 1:length(res.trials.subj)

    spacing = 1/res.el.sampleRate;
    
    keyboard
    
    % monocular angular velocity
    res.trials.LExAngVelo{x} = to_velocity(res.trials.LExAng{x},spacing);
    res.trials.LEyAngVelo{x} = to_velocity(res.trials.LEyAng{x},spacing);
    
    res.trials.RExAngVelo{x} = to_velocity(res.trials.RExAng{x},spacing);
    res.trials.REyAngVelo{x} = to_velocity(res.trials.REyAng{x},spacing);
    
    % binocular angular velocity
    res.trials.vergenceHVelo{x} = to_velocity(res.trials.vergenceH{x},spacing);
    res.trials.versionHVelo{x} = to_velocity(res.trials.versionH{x},spacing);
    
    % predictions (just horizontal)
    res.trials.predictionLEVelo{x} = to_velocity(res.trials.predictionLE{x},spacing);
    res.trials.predictionREVelo{x} = to_velocity(res.trials.predictionRE{x},spacing);

end

function velo = to_velocity(x,spacing)
%
%

velo = gradient(x,spacing);