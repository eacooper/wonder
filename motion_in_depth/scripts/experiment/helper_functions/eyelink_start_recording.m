function eyelink_start_recording(dat,delayTime,condition,dynamics,direction,trial)
%
% start eyelink recording, add delay, and inset trial flag
if dat.recording
    Eyelink('StartRecording');      % start recording eye position
    WaitSecs(delayTime);            % record a few samples before we actually start displaying
    Eyelink('Message', ['STARTTIME ' condition ' ' dynamics ' ' direction ' ' num2str(trial)]); % mark zero-plot time in data file
else
    WaitSecs(delayTime);
end