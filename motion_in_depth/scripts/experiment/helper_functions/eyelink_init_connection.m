function eyelink_init_connection(rec)
%
% connect to Eyelink eyetracker

if rec
    
    if ~EyelinkInit(0, 1)                       % try to initialize eyelink connection
        fprintf('Eyelink Init aborted.\n');
        cleanup;
        return;
    end
    
    % make sure that we get href data from the Eyelink
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,HREF,AREA');
end