function dat = stimulus_draw_trial(w,trial,dotsLE,dotsRE,dat,stm,scr,condition,dynamics,direction,delay)
%
% draw dynamic part of trial

%if dat.training; sound(stm.sound.s, stm.sound.sf); end

uind   = 1;                         % stimulus step update index
while(uind <= size(dotsLE,2))       % while there are still updates
	
	% draw dot updates for each frame
	for r = 1:stm.dotRepeats
		
		% update dots
		Screen('DrawDots', w, dotsLE{uind}, stm.dotSizePix, stm.LEwhite, [scr.x_center_pix_left  scr.y_center_pix_left], 0);
		Screen('DrawDots', w, dotsRE{uind}, stm.dotSizePix, stm.REwhite, [scr.x_center_pix_right scr.y_center_pix_right], 0);
		
		Screen('Flip',w);
		
	end
	
	if uind == delay                    % reached the end of the delay
		
		tStart  = GetSecs;                 % trial start time
		
		% start recording
		eyelink_start_recording(dat,condition,dynamics,direction,trial)
	end
	
	uind = uind + 1;        % increment update counter
	
end


% stop recording
eyelink_end_recording(dat,condition,dynamics,direction,trial)


% store trial timing info
dat.trials.durationSec(trial) = GetSecs - tStart;
