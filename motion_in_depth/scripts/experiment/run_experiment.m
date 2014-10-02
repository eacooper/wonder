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
        isDown          = 0;                                                            % initialize with no response
        
        display([condition ' ... direction = ' direction]);
        
        %pre-generate stimulus frames for this trial
        [dotsLE,dotsRE] = stimulus_pregenerate_trial(dat,stm,condition,dynamics,direction);
        
        % PRETRIAL STIM - FIXATION NONIUS & STATIC DOTS %%%%%%%%%%%%%%%%%%%
        
        % nonius
        stimulus_draw_fixation(w,scr,dat,stm)
        
        %Just static, correlated dots so screen lum doesn't suddenly change
        if condition ~= 4 && condition ~= 8
            Screen('DrawDots', window, dotsLEcr{1}, dat.dotSizePix, dat.LEwhite, [dat.screenLeftXCenterPix  dat.screenLeftYCenterPix], 0);
            
            if strcmp(scr,'Planar')
                tmpDots = dotsLEcr{1}; tmpDots(1,:) = -tmpDots(1,:);
                Screen('DrawDots', window, tmpDots, dat.dotSizePix, dat.REwhite, [dat.screenRightXCenterPix dat.screenRightYCenterPix], 0);
            else
                Screen('DrawDots', window, dotsLEcr{1}, dat.dotSizePix, dat.REwhite, [dat.screenRightXCenterPix dat.screenRightYCenterPix], 0);
            end
            
        end
        
        
        Screen('Flip', window);
        
        %subject starts trials
        %clear KbWait;
        %KbWait(-3);
        waitForKeyRamp(keys)
        
        % add a little random delay
        delayTime = randi([150 300])./1000;
        dat.trials.delayTimeSec(trial) = delayTime;
        
        % start recording eye position
        if recording
            Eyelink('StartRecording');
            % record a few samples before we actually start displaying
            WaitSecs(delayTime);
            % mark zero-plot time in data file
            Eyelink('Message', ['SYNCTIME ' num2str(condition) ' ' num2str(trial)]);
        else
            WaitSecs(delayTime);
        end
        
        % keep fixation on screen for prelude duration
        WaitSecs(dat.preludeSec);
        
        
        % SHOW RAMP STIMULUS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %if trainingSound
        %	sound(dat.s, dat.sf);
        %end
        
        frind = 1; %frame index
        fall = length(dat.allStepsPix); %total number of frames
        tStart = GetSecs;
        
        tic
        while(frind <= fall)
            
            for xr = 1:dat.dotRepeats
                
                %grab button press
                %[dat] = getResponseRamp(keys,dat,frind,trial);
                
                % nonius
                %DrawFixationRamp(window,scr,dat,fixationDisp(frind))
                
                % update dots
                Screen('DrawDots', window, dotsLEcr{frind}, dat.dotSizePix, dat.LEwhite, [dat.screenLeftXCenterPix  dat.screenLeftYCenterPix], 0);
                Screen('DrawDots', window, dotsREcr{frind}, dat.dotSizePix, dat.REwhite, [dat.screenRightXCenterPix dat.screenRightYCenterPix], 0);
                
                %[VBLTimestamp tStart StimulusOffsetTime Missed Beampos] = Screen('Flip', window, tStart+dat.dotUpdateSec);
                [VBLTimestamp tStart StimulusOffsetTime Missed Beampos] = Screen('Flip',window);
                
                
            end
            %WaitSecs(dat.dotUpdateSec/2);
            frind = frind + 1;
            
            
        end
        toc
        
        
        
        % STATIC END FRAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % nonius
        %DrawFixationRamp(window,scr,dat,[0])
        
        % update dots
        Screen('DrawDots', window, dotsLEcr{frind-1}, dat.dotSizePix, dat.LEwhite, [dat.screenLeftXCenterPix  dat.screenLeftYCenterPix], 0);
        Screen('DrawDots', window, dotsREcr{frind-1}, dat.dotSizePix, dat.REwhite, [dat.screenRightXCenterPix dat.screenRightYCenterPix], 0);
        
        Screen('Flip', window);
        
        % keep fixation on screen for prelude duration
        WaitSecs(dat.preludeSec);
        
        %clear for next trial
        
        % nonius
        %DrawFixationRamp(window,scr,dat,[0])
        Screen('Flip', window);
        WaitSecs(0.2);
        
        if recording
            Eyelink('Message', 'STOPTIME');
            Eyelink('StopRecording');
            %Eyelink('CloseFile');
        end
        
        %grab button press - left, right, towards, away
        [width, height]=Screen('WindowSize', window);
        Screen('DrawText', window, 'Respond now', width/2 - 25, height/2 - 50, [0 255 255]);
        Screen('Flip', window);
        
        while dat.isDown == 0
            [dat] = getResponseRamp(keys,dat,trial);
        end
        
    end
    
    % %aggregaet structures
    dat.display_info    = scr;
    dat.stim_info       = stm;
        
    if recording
        
        Screen('DrawText', window, 'Done', width/2 - 25, height/2 - 50, [0 255 255]);
        Screen('Flip', window);
        
        Eyelink('CloseFile');
        %save data
        
        transfer_file(dat,'tmp.edf',['_all_'])
    else
        transfer_file(dat,[],['_all_'])
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
    
end %try..catch.


% Cleanup routine:
function cleanup
% Shutdown Eyelink:
Eyelink('Shutdown');

% Close window:
sca;

% Restore keyboard output to Matlab:
ListenChar(0);


