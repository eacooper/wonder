function res = generate_preditions(dat,res,f)
%
% resample stimulus dynamics to eyetracking sampling rate, convert to
% degrees

for d = 1:length(dat.dynamics)
    
    %res.predictions(f).(dat.dynamics{d}) = (1/60)*...
    %    resample(dat.stim_info.dynamics.(dat.dynamics{d}),res.el.sampleRate,dat.dotUpdateHz,0);
    
    update_times = [0:numel(dat.stim_info.dynamics.(dat.dynamics{d}))-1]*(1/dat.dotUpdateHz); % time points of predictions at each dot update
    et_times     = 0:1/res.el.sampleRate:dat.preludeSec+dat.cycleSec;                           % time points needed for predictions of et data
    
    res.predictions(f).(dat.dynamics{d}) = (1/60)*...
        interp1(update_times,dat.stim_info.dynamics.(dat.dynamics{d}),et_times,'previous');
    
end

