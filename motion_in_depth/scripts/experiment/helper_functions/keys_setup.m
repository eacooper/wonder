function [dat,keys] = setup_keys(dat)

KbName('UnifyKeyNames');

keys.space = KbName('space');
keys.esc = KbName('ESCAPE');

%handle gamepad
if ~isempty(GetGamepadIndices)
    buttonState = Gamepad('GetButton', 1, 1); %initialize
    
    keys.go     = 14; % A button on gamepad
    keys.far    = 8; %away on gamepad
    keys.near   = 5; % towards on gamepad
    keys.left   = 7; %leftward on gamepad
    keys.right  = 6; %rightward on gamepad
    
else
    
    keys.go     = KbName('return'); % A button on gamepad
    keys.far    = KbName('UpArrow'); %away on gamepad
    keys.near   = KbName('DownArrow'); % towards on gamepad
    keys.left   = KbName('LeftArrow'); %leftward on gamepad
    keys.right  = KbName('RightArrow'); %rightward on gamepad
    
end

% response options

dat.resp_options     = {'far','near','left','right'}; % response options
dat.resp_code        = 1:4;

keys.isDown = 0;