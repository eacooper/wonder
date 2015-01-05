function dat = TonyFast
%
% this function stores the settings for motion in depth experiments. copy
% and rename to design a new experiment, or use the gui opened by
% run_experiment without arguments

% set up properties
dat.display         = 'planar';      % display
dat.recording       = 1;      % using eyelink to record (1) or not (0)
dat.training        = 0;      % providing training feedback noises (1) or not(0)
dat.nonius          = 0;      % nonius on during trial (1) or not(0)

% dot field properties
dat.stimRadDeg      = 10;      % stimulus field radius
dat.dispArcmin      = 360;      % disparity magnitude
dat.rampSpeedDegSec = 8;      % ramp speed in degrees per second
dat.dotSizeDeg      = 0.25;      % diameter of each dot
dat.dotDensity      = 2;      % dots per degree2

% timing
dat.preludeSec      = 0.25;      % delay before motion onset
dat.cycleSec        = 2;      % duration of stimulus after prelude

% conditions
dat.conditions      = {'SingleDot'};      % dot conditions, IOVD, CDOT, etc
dat.cond_repeats    = 10;      % number of repeats per condition
dat.dynamics        = {'stepramp'};      % steps, ramps, etc
dat.directions      = {'left','right'};      % initial motion direction


