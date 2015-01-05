function res = generate_preditions(dat,res,f)

%res.trials.prediction(dcnt-1+t,:) = ...
%                    rude(repmat(samples,1,length(dat.stim_info.dynamics.(res.trials.dynamicsR{t}))),...
%                    dat.stim_info.dynamics.(res.trials.dynamicsR{t}));

%warning('HACK to deal with Timing in AM data, remove when new data is acquired');

% number of EL samples per dot update in the prediction
samples = res.el.sampleRate/dat.dotUpdateHz;

for d = 1:length(dat.dynamics)
    
    %res.predictions(f).(dat.dynamics{d}) = (1/60)*...
    %            rude(repmat(samples,1,length(dat.stim_info.dynamics.(dat.dynamics{d}))),...
    %            dat.stim_info.dynamics.(dat.dynamics{d}));
            
    res.predictions(f).(dat.dynamics{d}) = (1/60)*...
                resample(dat.stim_info.dynamics.(dat.dynamics{d}),res.el.sampleRate,dat.dotUpdateHz,0);
            
%     switch dat.dynamics{d}
%         
%         case {'ramp','step'}
%             
%             res.predictions(f).(dat.dynamics{d}) = (1/60)*...
%                 rude(repmat(samples,1,length(dat.stim_info.dynamics.(dat.dynamics{d}))),...
%                 dat.stim_info.dynamics.(dat.dynamics{d}));
%             
%         otherwise
%             
%             res.predictions(f).(dat.dynamics{d}) = (1/60)*...
%                 rude(repmat(samples,1,length(dat.stim_info.dynamics.(dat.dynamics{d})(1:26))),...
%                 dat.stim_info.dynamics.(dat.dynamics{d})(1:26));
%             
%     end

end

