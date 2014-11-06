function el = eyelink_load_info
%
% load in importatn eyelink data info

warning('Loading in Eyelink measurement info - make sure settings were not changed');

el.sampleRate  = 1000;                 % eyetracker sample rate in Hz
el.href_dist   = 50;                   % viewing distance in cm
el.href2cm     = (el.href_dist/15000); % conversion factor between HREF units and cm

