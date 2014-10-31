function keys_wait(keys,dat)

%check for space bar or A gamepad button
[keyIsDown, secs, keyCode] = KbCheck();

if ~isempty(GetGamepadIndices)
    goBn = Gamepad('GetButton', 1, keys.go);
else
    goBn = 0;
end

while ~keyCode(keys.esc) && ~keyCode(keys.space) && ~goBn
	
	[keyIsDown, secs, keyCode] = KbCheck();
    
    if ~isempty(GetGamepadIndices)
	goBn = Gamepad('GetButton', 1, keys.go);
    end
	
end

if keyCode(keys.esc)
	
	cleanup(1,dat);
    
end

while keyIsDown || goBn
	[keyIsDown, secs, keyCode] = KbCheck();
    if ~isempty(GetGamepadIndices)
	goBn = Gamepad('GetButton', 1, keys.go);
    end
end