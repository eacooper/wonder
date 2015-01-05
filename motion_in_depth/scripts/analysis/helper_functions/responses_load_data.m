function [res,dcnt] = responses_load_data(dcnt,dat,res,file)
%
% fill in response data

% data fields to fill in are two types, experiment-specific and
% trial-specific
fields_exp    = {'subj','exp_name','ipd','training','dispArcmin',...
    'stimRadDeg','dotSizeDeg','dotDensity',...
    'preludeSec','cycleSec','rampSpeedDegSec'};
fields_trial     = {'condition','dynamics','direction','repeat',...
    'trialnum','resp','respCode','isCorrect','delayTimeSec','durationSec'};

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
    
    flist = dat.trials.(fields_trial{f})(dat.trials.trialnum);
    res.trials.([fields_trial{f} 'R'])(dcnt:dcnt+num_trials-1) = flist;
    
end

% stimulus predictions
v_half_angle = atand(((dat.ipd/2))./res.el.href_dist); % half the vergence angle

cntr = 1;
for t = dcnt:dcnt-1+num_trials

    switch res.trials.directionR{t}
        
        case 'left'
            
            res.trials.predictionLE{dcnt-1+cntr} = v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE{dcnt-1+cntr} = -v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            
            res.trials.predictionLEVelo{dcnt-1+cntr} = -res.predictionsVelo(file).(res.trials.dynamicsR{t});
            res.trials.predictionREVelo{dcnt-1+cntr} = -res.predictionsVelo(file).(res.trials.dynamicsR{t});
            
        case 'right'
            
            res.trials.predictionLE{dcnt-1+cntr} = v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE{dcnt-1+cntr} = -v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            
            res.trials.predictionLEVelo{dcnt-1+cntr} = res.predictionsVelo(file).(res.trials.dynamicsR{t});
            res.trials.predictionREVelo{dcnt-1+cntr} = res.predictionsVelo(file).(res.trials.dynamicsR{t});
            
        case 'towards'
            
            res.trials.predictionLE{dcnt-1+cntr} = v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE{dcnt-1+cntr} = -v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            
            res.trials.predictionLEVelo{dcnt-1+cntr} = res.predictionsVelo(file).(res.trials.dynamicsR{t});
            res.trials.predictionREVelo{dcnt-1+cntr} = -res.predictionsVelo(file).(res.trials.dynamicsR{t});
            
        case 'away'
            
            res.trials.predictionLE{dcnt-1+cntr} = v_half_angle - res.predictions(file).(res.trials.dynamicsR{t});
            res.trials.predictionRE{dcnt-1+cntr} = -v_half_angle + res.predictions(file).(res.trials.dynamicsR{t});
            
            res.trials.predictionLEVelo{dcnt-1+cntr} = -res.predictionsVelo(file).(res.trials.dynamicsR{t});
            res.trials.predictionREVelo{dcnt-1+cntr} = res.predictionsVelo(file).(res.trials.dynamicsR{t});
            
    end
    
    % store timepoints of predictions
    res.trials.prediction_time_points{dcnt-1+cntr} = res.predictions(file).time_points;
    
    cntr = cntr + 1;

end

dcnt = dcnt+num_trials; % increment counter

