% INTERPRET KEYPRESS
if ~keyCode(keyNames.esc)

    % DETERMINE INDEX IN WHICH TO STORE SUBJECT RESPONSE
    if isnan(S(currCond).resp) respIndex = 1; % First trial intialization
    else, respIndex = length(S(currCond).resp) + 1;
    end

    if S(currCond).randcolorstart(end) == 1 % RIGHT EYE PRESENTED FIRST
        %%% HANDLE KEY PRESSES FOR VERTICAL HOROPTER MEASUREMENTS
        if (keyCode(keyNames.left))     S(currCond).resp(respIndex) = 1; % ADD STEP
        elseif (keyCode(keyNames.right))  S(currCond).resp(respIndex) = -1; %MINUS STEP
            %%% HANDLE KEY PRESSES FOR CYCLOTORSION MEASUREMENTS
        elseif (keyCode(keyNames.down))  S(currCond).resp(respIndex) = 1; %ADD STEP
        elseif (keyCode(keyNames.up))  S(currCond).resp(respIndex) = -1; %MINUS STEP
            %%% HANDLE REDO KEY PRESS
        elseif (keyCode(keyNames.space)) S(currCond).resp(respIndex) = 0; %redo
        else
            warning(['experimentCP: controlLoop, case 3: unhandled key press: ' KbName(find(keyCode))]);
        end
    elseif S(currCond).randcolorstart(end) == 0 % LEFT EYE PRESENTED FIRST
        %%% HANDLE KEY PRESSES FOR VERTICAL HOROPTER MEASUREMENTS
        if (keyCode(keyNames.left))     S(currCond).resp(respIndex) = -1; % MINUSSTEP
        elseif (keyCode(keyNames.right))  S(currCond).resp(respIndex) = 1; %ADDSTEP
            %%% HANDLE KEY PRESSES FOR CYCLOTORSION MEASUREMENTS
        elseif (keyCode(keyNames.down))  S(currCond).resp(respIndex) = -1; %MINUS STEP
        elseif (keyCode(keyNames.up))  S(currCond).resp(respIndex) = 1; %ADDSTEP
            %%% HANDLE REDO KEY PRESS
        elseif (keyCode(keyNames.space)) S(currCond).resp(respIndex) = 0; %redo
        else
            warning(['experimentCP: controlLoop, case 3: unhandled key press: ' KbName(find(keyCode))]);
        end
    end

else
    Screen('CloseAll');
    ListenChar(0);
    break;
end

