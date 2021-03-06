function [dat] = default
%
% this function stores the settings for motion in depth experiments. copy
% and rename to design a new experiment, or use the gui opened by
% run_experiment without arguments

% set up properties
dat.display     = 'LG3DRB';     % display
dat.recording   = 0;            % using eyelink to record (1) or not (0)
dat.training    = 1;            % providing training feedback noises (1) or not(0)

% dot field properties
dat.stimRadDeg      = 10;       % stimulus field radius
dat.dispArcmin      = 90;       % disparity magnitude
dat.dotSizeDeg      = 0.25;     % diameter of each dot
dat.dotDensity      = 2;        % dots per degree2

% timing
dat.preludeSec      = 0.25;     % delay before motion onset
dat.cycleSec        = 1;        % duration of one direction, so 2* = full cycle duration for a step-ramp

% conditions
dat.conditions      = {'IOVD','CDOT','FullCue','SingleDot'};        % dot conditions, IOVD, CDOT, etc
dat.cond_repeats    = 1;                                            % number of repeats per condition
dat.dynamics        = {'step','ramp','stepramp'};                   % steps, ramps, etc
dat.directions      = {'away','towards','left','right'};            % initial motion direction
