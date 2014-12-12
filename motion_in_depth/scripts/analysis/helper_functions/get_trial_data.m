function res = get_trial_data(res)
%
% ge the stimulus, response, and eyetracking data for each trial

% fields that must be the same to combine data
fieldsSame = {'display','recording','training','stimRadDeg','dispArcmin',...
    'dotSizeDeg','dotDensity','preludeSec','cycleSec','dotUpdateHz','numCycles'};

% fields that can differ
fieldsDiffer = {'subj','exp_name','ipd'};

fields = [fieldsSame fieldsDiffer];

dcnt = 1;   % trial counter for responses
tcnt = 1;   % trial counter for eyelink data

for f = 1:length(res.fullpath)
    
    % experiment and response data
    load(res.fullpath{f});
    
    % fill in each field with experiment data
    for i = 1:numel(fields)
        
        % handle strings {} versus numeric ()
        if isstr(dat.(fields{i}))
            res.(fields{i}){f} =  dat.(fields{i});
        else
            res.(fields{i})(f) =  dat.(fields{i});
        end
        
    end
    
    res.allinfo(f).dat   = dat;                                  % copy over all stimulus data
    res                 = generate_preditions(dat,res,f);       % generate eye predictions for each dynamics
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % hack to enable loading of data pre-calibration rescaling:
    if ~isfield(dat.display_info,'caliRadiusDeg');
        dat.display_info.caliRadiusDeg = 2;
        dat.display_info.caliRadiusPixX = 0;
        dat.display_info.caliRadiusPixY = 0;
    end
    if f > 1
        dat.display_info = orderfields(dat.display_info,res.display_info(1));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    res.display_info(f) = dat.display_info;                     % grab display info
    [res,dcnt]          = responses_load_data(dcnt,dat,res,f);  % fill in response and trial data
    
    res                 = eyelink_load_calibration_quality(res,f,res.fullpath{f});  % load and store calibration info
    
    [res,tcnt]          = eyelink_load_data...                  % fill in eyetracking data
        (tcnt,res,f,res.fullpath{f},res.el);
    
end

if tcnt ~= dcnt; error('trial numbers differ between data types'); end