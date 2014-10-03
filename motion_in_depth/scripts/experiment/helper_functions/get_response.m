function [dat] = keys_get_response(keys,dat,trial)

if ~isempty(GetGamepadIndices)
    resp(1) = Gamepad('GetButton', 1, keys.away);
    resp(2) = Gamepad('GetButton', 1, keys.towards);
    resp(3) = Gamepad('GetButton', 1, keys.left);
    resp(4) = Gamepad('GetButton', 1, keys.right);
else
    
    [keyIsDown, secs, keyCode] = KbCheck();
end

if sum(resp) == 1 && dat.isDown == 0
    
    dat.nearFarCode(logical(resp))
    dat.trials.conditionCode(trial)
    
    dat.trials.resp(trial) = dat.nearFarCode(logical(resp));
    dat.isDown = 1;
    
    %is response correct?
    if dat.trials.resp(trial) == dat.trials.conditionCode(trial)
        dat.trials.isCorrect(trial) = 1;
        
        %play sound for correct response
        if dat.trainingSound
            sound(dat.sFeedback, dat.sfFeedback);               % sound presentation
        end
        display(['Correct']);
        
    else
        dat.trials.isCorrect(trial) = 0;
        display(['Wrong']);
    end
    
elseif sum(resp) == 0
    dat.isDown = 0;
end

