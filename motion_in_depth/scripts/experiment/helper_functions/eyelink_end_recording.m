function eyelink_end_recording(dat,condition,dynamics,direction,trial)
%
% stop recording for trial and inset flag with response info

if dat.recording
    Eyelink('Message', ['STOPTIME ' condition ' ' dynamics ' ' direction ' ' num2str(trial)]);
    Eyelink('StopRecording');
end