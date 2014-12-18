function res = load_data(rerun)
%
% process EL and behavioral data or load pre-processed

if rerun > 0                                % load and process data
    
    res     = get_data_file_names(rerun);   % get a list of all current data files or select new files for processing
    res.el  = eyelink_load_info;            % load in info about eyelink data aquisition
    res     = get_trial_data(res);          % parse files into data from each trial
    res     = check_trial_timing(res);      % scan for any timing issues in any of the trials
    res     = convert_data_values(res);     % convert screen coords to eye movements
    res     = compute_velocity(res);        % compute velocity from position data
    
    if rerun == 1                           % we reprocessed all data and should store it
        
        save('../../data/all_data.mat','res');
        
    elseif rerun == 2                       % we processed a new session and should add it to already stored data
        
        res = combine_data_structures(res);
        
    end
    
    
elseif rerun == 0                           % load already processed data
    
    load('../../data/all_data.mat');
    
end