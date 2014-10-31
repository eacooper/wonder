function stimulus_draw_trial(w,trial,dotsLE,dotsRE,dat,stm,scr)
%
% draw dynamic part of trial

if dat.training; sound(stm.sound.s, stm.sound.sf); end

uind   = 1;                        % stimulus update index
tStart  = GetSecs;                 % trial start time

while(uind <= size(dotsLE,2))
    
    for r = 1:stm.dotRepeats
        
        % update dots
        Screen('DrawDots', w, dotsLE{uind}, stm.dotSizePix, stm.LEwhite, [scr.x_center_pix_left  scr.y_center_pix_left], 0);
        Screen('DrawDots', w, dotsRE{uind}, stm.dotSizePix, stm.REwhite, [scr.x_center_pix_right scr.y_center_pix_right], 0);
        
        Screen('Flip',w);
        
    end
    
    uind = uind + 1;        % increment update counter
    
end



% store trial timing info
dat.trials.durationSec(trial) = GetSecs - tStart;