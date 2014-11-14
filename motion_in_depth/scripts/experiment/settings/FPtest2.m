function dat = FPtest2
%
% this function stores the settings for motion in depth experiments. copy
% and rename to design a new experiment, or use the gui opened by
% run_experiment without arguments

% set up properties
dat.display         = 'planar';      % display
dat.recording       = 0;      % using eyelink to record (1) or not (0)
dat.training        = 1;      % providing training feedback noises (1) or not(0)

% dot field properties
dat.stimRadDeg      = 25;      % stimulus field radius
dat.dispArcmin      = 60;      % disparity magnitude
dat.dotSizeDeg      = 0.25;      % diameter of each dot
dat.dotDensity      = 2;      % dots per degree2

% timing
dat.preludeSec      = 0.25;      % delay before motion onset
dat.cycleSec        = 1;      % duration of one direction, so 2* = full cycle duration for a step-ramp

% conditions
dat.conditions      = {'FullCue'};      % dot conditions, IOVD, CDOT, etc
dat.cond_repeats    = 2;      % number of repeats per condition
dat.dynamics        = {'ramp','step','stepramp'};      % steps, ramps, etc
dat.directions      = {'right','towards','away','left'};      % initial motion direction


