function res = generate_preditions(dat,res,f)
%
% resample stimulus dynamics to eyetracking sampling rate, convert from pixels to
% degrees

for d = 1:length(dat.dynamics)
    
    update_times = [0:numel(dat.stim_info.dynamics.(dat.dynamics{d}))-1]*(1/dat.dotUpdateHz); % time points of predictions at each dot update
    et_times     = 0:1/res.el.sampleRate:dat.preludeSec+dat.cycleSec;                           % time points needed for predictions of et data
    
    % convert prediction in full disparity pixels to 1/2 disparity
    % (monocular position) arcminutes
    prediction = (1/2) * (1/60) * dat.display_info.pix2arcmin * dat.stim_info.dynamics.(dat.dynamics{d});
    
    % assume velocity at time-points zero is zero to maintain alignment
    % with position prediction
    predictionVelo = [0 diff(prediction)/dat.stim_info.dotUpdateSec];
    
    % interpolate the eyetracker sampling rate
    res.predictions(f).(dat.dynamics{d}) = interp1(update_times,prediction,et_times,'previous');
    res.predictionsVelo(f).(dat.dynamics{d}) = interp1(update_times,predictionVelo,et_times,'previous');

end

res.predictions(f).time_points = et_times;      % store timepoints in seconds
res.predictionsVelo(f).time_points = et_times;      % store timepoints in seconds
