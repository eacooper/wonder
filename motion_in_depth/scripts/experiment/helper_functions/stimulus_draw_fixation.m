function stimulus_draw_fixation(w,scr,dat,stm)

% length of diagonal lines
fixationRadiusXPix2 = sqrt(((dat.fixationRadiusXPix*0.9).^2)/2);
fixationRadiusYPix2 = sqrt(((dat.fixationRadiusYPix*0.9).^2)/2);


% big lines
%Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenRightXCenterPix-dat.fixationRadiusYPix-dat.annRadPix*2,dat.screenRightYCenterPix,dat.screenRightXCenterPix-dat.fixationRadiusYPix-10,dat.screenRightYCenterPix , 8*dat.Yscale);
%Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenLeftXCenterPix+dat.fixationRadiusYPix+dat.annRadPix*2,dat.screenLeftYCenterPix,dat.screenLeftXCenterPix+dat.fixationRadiusYPix+10,dat.screenLeftYCenterPix , 8*dat.Yscale);

% bg
Screen('FillRect', w, dat.glevel);

% central square
Screen('FillRect', w, [dat.wlevel dat.wlevel dat.wlevel], ...
                        [scr.x_center_pix_left - stm.dotSizePix ...
                        scr.y_center_pix_left - stm.dotSizePix ...
                        scr.x_center_pix_left + stm.dotSizePix ...
                        scr.y_center_pix_left + stm.dotSizePix] );
                    
Screen('FillRect', w, [dat.wlevel dat.wlevel dat.wlevel], ...
                        [scr.x_center_pix_right - stm.dotSizePix ...
                        scr.y_center_pix_right - stm.dotSizePix ...
                        scr.x_center_pix_right + stm.dotSizePix ...
                        scr.y_center_pix_right + stm.dotSizePix] );                    

    keyboard                
if strcmp(scr,'Planar')
	
	Screen('DrawLine', w, dat.REwhite, scr.x_center_pix_right + (stm.fixationRadiusXPix*0.9), ...
                            scr.y_center_pix_right, ...
                            scr.x_center_pix_right + (stm.fixationRadiusXPix*0.1), ...
                            scr.y_center_pix_right , 2);

                        
	Screen('DrawLine', w, dat.REwhite, dat.screenRightXCenterPix,dat.screenRightYCenterPix-(dat.fixationRadiusYPix*0.9),dat.screenRightXCenterPix,dat.screenRightYCenterPix-(dat.fixationRadiusYPix*0.1) , 2);
	Screen('DrawLine', w, dat.LEwhite, dat.screenLeftXCenterPix+(dat.fixationRadiusXPix*0.9),dat.screenLeftYCenterPix,dat.screenLeftXCenterPix+(dat.fixationRadiusXPix*0.1),dat.screenLeftYCenterPix , 2);
	Screen('DrawLine', w, dat.LEwhite, dat.screenLeftXCenterPix,dat.screenLeftYCenterPix+(dat.fixationRadiusYPix*0.9),dat.screenLeftXCenterPix,dat.screenLeftYCenterPix+(dat.fixationRadiusYPix*0.1) , 2);

	%diagonal lines
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenLeftXCenterPix-fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix-fixationRadiusYPix2,dat.screenLeftXCenterPix+fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix+fixationRadiusYPix2 , 2);
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenLeftXCenterPix+fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix-fixationRadiusYPix2,dat.screenLeftXCenterPix-fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix+fixationRadiusYPix2 , 2);
	
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenRightXCenterPix-fixationRadiusXPix2-fixationDisp,dat.screenRightYCenterPix-fixationRadiusYPix2,dat.screenRightXCenterPix+fixationRadiusXPix2-fixationDisp,dat.screenRightYCenterPix+fixationRadiusYPix2 , 2);
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenRightXCenterPix+fixationRadiusXPix2-fixationDisp,dat.screenRightYCenterPix-fixationRadiusYPix2,dat.screenRightXCenterPix-fixationRadiusXPix2-fixationDisp,dat.screenRightYCenterPix+fixationRadiusYPix2 , 2);
	
else
	
	Screen('DrawLine', w, dat.REwhite, dat.screenRightXCenterPix-(dat.fixationRadiusXPix*0.9),dat.screenRightYCenterPix,dat.screenRightXCenterPix-(dat.fixationRadiusXPix*0.1),dat.screenRightYCenterPix , 2);
	Screen('DrawLine', w, dat.REwhite, dat.screenRightXCenterPix,dat.screenRightYCenterPix-(dat.fixationRadiusYPix*0.9),dat.screenRightXCenterPix,dat.screenRightYCenterPix-(dat.fixationRadiusYPix*0.1) , 2);
	Screen('DrawLine', w, dat.LEwhite, dat.screenLeftXCenterPix+(dat.fixationRadiusXPix*0.9),dat.screenLeftYCenterPix,dat.screenLeftXCenterPix+(dat.fixationRadiusXPix*0.1),dat.screenLeftYCenterPix , 2);
	Screen('DrawLine', w, dat.LEwhite, dat.screenLeftXCenterPix,dat.screenLeftYCenterPix+(dat.fixationRadiusYPix*0.9),dat.screenLeftXCenterPix,dat.screenLeftYCenterPix+(dat.fixationRadiusYPix*0.1) , 2);

	%diagonal lines
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenLeftXCenterPix-fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix-fixationRadiusYPix2,dat.screenLeftXCenterPix+fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix+fixationRadiusYPix2 , 2);
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenLeftXCenterPix+fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix-fixationRadiusYPix2,dat.screenLeftXCenterPix-fixationRadiusXPix2-fixationDisp,dat.screenLeftYCenterPix+fixationRadiusYPix2 , 2);
	
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenRightXCenterPix-fixationRadiusXPix2+fixationDisp,dat.screenRightYCenterPix-fixationRadiusYPix2,dat.screenRightXCenterPix+fixationRadiusXPix2+fixationDisp,dat.screenRightYCenterPix+fixationRadiusYPix2 , 2);
	Screen('DrawLine', w, [dat.wlevel dat.wlevel dat.wlevel], dat.screenRightXCenterPix+fixationRadiusXPix2+fixationDisp,dat.screenRightYCenterPix-fixationRadiusYPix2,dat.screenRightXCenterPix-fixationRadiusXPix2+fixationDisp,dat.screenRightYCenterPix+fixationRadiusYPix2 , 2);
	
end

