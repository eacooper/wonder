function [res,dcnt] = responses_load_data(dcnt,dat,res,file)
%
% fill in response data

% data fields to fill in are two types, experiment-specific and
% trial-specific
fields_exp    = {'subj','exp_name','training','dispArcmin',...
    'stimRadDeg','dotSizeDeg','dotDensity',...
    'preludeSec','cycleSec'};
fields_trial     = {'condition','dynamics','direction','repeat',...
    'trialnum','resp','respCode','isCorrect','delayTimeSec'};

num_trials = length(dat.trials.condition);


% experiment-specific info
for f = 1:length(fields_exp)
    
    if isstr(dat.(fields_exp{f}))
        flist = repmat({dat.(fields_exp{f})},1,num_trials);
    else
        flist = repmat(dat.(fields_exp{f}),1,num_trials);
    end
    
    res.trials.(fields_exp{f})(dcnt:dcnt+num_trials-1) = flist;
    
end


% trial specific info
for f = 1:length(fields_trial)
    
    flist = dat.trials.(fields_trial{f});
    res.trials.([fields_trial{f} 'R'])(dcnt:dcnt+num_trials-1) = flist;
    
end

% stimulus predictions

v_half_angle = atand(((res.ipd/2))./res.el.href_dist); % half the vergence angle

for t = 1:num_trials

    switch res.trials.directionR{t}
        
        case 'left'
            
            res.trials.predictionLE(dcnt-1+t,:) = v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE(dcnt-1+t,:) = -v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            
        case 'right'
            
            res.trials.predictionLE(dcnt-1+t,:) = v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE(dcnt-1+t,:) = -v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            
        case 'towards'
            
            res.trials.predictionLE(dcnt-1+t,:) = v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE(dcnt-1+t,:) = -v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            
        case 'away'
            
            res.trials.predictionLE(dcnt-1+t,:) = v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE(dcnt-1+t,:) = -v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            
    end

end


dcnt = dcnt+num_trials; % increment counter

