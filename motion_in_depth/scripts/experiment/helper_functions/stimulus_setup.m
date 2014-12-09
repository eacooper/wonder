function [dat,scr,stm] = stimulus_setup(dat,scr)
%
% define features of experimental stimulus


%  SCREEN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scr.cm2pix              = scr.width_pix/scr.width_cm;                           % conversion for cm to pixels
scr.pix2arcmin          = 2*60*atand(0.5/(scr.viewDistCm*scr.cm2pix));          % conversion from pixels to arcminutes
display(['1 pixel = ' num2str(scr.pix2arcmin,2) ' arcmin']);

scr.x_center_pix        = scr.width_pix/2;                                      % l/r screen center
scr.y_center_pix        = scr.height_pix/2 - (scr.stimCenterYCm*scr.cm2pix);    % u/d screen center

scr.y_center_pix_left   = scr.y_center_pix;                                     % left eye right eye centers...
scr.y_center_pix_right  = scr.y_center_pix;

scr.x_center_pix_left   = scr.x_center_pix - (scr.prismShiftCm*scr.cm2pix);
scr.x_center_pix_right  = scr.x_center_pix + (scr.prismShiftCm*scr.cm2pix);

if ~strcmp(cell2mat(dat.conditions),'SingleDot')                                % if there are multidot conditions included...      
   scr.calicolor = [52 52 52];                                                 % make the calibration screen a little brighter
end

%  STIMULUS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dat.dotUpdateHz     = 60;        % dot update rate
dat.numCycles       = 1;         % total cycles, more than 1 for periodic stim

stm.wlevel          = 255;       % white
stm.glevel          = 0;         % gray
stm.blevel          = 0;         % black

switch scr.name
    
    case {'planar','laptopRB','LG3DRB'}                        % planar uses blue-left, red-right
        
        stm.LEwhite = [stm.glevel stm.glevel stm.wlevel];
        stm.LEblack = [stm.glevel stm.glevel stm.blevel];
        
        stm.REwhite = [stm.wlevel stm.glevel stm.glevel];
        stm.REblack = [stm.blevel stm.glevel stm.glevel];
        
    otherwise                                                   % other displays just use white/black
        
        stm.LEwhite = [stm.wlevel stm.wlevel stm.wlevel];
        stm.LEblack = [stm.blevel stm.blevel stm.blevel];
        
        stm.REwhite = [stm.wlevel stm.wlevel stm.wlevel];
        stm.REblack = [stm.blevel stm.blevel stm.blevel];
        
end

stm.dispPix             = dat.dispArcmin/scr.pix2arcmin;            % step full disparity in pixels
stm.rampEndDispDeg      = 2*(dat.rampSpeedDegSec*dat.cycleSec);     % end full disparity of ramp in degrees relative to start position
stm.rampEndDispPix      = (60*stm.rampEndDispDeg)/scr.pix2arcmin;   % end full disparity of ramp in pixels relative to start position

stm.stimRadPix      = round((60*dat.stimRadDeg)/scr.pix2arcmin);    % dot field radius in pixels
stm.stimRadSqPix    = stm.stimRadPix^2;                             % square it now to save time later
stm.dotSizePix      = (dat.dotSizeDeg*60)/scr.pix2arcmin;           % dot diameter in pixels

stm.xmax            = 4*stm.stimRadPix;                             % full x field of dots before circle crop
stm.ymax            = 4*stm.stimRadPix;                             % fill y field of dots before circle crop

stm.numDots = round( dat.dotDensity*(  stm.xmax*(scr.pix2arcmin/60) * ...  % convert dot density to number of dots for PTB
    stm.ymax*(scr.pix2arcmin/60) ) );


%  TIMING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
% this seems to provide better precision, although time is still not
% perfect (a few frames tend to be dropped)

stm.dotUpdateSec    = 1/dat.dotUpdateHz;                                % duration to hold dots on screen
stm.dotRepeats		= round(scr.frameRate/dat.dotUpdateHz);             % number of frames to hold dots on screen
dat.dotUpdateHz     = scr.frameRate/stm.dotRepeats;                     % true dot update rate is even multiple of frame rate
stm.numUpdates      = round(dat.dotUpdateHz*dat.cycleSec);              % number of times the stimulus is updated in a rap cycle
stm.preludeUpdates  = round(dat.dotUpdateHz*dat.preludeSec);            % number of times the stimulus is updated in a preclue

stm.dynamics.step       = [ zeros(1,stm.preludeUpdates) repmat(stm.dispPix,1,stm.numUpdates)];   % set up step disparity updates
stm.dynamics.ramp       = [ zeros(1,stm.preludeUpdates) linspace(stm.rampEndDispPix/stm.numUpdates,stm.rampEndDispPix,stm.numUpdates)];       % set up ramp disparity updates
stm.dynamics.stepramp   = [ zeros(1,stm.preludeUpdates) stm.dispPix - linspace(0,stm.rampEndDispPix - (stm.rampEndDispPix/stm.numUpdates),stm.numUpdates)];
%stm.dynamics.stepramp   = [ zeros(1,stm.preludeUpdates)
%fliplr(linspace(stm.dispPix/stm.numUpdates,stm.dispPix,stm.numUpdates))];

%  FIXATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stm.fixationRadiusDeg = 1;
stm.fixationRadiusPix = (60*stm.fixationRadiusDeg)/scr.pix2arcmin;
stm.fixationRadiusSqPix = stm.fixationRadiusPix^2;

stm.fixationDotRadiusDeg = 0.125;
stm.fixationDotRadiusPix = (60*stm.fixationDotRadiusDeg)/scr.pix2arcmin;

if scr.topbottom == 1
    scr.Yscale = 0.5;
else
    scr.Yscale = 1;
end

stm.fixationRadiusYPix = stm.fixationRadiusPix*scr.Yscale;
stm.fixationRadiusXPix = stm.fixationRadiusPix;


%  TRIAL STRUCTURE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dat.trials.condition        = {};
dat.trials.dynamics         = {};
dat.trials.direction        = {};
dat.trials.repeat           = [];

for c = 1:length(dat.conditions)
    
    for d = 1:length(dat.dynamics)
        
        for n = 1:length(dat.directions)
            
            for r = 1:dat.cond_repeats
                
                dat.trials.condition    = [dat.trials.condition ; dat.conditions{c}];
                dat.trials.dynamics     = [dat.trials.dynamics ; dat.dynamics{d}];
                dat.trials.direction    = [dat.trials.direction ; dat.directions{n}];
                dat.trials.repeat       = [dat.trials.repeat ; r];
                
            end
        end
        
    end
    
end

% randomize trial order
dat.trials.trialnum = randperm(length(dat.trials.condition));

% emptry response arrays
dat.trials.resp         = cell(1,length(dat.trials.condition));
dat.trials.respCode     = NaN*ones(1,length(dat.trials.condition));
dat.trials.isCorrect    = NaN*ones(1,length(dat.trials.condition));

% generate random delay period for each trial
dat.trials.delayTimeSec = randi([250 750],1,length(dat.trials.condition))./1000;
dat.trials.delayUpdates = round(dat.dotUpdateHz*dat.trials.delayTimeSec);

%dat.trials.mat = [dat.trials.trialnum' dat.trials.condition dat.trials.dynamics dat.trials.repeat dat.trials.direction];

%% SOUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cf = 1000;                  % carrier frequency (Hz)
sf = 22050;                 % sample frequency (Hz)
d = 0.1;                    % duration (s)
n = sf * d;                 % number of samples
s = (1:n) / sf;             % sound data preparation
s = sin(2 * pi * cf * s);   % sinusoidal modulation
stm.sound.s = s;
stm.sound.sf = sf;

cf = 2000;                  % carrier frequency (Hz)
sf = 22050;                 % sample frequency (Hz)
d = 0.1;                    % duration (s)
n = sf * d;                 % number of samples
s = (1:n) / sf;             % sound data preparation
s = sin(2 * pi * cf * s);   % sinusoidal modulation
stm.sound.sFeedback = s;
stm.sound.sfFeedback = sf;



