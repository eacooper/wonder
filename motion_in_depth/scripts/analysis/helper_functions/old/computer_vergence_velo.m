function Eall = computer_vergence_velo(Eall,Sall)

keyboard

% First make full-size filtered vergence array (used for FFT)
v.data(conditionI).fullFilteredVergence = ...
    nan .* ones(size(v.data(conditionI).vergence));
fullDifferential = v.data(conditionI).fullFilteredVergence;

% Setup window
halfWin = ((fprs{2}+1)/2) - 1;
v.data(conditionI).filteredVergence = ...
    nan .* ones(size(v.data(conditionI).vergence, 1) - halfWin + 1, ...
    size(v.data(conditionI).vergence, 2));
differential = v.data(conditionI).filteredVergence;

for winI = (fprs{2} + 1)/2 : length(v.data(conditionI).filteredVergence) - fprs{2}/2
    
    % Smoothed vergence and velocity
    filt = g(:, 1)' * ...
        v.data(conditionI).vergence(winI - halfWin : winI + halfWin, :);
    dFilt = g(:, 2)' * ...
        v.data(conditionI).vergence(winI - halfWin : winI + halfWin, :);
    
    % Smooth the vergence first
    v.data(conditionI).fullFilteredVergence(winI, :) = filt;
    v.data(conditionI).filteredVergence(winI, :) = filt;
    
    % And compute smoothed velocity
    fullDifferential(winI, :) = dFilt;
    differential(winI, :) = dFilt;
end

% Remove nans from short filtered signal
finiteInds = isfinite(v.data(conditionI).filteredVergence(:, 1));
v.data(conditionI).filteredVergence = ...
    v.data(conditionI).filteredVergence(finiteInds, :);
differential = differential(finiteInds, :);

% Compute averages and SEs of short and full versions
v.data(conditionI).avgOrigFilteredVergence = ...
    nanmean(v.data(conditionI).fullFilteredVergence, 2);
v.data(conditionI).origFilteredVergenceSE = ...
    nanstd(v.data(conditionI).fullFilteredVergence, 0, 2) ./ ...
    sqrt(v.info(conditionI).numTrials);
v.data(conditionI).avgFilteredVergence = ...
    nanmean(v.data(conditionI).filteredVergence, 2);
v.data(conditionI).filteredVergenceSE = ...
    nanstd(v.data(conditionI).filteredVergence, 0, 2) ./ ...
    sqrt(v.info(conditionI).numTrials);

% Compute the new time axis
dt = 1/v.setup.sampleRate;
v.data(conditionI).filtTimeAx = v.data(conditionI).timeAx(...
    find(finiteInds, 1, 'first'):find(finiteInds, 1, 'last') + 1);

% And compute vergence velocities from differential
% First on full filtered signal (for FFT computation later),
% and then on shortened version
v.data(conditionI).fullVergenceVel = fullDifferential ./ ...
    diff([dt; v.data(conditionI).timeAx] * ...
    ones(1, v.info(conditionI).numTrials));
v.data(conditionI).vergenceVel = differential ./ ...
    (diff(v.data(conditionI).filtTimeAx) * ...
    ones(1, v.info(conditionI).numTrials));
v.data(conditionI).avgVergenceVel = ...
    nanmean(v.data(conditionI).vergenceVel, 2);
v.data(conditionI).vergenceVelSE = ...
    nanstd(v.data(conditionI).vergenceVel, 0, 2) ./ ...
    sqrt(v.info(conditionI).numTrials);