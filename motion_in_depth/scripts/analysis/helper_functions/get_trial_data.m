function res = get_trial_data(el,res)
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
    
    
    [res,dcnt] = responses_load_data(dcnt,dat,res); % fill in response data
    
    % load and store calibration info
    
    [res,tcnt] = eyelink_load_data(tcnt,res,f,res.fullpath{f},el); % load eyetracking data
    
    res.allinfo(f) = dat;
    
end
