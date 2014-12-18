function dat = template
%
% this function stores the settings for motion in depth experiments. copy
% and rename to design a new experiment, or use the gui opened by
% run_experiment without arguments

% set up properties
dat.display         = X_d;      % display
dat.recording       = X_r;      % using eyelink to record (1) or not (0)
dat.training        = X_t;      % providing training feedback noises (1) or not(0)
dat.nonius          = X_n;      % nonius on during trial (1) or not(0)

% dot field properties
dat.stimRadDeg      = N_r;      % stimulus field radius
dat.dispArcmin      = N_d;      % disparity magnitude
dat.rampSpeedDegSec = N_m;      % ramp speed in degrees per second
dat.dotSizeDeg      = N_s;      % diameter of each dot
dat.dotDensity      = N_n;      % dots per degree2

% timing
dat.preludeSec      = T_p;      % delay before motion onset
dat.cycleSec        = T_c;      % duration of stimulus after prelude

% conditions
dat.conditions      = C_l;      % dot conditions, IOVD, CDOT, etc
dat.cond_repeats    = C_r;      % number of repeats per condition
dat.dynamics        = C_t;      % steps, ramps, etc
dat.directions      = C_d;      % initial motion direction


