function eyelink_start_recording(dat,condition,dynamics,direction,trial)
%
% start recording for trial and inset flag with trial info

if dat.recording
	display('Eyelink Recording Started');
	Eyelink('Message', ['STARTTIME ' condition ' ' ...
		dynamics ' ' direction ' ' num2str(trial)]); % mark zero-plot time in data file
end