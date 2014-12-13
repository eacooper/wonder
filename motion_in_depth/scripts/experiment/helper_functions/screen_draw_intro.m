function [] = screen_draw_intro(el,scr,window)

[width, height]=Screen('WindowSize', window);
Screen('FillRect', window, scr.calicolor, InsetRect(Screen('Rect', window), -1, -1));
Screen('DrawText', window, 'CALIBRATION', width/2 - 25, height/2 - 50, [scr.calicolor(1) 255 255]);
size2=round(0.5/100*width);
rectt=CenterRectOnPoint([0 0 size2 size2], width/2, height/2);
Screen( 'FillOval', window, [el.foregroundcolour],  rectt );
Screen('Flip',  window, [], 1);