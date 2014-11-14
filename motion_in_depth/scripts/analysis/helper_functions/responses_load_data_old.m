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


for f = 1:length(fields_exp)
    
    if isstr(dat.(fields_exp{f}))
        flist = repmat({dat.(fields_exp{f})},1,num_trials);
    else
        flist = repmat(dat.(fields_exp{f}),1,num_trials);
    end
    
    res.trials.(fields_exp{f})(dcnt:dcnt+num_trials-1) = flist;
 
end


for f = 1:length(fields_trial)
    
   flist = dat.trials.(fields_trial{f});
   res.trials.([fields_trial{f} 'R'])(dcnt:dcnt+num_trials-1) = flist;
 
end

% res.trials.subj(dcnt:dcnt+num_trials-1) = repmat({dat.subj},1,num_trials);
% res.trials.exp_name(dcnt:dcnt+num_trials-1) = repmat({dat.exp_name},1,num_trials);
% res.trials.training(dcnt:dcnt+num_trials-1) = repmat(dat.training,1,num_trials);
% 
% res.trials.dispArcmin(dcnt:dcnt+num_trials-1) = repmat(dat.dispArcmin,1,num_trials);
% res.trials.stimRadDeg(dcnt:dcnt+num_trials-1) = repmat(dat.stimRadDeg,1,num_trials);
% res.trials.dotSizeDeg(dcnt:dcnt+num_trials-1) = repmat(dat.dotSizeDeg,1,num_trials);
% res.trials.dotDensity(dcnt:dcnt+num_trials-1) = repmat(dat.dotDensity,1,num_trials);
% res.trials.preludeSec(dcnt:dcnt+num_trials-1) = repmat(dat.preludeSec,1,num_trials);
% res.trials.cycleSec(dcnt:dcnt+num_trials-1) = repmat(dat.cycleSec,1,num_trials);
% 
% res.trials.conditionR(dcnt:dcnt+num_trials-1) = dat.trials.condition;
% res.trials.dynamicsR(dcnt:dcnt+num_trials-1) = dat.trials.dynamics;
% res.trials.directionR(dcnt:dcnt+num_trials-1) = dat.trials.direction;
% res.trials.repeat(dcnt:dcnt+num_trials-1) = dat.trials.repeat;
% res.trials.trialnumR(dcnt:dcnt+num_trials-1) = dat.trials.trialnum;
% res.trials.resp(dcnt:dcnt+num_trials-1) = dat.trials.resp;
% res.trials.respCode(dcnt:dcnt+num_trials-1) = dat.trials.respCode;
% res.trials.isCorrect(dcnt:dcnt+num_trials-1) = dat.trials.isCorrect;
% res.trials.delayTimeSec(dcnt:dcnt+num_trials-1) = dat.trials.delayTimeSec;

dcnt = dcnt+num_trials;
