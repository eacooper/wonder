function res = load_data(rerun)
%
%

if(rerun)

    el = eyelink_load_info;             % load in info about eyelink data aquisition
    res = get_data_file_names;          % get a list of all current data files
    
    res.ipd = 6; % need to fix this so it loads for each subject!!!!
    warning('need to fix individual ipds');
    
    
    res = get_trial_data(el,res);       % parse files into data from each trial
    res = convert_data_values(el,res);  % convert screen coords to eye movements
    
    save('../../data/all_data.mat','res');
else
    load('../../data/all_data.mat');
end