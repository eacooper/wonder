function [dat,keys] = keys_get_response(keys,dat,stm,trial,direction)
%
%

resps = {'away','towards','left','right'};
    
if ~isempty(GetGamepadIndices)
    
    resp(1) = Gamepad('GetButton', 1, keys.away);
    resp(2) = Gamepad('GetButton', 1, keys.towards);
    resp(3) = Gamepad('GetButton', 1, keys.left);
    resp(4) = Gamepad('GetButton', 1, keys.right);
    
else
    
    [keyIsDown, secs, keyCode] = KbCheck();
    
    resp(1) = keyCode(keys.away);
    resp(2) = keyCode(keys.towards);
    resp(3) = keyCode(keys.left);
    resp(4) = keyCode(keys.right);
    
end

if sum(resp) == 1 && keys.isDown == 0
    
    display(['Response is ... ' resps{logical(resp)}]);

    dat.trials.resp{trial} = resps{logical(resp)};
    dat.trials.respCode(trial) = find(resp);
    keys.isDown = 1;
    
    %is response correct?
    if strcmp(dat.trials.resp{trial},direction)
        
        display(['...Correct']);
        
        dat.trials.isCorrect(trial) = 1;
        
        %play sound for correct response
        if dat.training
            sound(stm.sound.sFeedback, stm.sound.sfFeedback);               % sound presentation
        end

    else
        dat.trials.isCorrect(trial) = 0;
        display(['...Wrong']);
    end
    
elseif keyCode(keys.esc)
	
    cleanup(1,dat);

elseif sum(resp) == 0
    
    keys.isDown = 0;
    
end

