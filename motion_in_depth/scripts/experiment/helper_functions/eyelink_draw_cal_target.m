function [rectL, rectR]=eyelink_draw_cal_target(el, x, y)

% draw simple calibration target
%
% USAGE: rect=EyelinkDrawCalTarget(el, x, y)
%
%		el: eyelink default values
%		x,y: position at which it should be drawn
%		rect: 

% simple, standard eyelink version
%   22-06-06    fwc OSX-ed

[width, height]=Screen('WindowSize', el.window);
size=round(el.calibrationtargetsize/100*width);
inset=round(el.calibrationtargetwidth/100*width);

rectL=CenterRectOnPoint([0 0 size size], x, y);
rectR=CenterRectOnPoint([0 0 size size], width/2 + (width/2-x), y);

Screen( 'FillOval', el.window, [0 el.foregroundcolour(1) el.foregroundcolour(1)],  rectL );
Screen( 'FillOval', el.window, [el.foregroundcolour(1) 0 0],  rectR );
%rect=InsetRect(rect, inset, inset);
%Screen( 'FillOval', el.window, el.backgroundcolour, rect );
Screen( 'Flip',  el.window);
