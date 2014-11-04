function eyelink_set_targets(scr)
%
% set target locations and adjust screen size for planar

% target locations
Eyelink('Command','screen_pixel_coords = 0,0,1600,1200');
%effective screen size is reduced for native resolution on planar
Eyelink('Command','screen_phys_coords = -229.2, 171.9, 229.2, -171.9');
Eyelink('Command','calibration_type = HV13')

Eyelink('Command', 'calibration_targets = 800,600 800,520 800,680 720,600 880,600 720,520 880,520 720,680 880,680 760,560 840,560 760,640 840,640');
Eyelink('Command', 'validation_targets = 800,600 800,520 800,680 720,600 880,600 720,520 880,520 720,680 880,680 760,560 840,560 760,640 840,640 800,600');

if ~strcmp(scr.name,'planar') || scr.width_pix ~= 1600 || scr.height_pix ~= 1200
    error('Current Eyelink calibration only works for planar in native resolution');
end
