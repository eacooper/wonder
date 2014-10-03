% drawNoniusLineCP.m

%%%%%%%%%%%%%%%%%%%%%
%%% DRAW NONIUS LINES
%%%%%%%%%%%%%%%%%%%%%
noniusLineLengthDeg = .5;
noniusSpacerDeg = noniusLineLengthDeg./2 + .2;

noniusLineLengthPix = tan(noniusLineLengthDeg.*pi/180).*viewingDistCm.*cm2pix;
noniusSpacerPix = tan(noniusSpacerDeg.*pi/180).*viewingDistCm.*cm2pix;

%%% LEFT EYE DOWN AND LEFT, RIGHT EYE UP AND RIGHT PORTION OF NONIUS CROSS
% Left Eye Line above and right of fixation
Screen('DrawLine', window, leftEyeColor,  fixPos.LE_Xpix, fixPos.LE_Ypix+noniusSpacerPix, fixPos.LE_Xpix, fixPos.LE_Ypix+noniusSpacerPix+noniusLineLengthPix);
Screen('DrawLine', window, leftEyeColor,  fixPos.LE_Xpix-noniusSpacerPix, fixPos.LE_Ypix, fixPos.LE_Xpix-noniusSpacerPix-noniusLineLengthPix, fixPos.LE_Ypix);
% Right Eye Line below and left of fixation
Screen('DrawLine', window, rightEyeColor,  fixPos.RE_Xpix, fixPos.RE_Ypix-noniusSpacerPix, fixPos.RE_Xpix, fixPos.RE_Ypix-noniusSpacerPix-noniusLineLengthPix);
Screen('DrawLine', window, rightEyeColor,  fixPos.RE_Xpix+noniusSpacerPix, fixPos.RE_Ypix, fixPos.RE_Xpix+noniusSpacerPix+noniusLineLengthPix, fixPos.RE_Ypix);

% BINOCULAR DIAGONALS TO AID FIXATION
Screen('DrawLine', window, leftEyeColor,  fixPos.LE_Xpix+noniusSpacerPix, fixPos.LE_Ypix+noniusSpacerPix, fixPos.LE_Xpix+noniusSpacerPix+noniusLineLengthPix, fixPos.LE_Ypix+noniusSpacerPix+noniusLineLengthPix);
Screen('DrawLine', window, rightEyeColor,  fixPos.RE_Xpix+noniusSpacerPix, fixPos.RE_Ypix+noniusSpacerPix, fixPos.RE_Xpix+noniusSpacerPix+noniusLineLengthPix, fixPos.RE_Ypix+noniusSpacerPix+noniusLineLengthPix);

Screen('DrawLine', window, leftEyeColor,  fixPos.LE_Xpix-noniusSpacerPix, fixPos.LE_Ypix-noniusSpacerPix, fixPos.LE_Xpix-noniusSpacerPix-noniusLineLengthPix, fixPos.LE_Ypix-noniusSpacerPix-noniusLineLengthPix);
Screen('DrawLine', window, rightEyeColor,  fixPos.RE_Xpix-noniusSpacerPix, fixPos.RE_Ypix-noniusSpacerPix, fixPos.RE_Xpix-noniusSpacerPix-noniusLineLengthPix, fixPos.RE_Ypix-noniusSpacerPix-noniusLineLengthPix);

% -35 a hack to match color brightness
brightnessHack = 0;
Screen('DrawLine', window, leftEyeColor,  fixPos.LE_Xpix-noniusSpacerPix, fixPos.LE_Ypix+noniusSpacerPix, fixPos.LE_Xpix-noniusSpacerPix-noniusLineLengthPix, fixPos.LE_Ypix+noniusSpacerPix+noniusLineLengthPix);
Screen('DrawLine', window, rightEyeColor,  fixPos.RE_Xpix-noniusSpacerPix, fixPos.RE_Ypix+noniusSpacerPix, fixPos.RE_Xpix-noniusSpacerPix-noniusLineLengthPix, fixPos.RE_Ypix+noniusSpacerPix+noniusLineLengthPix);

Screen('DrawLine', window, leftEyeColor,  fixPos.LE_Xpix+noniusSpacerPix, fixPos.LE_Ypix-noniusSpacerPix, fixPos.LE_Xpix+noniusSpacerPix+noniusLineLengthPix, fixPos.LE_Ypix-noniusSpacerPix-noniusLineLengthPix);
Screen('DrawLine', window, rightEyeColor,  fixPos.RE_Xpix+noniusSpacerPix, fixPos.RE_Ypix-noniusSpacerPix, fixPos.RE_Xpix+noniusSpacerPix+noniusLineLengthPix, fixPos.RE_Ypix-noniusSpacerPix-noniusLineLengthPix);
