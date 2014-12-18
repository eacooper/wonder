function res = generate_preditions(dat,res,f)
%
% resample stimulus dynamics to eyetracking sampling rate, convert to
% degrees

for d = 1:length(dat.dynamics)
        
    res.predictions(f).(dat.dynamics{d}) = (1/60)*...
                resample(dat.stim_info.dynamics.(dat.dynamics{d}),res.el.sampleRate,dat.dotUpdateHz,0);

end

