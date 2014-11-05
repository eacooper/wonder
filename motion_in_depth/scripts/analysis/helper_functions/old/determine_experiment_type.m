function expType = determine_experiment_type(pathname)

if strfind(pathname,'ramps_ET')
    expType = 'ramps';
elseif strfind(pathname,'ss_ET')
    expType = 'ss';
end
    