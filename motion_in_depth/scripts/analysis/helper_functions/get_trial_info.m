function [Eall,lookForNextTrial] = get_trial_info(expType,Eall,S,Sall,Line,trialCnt)

if strcmp(expType,'ramps')
    
    [trialnum,tail]             = strtok(fliplr(Line),' ');                         % get trial number
    Eall.trial(trialCnt)        = str2num(fliplr(trialnum));                        % store trial number
    
    [conditionnum,tail]         = strtok(tail,' ');                                 % get condition number
    Eall.condition(trialCnt)    = str2num(fliplr(conditionnum));                    % store condition number
    
    Eall.isNear(trialCnt)       = S.dat.trials.isNear(Eall.trial(trialCnt));        % get stimulus direction
    Eall.isCorrect(trialCnt)    = S.dat.trials.isCorrect(Eall.trial(trialCnt));     % get response
    Eall.probes(trialCnt)       = 1;
    
    Eall.rampSize(trialCnt)            = S.dat.stepsArcmin;
    Eall.trackFix(trialCnt)            = 2;
    
elseif strcmp(expType,'ss')
    
    trial = length(S.dat.trials.condition) - sum(cellfun(@isempty,S.dat.trials.response_NearFar));
    trial_num = S.dat.trials.trialnum(trial);
    
    Eall.trial(trialCnt)               = trial_num;
    Eall.condition(trialCnt)           = S.dat.trials.condition(trial_num);
    Eall.conditionName{trialCnt}       = cell2mat(S.dat.conditiontypes(Eall.condition(trialCnt)));
    Eall.probes(trialCnt)              = length(S.dat.trials.probe_NearFar{trial_num});
    Eall.isCorrect(trialCnt)           = sum(S.dat.trials.response_NearFar{trial_num} == 100);
    Eall.trackFix(trialCnt)            = S.dat.trackFix;
    Eall.trackTarget{trialCnt}         = S.dat.trackTarget;
    Eall.rampSize(trialCnt)            = S.dat.stepsArcmin;
    
    Eall.isNear(trialCnt)              = 1;
    
end
Eall.foundSaccade(trialCnt) = 0;                                                % initialize saccade value
Eall.foundBlink(trialCnt) = 0;                                                % initialize blink value
Eall.blinking(:,trialCnt) = zeros(Sall.trialLength,1);

Eall.rawData{trialCnt}      = [];                                               % initialize raw data matrix
lookForNextTrial            = 0;                                                % stop looking for trial message