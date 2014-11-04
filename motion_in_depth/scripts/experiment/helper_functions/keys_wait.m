function keys_wait(keys,dat)

%check for space bar or A gamepad button
[keyIsDown, secs, keyCode] = KbCheck();

if ~isempty(GetGamepadIndices)
	goBn(1) = Gamepad('GetButton', 1, keys.goGP1);
	goBn(2) = Gamepad('GetButton', 1, keys.goGP2);
	goBn(3) = Gamepad('GetButton', 1, keys.goGP3);
	goBn(4) = Gamepad('GetButton', 1, keys.goGP4);
else
	goBn = 0;
end

while ~keyCode(keys.esc) && ~keyCode(keys.space) && ~sum(goBn)
	
	[keyIsDown, secs, keyCode] = KbCheck();
	
	if ~isempty(GetGamepadIndices)
		goBn(1) = Gamepad('GetButton', 1, keys.goGP1);
		goBn(2) = Gamepad('GetButton', 1, keys.goGP2);
		goBn(3) = Gamepad('GetButton', 1, keys.goGP3);
		goBn(4) = Gamepad('GetButton', 1, keys.goGP4);
	end
	
end

if keyCode(keys.esc)
	
	cleanup(1,dat);
	
end

while keyIsDown || sum(goBn) == 1
	[keyIsDown, secs, keyCode] = KbCheck();
	if ~isempty(GetGamepadIndices)
		goBn(1) = Gamepad('GetButton', 1, keys.goGP1);
		goBn(2) = Gamepad('GetButton', 1, keys.goGP2);
		goBn(3) = Gamepad('GetButton', 1, keys.goGP3);
		goBn(4) = Gamepad('GetButton', 1, keys.goGP4);
	end
end