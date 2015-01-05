function res = compute_velocity(res)
%
% take eye position data and convert to velocity

% sgolay filter design for differentiation
N       = 3;                % Order of polynomial fit
F       = 101;               % Window length
[~,g]   = sgolay(N,F);      % Calculate S-G coefficients
spacing = 1/res.el.sampleRate; % temporal spacing between samples

for x = 1:length(res.trials.subj)

    display(['running:' num2str(x) '/' num2str(length(res.trials.subj))]);
    
    

    % monocular angular velocity
    res.trials.LExAngVelo{x} = to_velocity(res.trials.LExAng{x},spacing,g,F);
    res.trials.LEyAngVelo{x} = to_velocity(res.trials.LEyAng{x},spacing,g,F);
    
    res.trials.RExAngVelo{x} = to_velocity(res.trials.RExAng{x},spacing,g,F);
    res.trials.REyAngVelo{x} = to_velocity(res.trials.REyAng{x},spacing,g,F);
    
    % binocular angular velocity
    res.trials.vergenceHVelo{x} = to_velocity(res.trials.vergenceH{x},spacing,g,F);
    res.trials.versionHVelo{x} = to_velocity(res.trials.versionH{x},spacing,g,F);
    
    % predictions (just horizontal)
    res.trials.predictionLEVelo{x} = res.trials.predictionLEVelo{x};
    res.trials.predictionREVelo{x} = res.trials.predictionREVelo{x};

end

function velo = to_velocity(x,spacing,g,F)
%
% convert position to velocity using sgolay filter


% velo = gradient(x,spacing); %gradient filter -- too noisy!


HalfWin  = ((F+1)/2) -1; % half filter width

for n = (F+1)/2:length(x)-(F+1)/2,
    
  % Zeroth derivative (smoothing only)
  %SG0(n) = dot(g(:,1),x(n - HalfWin:n + HalfWin));

  % 1st differential
  SG1(n) = dot(g(:,2),x(n - HalfWin:n + HalfWin));

end

 % Turn differential into derivative, pad with NaNs
velo = [NaN*ones(1,(F+1)/2 - HalfWin - 1) (SG1/spacing) NaN*ones(1,(F+1)/2) - HalfWin]';        