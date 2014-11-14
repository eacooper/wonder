function res = get_trial_data(res)
%
%

% fields that must be the same to combine data
fieldsSame = {'display','recording','training','stimRadDeg','dispArcmin',...
    'dotSizeDeg','dotDensity','preludeSec','cycleSec','dotUpdateHz','numCycles'};

% fields that can differ
fieldsDiffer = {'subj','exp_name'};

fields = [fieldsSame fieldsDiffer];

tcnt = 1;
dcnt = 1;

for f = 1:length(res.fullpath)
    
    % experiment and response data
    load(res.fullpath{f});
    
    % fill in each field with experiment data
    for i = 1:numel(fields)
        
        if isstr(dat.(fields{i}))
            res.(fields{i}){f} =  dat.(fields{i});
        else
            res.(fields{i})(f) =  dat.(fields{i});
        end  
        
    end
    
    res.allinfo(f)      = dat;                                  % copy over all stimulus data
    res                 = generate_preditions(dat,res,f);       % generate eye predictions for each dynamics
    res.display_info(f) = dat.display_info;                     % grab display info 
    [res,dcnt]          = responses_load_data(dcnt,dat,res,f);  % fill in response and trial data
    
    % load and store calibration info
    
    [res,tcnt]          = eyelink_load_data...                  % fill in eyetracking data
                        (tcnt,res,f,res.fullpath{f},res.el); 
    
end