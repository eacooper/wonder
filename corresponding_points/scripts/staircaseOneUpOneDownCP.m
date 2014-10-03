function S = staircaseOneUpOneDownCP(S,plotStair)

% function S = staircaseOneUpOneDown(S,plotStair)
%
%   updates stimulus value based on subject response and a one-up, one-down
%   adaptive staircase method
%
% S is a staircase structure containing the following fields
%   .trialNum:      current trial number (used for indexing other fields)
%   .value:         current value of the staircase ...      (1xtrialNum)
%   .resp:          current response of subject; 1 -> comp bigger, -1 ->
%                        comp smaller ...                   (1xtrialNum)
%                   (THIS VARIABLE MUST BE SET OUTSIDE OF THIS FUNCTION!)
%   .maxReservals:  max number of reversals (for staircase termination)
%   .numReversals:  current number of reversals ...         (1xtrialNum)
%   .reversalPoint: 1 -> marks reversal point, 0 -> not ... (1xtrialNum)
%   .initStepSize:  duh
%   .minStepSize:   double duh
%   .stepSize:      current step size ...                   (1xtrialNum)
%   .terminated:    0 -> staircase active, 1 -> staircase terminated
%
% plotStair:        1 -> plots staircase data, 0 -> not so much


% HANDLE INPUT
if (nargin < 2) plotStair = 0; end

if (S.terminated)
    warning('staircaseOneUpOneDown: attempt to update terminated staircase');
    return;
end

% update trial number
S.trialNum = S.trialNum + 1;

if (S.trialNum > 1) % if not the 1st trial
    % IF A REVERSAL
    if (length(S.resp) ~= S.trialNum)
        killer = 1;
    end
    if (S.resp(S.trialNum) ~= S.resp(S.trialNum-1))
        S.numReversals(S.trialNum) = S.numReversals(S.trialNum-1) + 1;
        S.reversalPoint(S.trialNum) = 1;
        if (S.stepSize(S.trialNum-1) > S.minStepSize)
            S.stepSize(S.trialNum) = S.stepSize(S.trialNum-1)/2;
        end
        % clamp stepSize to minStepSize
        if (S.stepSize(S.trialNum-1) <= S.minStepSize)
            S.stepSize(S.trialNum) = S.minStepSize;            %original linear stepsize:
        end
    % IF NOT A REVERSAL    
    else 
        S.numReversals(S.trialNum) = S.numReversals(S.trialNum-1);
        S.reversalPoint(S.trialNum) = 0;
        S.stepSize(S.trialNum) = S.stepSize(S.trialNum-1);

        % clamp stepSize to minStepSize
        if (S.stepSize(S.trialNum) <= S.minStepSize)        
            S.stepSize(S.trialNum) = S.minStepSize;
        end        
    end
else
    S.stepSize = S.initStepSize; % staircase setup
    S.numReversals = 0;
    S.reversalPoint = 0;
    S.terminated = 0;
end


% UPDATE STIMULUS VALUE
if (S.resp(S.trialNum) == 1) % if subject selected comparison, ADDSTEP
    S.value(S.trialNum+1) = S.value(S.trialNum) + S.stepSize(S.trialNum);
elseif (S.resp(S.trialNum) == -1) % if subject selected standard, MINUSSTEP
    S.value(S.trialNum+1) = S.value(S.trialNum) - S.stepSize(S.trialNum);
elseif (S.resp(S.trialNum) == 0) % if subject selected REDO
    S.value(S.trialNum+1) = S.value(S.trialNum);
end

% is the staircase terminated?
if (S.numReversals(S.trialNum) >= S.maxReversals)
    S.value(end) = [];
    S.terminated = 1;
end

% plot staircase data if desired
if (plotStair)
    figure(10);
    cla;
    plot(S.value,'bo-'); hold on
    plot(find(S.reversalPoint),S.value(find(S.reversalPoint)),'rs','linewidth',3)
    pause(.2);
end