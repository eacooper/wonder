function dat = stimulus_draw_trial(w,trial,dotsLE,dotsRE,dat,stm,scr,condition,dynamics,direction,delay)
%
% draw dynamic part of trial

t = GetSecs;

uind   = 1;                         % stimulus step update index
fidx   = 1;							% frame index
while(uind <= size(dotsLE,2))       % while there are still updates
	
	% draw dot updates for each frame
	for r = 1:stm.dotRepeats
        
		% update dots
		Screen('DrawDots', w, dotsLE{uind}, stm.dotSizePix, stm.LEwhite, [scr.x_center_pix_left  scr.y_center_pix_left], 0);
		Screen('DrawDots', w, dotsRE{uind}, stm.dotSizePix, stm.REwhite, [scr.x_center_pix_right scr.y_center_pix_right], 0);
		
		%Screen('Flip',w);
        
		% determine time for screen flip
		dat.trials.StimulusReqTime{trial}(fidx) = t+((1/scr.frameRate)*(fidx-1)); 
		
        % flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)
        [dat.trials.VBLTimestamp{trial}(fidx) dat.trials.StimulusOnsetTime{trial}(fidx) ...
         dat.trials.FlipTimestamp{trial}(fidx) dat.trials.Missed{trial}(fidx) dat.trials.Beampos{trial}(fidx)] = ...
            Screen('Flip', w,dat.trials.StimulusReqTime{trial}(fidx));
		
		fidx = fidx + 1;		% increment frame counter
		
	end
	
	if uind == delay                    % reached the end of the delay
		
		tStart  = GetSecs;                                              % store trial start time
		eyelink_start_recording(dat,condition,dynamics,direction,trial) % start recording
        
	end
	
	uind = uind + 1;        % increment update counter
	
end

% stop recording
eyelink_end_recording(dat,condition,dynamics,direction,trial)


% store trial timing info
dat.trials.durationSec(trial) = GetSecs - tStart;

