function run_experiment(varargin)
%
% Runs IOVD/vergence experiment
%
% example: run_experiment('subj','eac','display','planar','recording',0,'training',1)
%
% subj      = subject initials
% display   = 3d display (planar, LG3D, laptop)
% recording = 1 if recording vergence in Eyelink
% training  = 1 if giving auditory feedback

% clear KbWait;


% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('.'));                  % add path to helper functions
dat = handle_varargin(varargin);        % put argument contents into data fields, deal with defaults
dat = make_data_dirs(dat);              % make directories to store session data
scr = screen_load_display_info(dat);    % handle display-specific stuff, including stereo mode

try
    
    % SET UP SCREEN, WINDOW, TRACKER, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [scr, w, winRect]  = screen_setup(scr);         % PTB window
    el                 = eyelink_setup(w);          % give Eyelink details about graphics, perform some initializations
    [dat,keys]         = keys_setup(dat);           % key responses
    
    eyelink_init_connection(dat.recording);         % if recording, initialize the connection to Eyelink
    
    
    % SET UP EXPERIMENT STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat,scr,stm]          = stimulus_setup(dat,scr);
    
    
    % DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    screen_draw_intro(el,scr,w)     % static screen
    keys_wait(keys)                 % experimentor starts C/V by hitting space bar
    WaitSecs(0.25);
    
    
    % CALIBRATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Working properly relies on having the correct settings in the
    % LASTRUN.INI file
    % if this breaks, you may need to open ET computer in Windows, copy the
    % old LASTRUN_XXX.INI file into the main last run file and restart the
    % tracker
    
    eyelink_run_calibration(dat,el)
    
    
    % RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if dat.recording; Eyelink('Openfile', 'tmp.edf'); end   % open file to record data to
    
    
    for t = 1:size(dat.trials.mat,1)                        % for each trial
        
        % trial info
        trial           = dat.trials.trialnum(t);                                       % which stimulus index to take
        condition       = cell2mat(dat.condition_types(dat.trials.condition(trial)));   % condition
        dynamics        = cell2mat(dat.dynamics_types(dat.trials.dynamics(trial)));     % dynamics
        direction       = cell2mat(dat.direction_types(dat.trials.direction(trial)));   % towards, away, left, right
        
        display([condition ' ' dynamics ' ... direction = ' direction]);
        
        
        %pre-generate stimulus frames for this trial
        [dotsLE,dotsRE] = stimulus_pregenerate_trial(dat,scr,stm,condition,dynamics,direction);
        
        
        % static fixation pattern before stimuls
        stimulus_draw_fixation(w,scr,dat,stm)                   % nonius
        stimulus_draw_correlated_dots(w,scr,dat,stm,condition)  % dots (no dots if this is single dot condition)
        Screen('Flip', w);
        
        
        % wait for trial to start
        keys_wait(keys)                                         % subject starts trials
        delayTime = randi([150 300])./1000;                     % add a little random delay
        dat.trials.delayTimeSec(trial) = delayTime;
        eyelink_start_recording(dat,delayTime,...
                            condition,dynamics,direction,trial) % start recording eye position, record a few samples, send start flag
        WaitSecs(dat.preludeSec);                               % keep fixation on screen for prelude duration
        
        % show trials
        stimulus_draw_trial(w,trial,dotsLE,dotsRE,dat,stm,scr)
        
        
        % clear screen at end
        stimulus_draw_end_screen(w,stm,scr);
        
        
        % get subject responses
        while keys.isDown == 0
            [dat,keys] = keys_get_response(keys,dat,stm,trial,direction);
        end
        
        
        % stop recording
        eyelink_end_recording(dat,condition,dynamics,direction,trial)
        
    end
    
    % aggregate data structures
    dat.keys            = keys;
    dat.display_info    = scr;
    dat.stim_info       = stm;
    
    Screen('DrawText', w, 'Done', scr.x_center_pix_right - 25, scr.y_center_pix_right - 50, scr.REwhite);
    Screen('DrawText', w, 'Done', scr.x_center_pix_left - 25, scr.y_center_pix_left - 50, scr.LEwhite);
    Screen('Flip', w);
    
    if dat.recording
        Eyelink('CloseFile');
        transfer_file(dat,'tmp.edf','_all_')
    else
        transfer_file(dat,[],'_all_')
    end
    
    cleanup;
    
catch myerr
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    cleanup;
    commandwindow;
    myerr;
    myerr.message
    myerr.stack.line
    
end 


% Cleanup routine:
function cleanup

Eyelink('Shutdown');    % Shutdown Eyelink:
sca;                    % Close window:
ListenChar(0);          % Restore keyboard output to Matlab:


