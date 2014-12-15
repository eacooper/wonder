function res = load_data(rerun)
%
% process EL data or load pre-processed

if(rerun)

    res     = get_data_file_names;       % get a list of all current data files
    res.el  = eyelink_load_info;         % load in info about eyelink data aquisition
    res     = get_trial_data(res);       % parse files into data from each trial
    res     = check_trial_timing(res);   % scan for any timing issues in any of the trials
    res     = convert_data_values(res);  % convert screen coords to eye movements
    res     = compute_velocity(res);     % compute velocity from position data
    
    save('../../data/all_data.mat','res');
    
else
    load('../../data/all_data.mat');
end