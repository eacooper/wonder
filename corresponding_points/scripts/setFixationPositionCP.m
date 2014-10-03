% SCREEEN CENTER COORD IN PIXELS
screencenterx = 0.5.*screenInfo.Xpix;
screencentery = 0.5.*screenInfo.Ypix;
 
% DEPENDING ON CONDITION, DETERMINE FIXATION LOCATION
if fixPosOption == 0 % NO ON-SCREEN DISPARITY
    fixPos.LE_Xpix = screencenterx;
    fixPos.LE_Ypix = screencentery;
    fixPos.RE_Xpix = screencenterx;
    fixPos.RE_Ypix = screencentery;
elseif fixPosOption == 1 % WITH ON-SCREEN DISPARITY
    fixPos.LE_Xpix = screencenterx-(IPDcm./2).*cm2pix;
    fixPos.LE_Ypix = screencentery;
    fixPos.RE_Xpix = screencenterx+(IPDcm./2).*cm2pix;
    fixPos.RE_Ypix = screencentery;
else
    error(['experimentCP: fixPosOption has invalid value ' num2str(fixPosOption) '. Must be (0, 1, 2, 3)']);
end