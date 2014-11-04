function [dat,keys] = keys_setup(dat)

KbName('UnifyKeyNames');

keys.space = KbName('space');
keys.esc = KbName('ESCAPE');

%handle gamepad
if ~isempty(GetGamepadIndices)
	buttonState = Gamepad('GetButton', 1, 1); %initialize
	
	keys.goGP1         = 14; % top button on gamepad
	keys.goGP2         = 15; % top button on gamepad
	keys.goGP3         = 12; % top button on gamepad
	keys.goGP4         = 13; % top button on gamepad
	
	keys.awayGP       = 8; % (D) away on gamepad
	keys.towardsGP    = 5; % (A) towards on gamepad
	keys.leftGP       = 7; % (C) leftward on gamepad
	keys.rightGP      = 6; % (B) rightward on gamepad
	
end

keys.go         = KbName('return'); % A button on gamepad
keys.away       = KbName('UpArrow'); %away on gamepad
keys.towards    = KbName('DownArrow'); % towards on gamepad
keys.left       = KbName('LeftArrow'); %leftward on gamepad
keys.right      = KbName('RightArrow'); %rightward on gamepad

keys.isDown = 0;