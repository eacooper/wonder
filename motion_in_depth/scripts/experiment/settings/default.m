function dat = default
%
% this function stores the settings for motion in depth experiments. copy
% and rename to design a new experiment, or use the gui opened by
% run_experiment without arguments

% subject initials
dat.subj = 'junk';

% display
dat.display = 'LG3DRB';

% using eyelink to record (1) or not (0)
dat.recording = 0;

% providing training feedback noises (1) or not(0)
dat.training = 1;
