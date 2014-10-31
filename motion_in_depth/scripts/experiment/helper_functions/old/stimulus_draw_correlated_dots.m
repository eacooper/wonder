function stimulus_draw_correlated_dots(w,scr,dat,stm,condition,dotsLE,dotsRE)  % dots

%Just static, correlated dots so screen lum doesn't suddenly change
switch condition
    
    
    case {'IOVD','CDOT','Mixed','FullCue'}
        
        
        [dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,scr,stm,'FullCue'); % first frame dots
        
        % crop to circle
        dotsLE = dotsLE(:,(dotsLE(1,:).^2 + (dotsLE(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
        dotsRE = dotsRE(:,(dotsRE(1,:).^2 + (dotsRE(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
        
        Screen('DrawDots', w, dotsLE, stm.dotSizePix, stm.LEwhite, [scr.x_center_pix_left  scr.y_center_pix_left], 0);
        Screen('DrawDots', w, dotsRE, stm.dotSizePix, stm.REwhite, [scr.x_center_pix_right  scr.y_center_pix_right], 0);
        
end
