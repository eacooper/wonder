% ZERO VARIABLES
keyIsDown = 0; keyCode = zeros(1,256);

while ~keyIsDown
    while (keyCode(keyNames.right)    == 0 & keyCode(keyNames.left) == 0 ... % right / left response
            & keyCode(keyNames.up)     == 0 & keyCode(keyNames.down) == 0 ... % up / down response
            & keyCode(keyNames.space)  == 0 & keyCode(keyNames.esc)  == 0)  % esc response (quit program)
        [keyIsDown, secs, keyCode] = KbCheck;
    end
end