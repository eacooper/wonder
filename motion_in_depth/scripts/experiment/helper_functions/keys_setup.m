function [dat,keys] = setup_keys(dat)

KbName('UnifyKeyNames');

keys.space = KbName('space');
keys.esc = KbName('ESCAPE');

%handle gamepad
if ~isempty(GetGamepadIndices)
    buttonState = Gamepad('GetButton', 1, 1); %initialize
    
    keys.go         = 14; % A button on gamepad
    keys.faway      = 8; %away on gamepad
    keys.towards    = 5; % towards on gamepad
    keys.left       = 7; %leftward on gamepad
    keys.right      = 6; %rightward on gamepad
    
else
    
    keys.go         = KbName('return'); % A button on gamepad
    keys.away       = KbName('UpArrow'); %away on gamepad
    keys.towards    = KbName('DownArrow'); % towards on gamepad
    keys.left       = KbName('LeftArrow'); %leftward on gamepad
    keys.right      = KbName('RightArrow'); %rightward on gamepad
    
end

keys.isDown = 0;