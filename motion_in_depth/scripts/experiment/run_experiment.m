function run_experiment(varargin)
%
% Runs IOVD/vergence experiment
%
% example: run_experiment(exp_name)
%


% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('.'));                  % add path to helper functions
[dat,scr] = gui_settings(varargin);           % put argument contents into data fields, deal with defaults
dat = make_data_dirs(dat);              % make directories to store session data
%scr = screen_load_display_info(dat);    % handle display-specific stuff, including stereo mode


% SET UP SCREEN, STIMULUS, WINDOW, TRACKER, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%

[scr, w, winRect]  = screen_setup(scr);         % PTB window
el                 = eyelink_setup(w);          % give Eyelink details about graphics, perform some initializations
[dat,keys]         = keys_setup(dat);           % key responses
[dat,scr,stm]      = stimulus_setup(dat,scr);   % stimulus properties
eyelink_init_connection(dat.recording);         % if recording, initialize the connection to Eyelink


% DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

screen_draw_intro(el,scr,w)     % static screen
keys_wait(keys,[])              % experimentor starts C/V by hitting space bar
WaitSecs(0.25);


% CALIBRATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Working properly relies on having the correct settings in the file
% LASTRUN.INI 
% if this breaks, you may need to open ET computer in Windows, copy the
% old LASTRUN_XXX.INI file into the main last run file and restart the
% tracker

eyelink_run_calibration(dat,scr,el)


% RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if dat.recording; Eyelink('Openfile', 'tmp.edf'); end   % open file to record data to


for t = 1:length(dat.trials.trialnum)                        % for each trial
    
    % trial info
    trial           = dat.trials.trialnum(t);           % which stimulus index to take
    condition       = dat.trials.condition{trial};      % condition
    dynamics        = dat.trials.dynamics{trial};       % dynamics
    direction       = dat.trials.direction{trial};      % towards, away, left, right
    delay           = dat.trials.delayUpdates(trial);   % number of dot updates to delay before prelude
    display([condition ' ' dynamics ' ... direction = ' direction]);
    
    
    % pre-generate stimulus frames for this trial (and for the random delay period)
    [dotsLE,dotsRE]   = stimulus_pregenerate_trial(scr,stm,condition,dynamics,direction,delay);
    
    
    % initialize trial
    stimulus_draw_fixation(w,scr,dat,stm);                  % static fixation pattern before stimulus
    keys_wait(keys,dat)                                     % subject starts trials
    if dat.recording; Eyelink('StartRecording');  end       % start recording eye position


    % show trial (with random delay first)
    stimulus_draw_trial(w,trial,dotsLE,dotsRE,dat,stm,scr,condition,dynamics,direction,delay)
    
    
    % clear screen at end
    stimulus_draw_end_screen(w,stm,scr);
    
    
    % get subject responses
    while keys.isDown == 0
        [dat,keys] = keys_get_response(keys,dat,stm,trial,direction);
    end
    keys.isDown = 0;
    
end

% aggregate and save data structures
dat.keys            = keys;
dat.display_info    = scr;
dat.stim_info       = stm;
store_results(dat);

% exit
%Screen('DrawText', w, 'Done', scr.x_center_pix_right - 25, scr.y_center_pix_right - 50, dat.stim_info.REwhite);
Screen('DrawText', w, 'Done', scr.x_center_pix_left - 25, scr.y_center_pix_left - 50, dat.stim_info.LEwhite);
Screen('Flip', w);
WaitSecs(2);
cleanup(0,[]);



