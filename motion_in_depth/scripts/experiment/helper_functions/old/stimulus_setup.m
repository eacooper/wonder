function [dat,scr,stm] = setup_stimulus(dat,scr)
%
% define features of experimental stimulus

%  STIMULUS - PRIMARY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dot field properties
dat.stimRadDeg      = 17.5;             % stimulus field diameter
dat.dispArcmin      = 90;               % disparity magnitude

dat.dotSizeDeg      = 0.25;             % diameter of each dot
dat.dotDensity      = 2;                % dots per degree2
dat.dotUpdateHz     = 20;               % dot update rate

dat.preludeSec      = 0.5;              % delay before motion onset
dat.cycleSec        = 1;                % duration of one direction, so 2* = full cycle duration for a step-ramp
dat.numCycles       = 1;                % total cycles, more than 1 for periodic stim

% conditions
dat.condition_types = {'IOVD','CDOT','FullCue','Mixed','SingleDot'};    % stimulus types
dat.conditions      = 1:length(dat.condition_types);
dat.is2D            = [0 1];                                            % 0 = 3D, 1 = 2D
dat.isNear          = [0 1];                                            % 0 = receeding, 1 = approaching
dat.cond_repeats    = 1;                                                % number of repeats per condition

dat.dynamic_types   = {'step','ramp','stepramp'};                       % types of stimulus dyanamics
dat.dynamics        = 1:length(dat.dynamic_types);


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


%  STIMULUS - SECONDARY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stm.wlevel = 255;       % white
stm.glevel = 0;         % gray
stm.blevel = 0;         % black

switch scr.display
    
    case {'planar','laptopRB'}                                 % planar uses blue-left, red-right
        
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

stm.dispPix         = dat.dispArcmin./scr.pix2arcmin;               % step/ramp full disparity in pixels
stm.stimRadPix      = round((60*dat.stimRadDeg)/scr.pix2arcmin);    % dot field radius in pixels
stm.stimRadSqPix    = stm.stimRadPix^2;                             % square it now to save time later
dat.dotSizePix      = (dat.dotSizeDeg/60)/scr.pix2arcmin;           % dot diameter in pixels

stm.xmax            = 4*stm.stimRadPix;                             % full x field of dots before circle crop
stm.ymax            = 4*stm.stimRadPix;                             % fill y field of dots before circle crop

stm.numDots = dat.dotDensity*(  stm.xmax*(scr.pix2arcmin/60) * ...  % convert dot density to number of dots for PTB
    stm.ymax*(scr.pix2arcmin/60) );


%  TIMING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
% this seems to provide better precision, although time is still not
% perfect (a few frames tend to be dropped)

stm.dotUpdateSec    = 1/dat.dotUpdateHz;                                % duration to hold dots on screen
stm.dotRepeats		= round(scr.frameRate/dat.dotUpdateHz);             % number of frames to hold dots on screen
dat.dotUpdateHz     = scr.frameRate/stm.dotRepeats;                     % true dot update rate is even multiple of frame rate
stm.numUpdates      = 1+round(dat.dotUpdateHz*dat.cycleSec);            % number of times the stimulus is updated in a cycle

stm.dynamics.step   = [0 repmat(stm.dispPix,1,stm.numUpdates-1)];                                   % set up step disparity updates
stm.dynamics.step   = rude(repmat(stm.dotRepeats,1,length(stm.dynamics.step)),stm.dynamics.step);   % repeat for each frame

stm.dynamics.ramp   = linspace(0,stm.dispPix,stm.numUpdates);                                       % set up ramp disparity updates
stm.dynamics.ramp   = rude(repmat(stm.dotRepeats,1,length(stm.dynamics.ramp)),stm.dynamics.ramp);   % repeat for each frame

stm.dynamics.stepramp = [ stm.dynamics.step(1:stm.dotRepeats*2) fliplr(stm.dynamics.ramp)];


%  FIXATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stm.fixationRadiusDeg = 1;
stm.fixationRadiusPix = (60*stm.fixationRadiusDeg)./scr.pix2arcmin;
stm.fixationRadiusSqPix = stm.fixationRadiusPix^2;

if scr.topbottom == 1
    scr.Yscale = 0.5;
else
    scr.Yscale = 1;
end

stm.fixationRadiusYPix = stm.fixationRadiusPix*scr.Yscale;
stm.fixationRadiusXPix = stm.fixationRadiusPix;


%  TRIAL STRUCTURE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dat.trials.condition        = [];
dat.trials.dynamics         = [];
dat.trials.isNear           = [];
dat.trials.is2D             = [];
dat.trials.conditionCode    = [];
dat.trials.repeat           = [];

for c = 1:length(dat.conditions)
    
    for d = 1:length(dat.dynamics)
        
        for n = 1:length(dat.isNear)
            
            for t = 1:length(dat.is2D)
                
                for r = 1:dat.cond_repeats
                    
                    dat.trials.condition    = [dat.trials.condition ; dat.conditions(c)];
                    dat.trials.dynamics     = [dat.trials.dynamics ; dat.dynamics(d)];
                    dat.trials.isNear       = [dat.trials.isNear ; dat.isNear(n)];
                    dat.trials.is2D         = [dat.trials.is2D ; dat.is2D(t)];
                    dat.trials.repeat       = [dat.trials.repeat ; r];
                    
                    %apply code for far,near,left,right
                    if dat.isNear(n) == 1
                        if dat.is2D(t) == 1
                            currentCode = 4; %right
                        elseif dat.is2D(t) == 0
                            currentCode = 2; %near
                        end
                    elseif dat.isNear(n) == 0
                        if dat.is2D(t) == 1
                            currentCode = 3; %left
                        elseif dat.is2D(t) == 0
                            currentCode = 1; %far
                        end
                    end
                    
                    dat.trials.conditionCode = [dat.trials.conditionCode ; currentCode];
                    
                end
            end
            
        end
        
    end
    
end

%randomize trial order
dat.trials.trialnum = randperm(length(dat.trials.condition));

dat.trials.mat = [dat.trials.trialnum' dat.trials.condition dat.trials.dynamics dat.trials.repeat dat.trials.isNear dat.trials.is2D dat.trials.conditionCode];

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


