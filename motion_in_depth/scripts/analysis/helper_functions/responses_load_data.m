function [res,dcnt] = responses_load_data(dcnt,dat,res)
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
for t = 1:num_trials
    res.trials.prediction(dcnt-1+t,:) = dat.stim_info.dynamics.(res.trials.dynamicsR{t});
end


dcnt = dcnt+num_trials; % increment counter

