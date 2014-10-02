function [scr, w, winRect] = setup_screen(scr)
%
% open and set up PTB screen window

scr.screenNumber = max(Screen('Screens'));      % Use max screen number
PsychImaging('PrepareConfiguration');       % Prepare pipeline for configuration.

if strcmp(scr.display,'laptop')
    Screen('Preference', 'SkipSyncTests', 1);
else
    Screen('Preference', 'SkipSyncTests', 0);
end

% if strcmp(scr.display,'laptop') || strcmp(scr.display,'planar')
%     Screen('Preference', 'SkipSyncTests', 1);
% else
%     Screen('Preference', 'SkipSyncTests', 0);
% end


[w, winRect] = PsychImaging('OpenWindow', scr.screenNumber, ...
                                        0, [], [], [], [], 4);      % Open PTB graphics window
Screen(w,'BlendFunction',GL_ONE, GL_ONE);                      % Enable alpha blending - these are the settings that are needed for Planar

scr.calicolor = [52 52 52];                                         % bg color during calbration - not black so that itapprox matches mean screen luminance during stim

%fill screen
Screen('FillRect', w, [scr.calicolor], InsetRect(Screen('Rect', w), -1, -1));
Screen('Flip', w);

scr.frameRate   = Screen('NominalFrameRate',w);
scr.width_pix   = RectWidth(Screen('Rect', scr.screenNumber));
scr.height_pix  = RectHeight(Screen('Rect', scr.screenNumber));

% Disable key output to Matlab window:
ListenChar(2);

if strcmp(scr.display,'planar')
    res=Screen('Resolution', scr.screenNumber);
    
    if res(1) ~= 1600 || res(2) ~= 1200
        error('Planar not in native resolution');
    end
end