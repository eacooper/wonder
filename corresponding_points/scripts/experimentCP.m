function [D] = experimentCP(subjName,fixPosOption,viewingDistCm)

% function [D] = experimentCP(subjName,fixPosOption,gazeAngleDeg,headAngleDeg,viewingDistCm,bCycloOnly)
%
%   example call: experimentCP('JUNK',0,100)
%
% subjName: initials
% fixPosOption: 0-> no onscreen fixation disparity
%                1-> with onscreen fixation disparity
% viewDistCm:    subject horizontal distance from screen
% viewingDistCm: defaults to 114cm; alternate values can be entered


% HANDLE PARAMETERS
if ~exist('subjName');      subjName = 'JUNK';      disp(['WARNING! setting subjName --> ' subjName]); end
if ~exist('viewingDistCm'); viewingDistCm = 114;    disp(['WARNING! viewingDistCm defaulting to ' num2str(viewingDistCm) ' cm']); end
if ~exist('fixPosOption');  fixPosOption = 1;       disp(['WARNING! fixPosOption defaulting to ' num2str(fixPosOption) ]); end


% EXPERIMENT SET UP
[IPDcm]                     = getSubjInfo(subjName);
setStimBackgroundColorsCP;  % colors set to minimize cross talk on projector
getScreenInfo;              % screen dims in pixels, mm, and cm
setFixationPositionCP;      % fixation disparity depends on fixPosOption


%%% SET ECCENTRICITES TO MEASURE CORRESPONDING POINTS
fixationdistDeg             = [-8 -7 -6 -5 -4 -3 -2 0 2 3 4 5 6 7 8 -8 -7 -6 -5 -4 -3 -2 0 2 3 4 5 6 7 8];
vertPres                    = [ones(1,length(fixationdistDeg)/2) zeros(1,length(fixationdistDeg)/2)];
fixationdistCm              = viewingDistCm.*tan(fixationdistDeg.*pi./180); % distance from fixation point in cm
fixationdistPi              = fixationdistCm.*cm2pix;                       % distance from fixation point in pix


%%% SET SEGMENT LENGTH
seglengthDeg                = .75;
seglengthCm                 = 2.*viewingDistCm.*tan((seglengthDeg./2).*pi./180);
seglengthPi                 = seglengthCm.*cm2pix;


%%% SET FLASH DURATION
flash1dur                   = 0.05;  % 1st flash (sec)
flash2dur                   = 0.05;     % 2nd flash (sec)
betweenflashes              = 0.075; % sec


% DETERMINE CONDITIONS
conditions                  = 1:length(fixationdistDeg);
shiftstartsArcMin           = [-30 -25 -20 -15 -10 10 15 20 25 30]./2; %to make half of pixel shift
shiftstartsDeg              = shiftstartsArcMin./60;
shiftstartsPi               = viewingDistCm.*tan(shiftstartsDeg.*pi./180).*cm2pix;

% SETUP FILENAMES
[dataFileName dataFileDir dataFileNumber] = BuildFileName_CP(subjName,[],viewingDistCm,[],'MainExp');

% INTIALIZE DATA STRUCTURE 'D'
D.subjName          = subjName;
D.dataFileName      = dataFileName;
D.dataFileNumber    = dataFileNumber;
D.IPDcm             = IPDcm;
D.screenInfo        = screenInfo;
D.fixPosOption      = fixPosOption; %pixels on screen
D.leftEyeColor      = leftEyeColor;
D.rightEyeColor     = rightEyeColor;
D.fixPos            = fixPos;
D.viewingDistCm     = viewingDistCm; %cm
D.pix2cm            = pix2cm; % multiply to convert pixels to cm
D.cm2pix            = inv(pix2cm); % multiply to convert cm to pixels
D.fixationdistDeg   = fixationdistDeg; %deg
D.vertPres          = vertPres;
D.fixationdistPi    = fixationdistPi; %pixels
D.fixationdistCm    = fixationdistCm; %cm
D.seglengthDeg      = seglengthDeg; %deg
D.seglengthPi       = seglengthPi; %pixels
D.seglengthCm       = seglengthCm; %cm
D.flash1dur         = flash1dur; %seconds
D.flash2dur         = flash2dur; %seconds
D.betweenflashes    = betweenflashes; %seconds
D.conditions        = conditions;

% INITIALIZE STAIRCASES
for (c = 1:length(conditions))
    S(c).condition       = D.conditions(c);
    S(c).randcolorstart  = round(rand); % 0 = green = left... 1 = red / right;
    S(c).fixationdistDeg = D.fixationdistDeg(c);
    S(c).fixationdistPi  = D.fixationdistPi(c);
    S(c).vertPres        = vertPres(c); % 1 -> Vertical Horopter Measurements; 0 -> Cyclotorsion Checks
    S(c).viewingDistCm   = D.viewingDistCm; %cm
    S(c).trialNum        = 0;
    S(c).value           = shiftstartsPi(floor(rand(1)*length(shiftstartsPi))+1); % pixels-- will be 1/2 of total shift
    S(c).fullvaluePi     = 2.*(S(c).value); %actual total distance between lines in pixels
    S(c).fullvalueDeg    = 2.*atan((S(c).value.*pix2cm)./viewingDistCm).*180./pi;
    S(c).resp            = NaN; % initialization value... should not be zero at exp conclusion
    S(c).maxReversals    = 14;
    S(c).numReversals    = 0;
    S(c).reversalPoint   = 0;
    S(c).initStepSizeArcMin = 13.7775; % --will be 1/2 of total step
    S(c).initStepSize    = (2*(viewingDistCm*tan((S(c).initStepSizeArcMin*pi)/21600))).*cm2pix;   % pixels
    S(c).minStepSizeArcMin = .8611; %will be 1/2 of total step, so minstepsize is 1.7 arcmin
    if abs(S(c).fixationdistDeg) > 5
        S(c).minStepSizeArcMin = 2.*S(c).minStepSizeArcMin; % larger min step for larger eccentricities
    end
    S(c).minStepSize    = (2*(viewingDistCm*tan((S(c).minStepSizeArcMin*pi)/21600)))/(pix2cm);  %pixels
    S(c).stepSize      = S(c).initStepSize;
    S(c).terminated    = 0;
end

Screen('Preference', 'SkipSyncTests', 1);

%% OPEN FULLSCREEN WINDOW
window=Screen('OpenWindow',whichScreen,[],[],[],[],[],4);
Screen('BlendFunction', window,[],GL_ONE_MINUS_SRC_ALPHA);

%% GET MATLAB READY TO RUN EXPERIMENT
HideCursor;     % hide cursor
Screen(window,'FillRect',backgroundColor);

% GET EXPERIMENT READY
WaitSecs(0.1); % initialize WaitSecs mex function

% LISTEN TO KEYBOARD, SHOW FIXATION, WAIT FOR START
ListenChar(2);
% SET UP KEYCODES
keyNames = setKeyNames;
keyIsDown = 0; keyCode = zeros(1,256);

while ~keyCode(keyNames.space) % WAIT FOR SPACE BAR PRESS
    %%% WELCOME SCREEN INSTRUCTIONS
    Screen('DrawText', window, ['   Press space bar to start   '], [screencenterx-120], [fixPos.LE_Ypix+80], [128 128 128],[255 255 255]);
    Screen('DrawText', window, ['Also press space bar for re-do'], [screencenterx-120], [fixPos.LE_Ypix+100], [128 128 128],[255 255 255]);
    
    drawFixationDotCP;
    drawNoniusLinesCP;
    Screen(window, 'Flip');

    keyIsDown = 0; keyCode = zeros(1,256);
    while ~keyIsDown
        while (keyCode(keyNames.space) == 0) % space bar starts the program
            [keyIsDown, secs, keyCode] = KbCheck;
        end
    end
end
keyIsDown = 0; keyCode = zeros(1,256);

startTime = GetSecs;
while (sum([S(:).terminated]) < length(conditions)) % IF NOT ALL STAIRCASES COMPLETED, KEEP GOING
    % RANDOMLY CHOOSE CONDITION UNTIL AN ACTIVE STAIRCASE IS SELECTED
    currCond = ceil(length(S).*rand); % randomly choose condition
    while(S(currCond).terminated == 1)
        currCond = ceil(length(S).*rand); % randomly choose condition
    end

    %RANDOMIZE WHICH COLOR DISPLAYS FIRST % trialNum+1 to set randcolorstart for upcoming trial
    S(currCond).randcolorstart(S(currCond).trialNum+1) = round(rand); %1 = red; 0 = green

    %%START EXPERIMENT
    keyIsDown = 0; keyCode = zeros(1,256);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% 1ST STIM PRESENATION %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    glPushMatrix;
    
    if S(currCond).vertPres == 1 % Vertical Horopter Measurements. Stimulus presented above / below fixation.
        if S(currCond).randcolorstart(end) == 0 % IF FIRST COLOR IS GREEN (LEFT EYE)
            xPix = S(currCond).value(end);       % set dummy variables for x and y presentation of stimuli
            yPix = S(currCond).fixationdistPi;
            lineColor = leftEyeColor; xPixFix = fixPos.LE_Xpix; yPixFix = fixPos.LE_Ypix; whichEye = 'LE';
        elseif S(currCond).randcolorstart(end) == 1 % IF FIRST COLOR IS RED (RIGHT EYE)
            xPix = -S(currCond).value(end);       % set dummy variables for x and y presentation of stimuli
            yPix = S(currCond).fixationdistPi;
            lineColor = rightEyeColor; xPixFix = fixPos.RE_Xpix; yPixFix = fixPos.RE_Ypix; whichEye = 'RE';
        end
        glTranslatef(xPix, 0, 0);
        Screen('DrawLine', window, lineColor, xPixFix, yPixFix-yPix-(seglengthPi/2), xPixFix, yPixFix-yPix+(seglengthPi/2));
    elseif S(currCond).vertPres == 0 % Cyclotorsion Checks. Stimulus right / left of fixation
        if S(currCond).randcolorstart(end) == 0 % IF FIRST COLOR IS GREEN (LEFT EYE)
            xPix = S(currCond).fixationdistPi;       % set dummy variables for x and y presentation of stimuli
            yPix = -S(currCond).value(end);
            lineColor = leftEyeColor; xPixFix = fixPos.LE_Xpix; yPixFix = fixPos.LE_Ypix; whichEye = 'LE';
        elseif S(currCond).randcolorstart(end) == 1 % IF FIRST COLOR IS RED (RIGHT EYE)
            xPix = S(currCond).fixationdistPi;       % set dummy variables for x and y presentation of stimuli
            yPix = S(currCond).value(end);
            lineColor = rightEyeColor; xPixFix = fixPos.RE_Xpix; yPixFix = fixPos.RE_Ypix; whichEye = 'RE';
        end
        glTranslatef(0, yPix, 0); % DRAW TO LEFT OF MIDLINE (if value > 0)
        Screen('DrawLine', window, lineColor, xPixFix+xPix-(seglengthPi/2), yPixFix, xPixFix+xPix+(seglengthPi/2), yPixFix);
    end
    glPopMatrix;
    Screen(window, 'Flip');

    %%HOLD
    WaitSecs(flash1dur);

    %OFF CYCLE: SHOW NOTHING
    Screen(window,'FillRect',backgroundColor);
    Screen(window, 'Flip');
    WaitSecs(betweenflashes);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% 2ND STIM PRESENATION %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    glPushMatrix;
    if S(currCond).vertPres == 1 % Vertical Horopter Measurements. Stimulus presented above / below fixation.
        if S(currCond).randcolorstart(end) == 0 % IF FIRST COLOR WAS GREEN (LEFT EYE), PRESENT RED (RIGHT) NOW
            xPix = -S(currCond).value(end);       % set dummy variables for x and y presentation of stimuli
            yPix = S(currCond).fixationdistPi;
            lineColor = rightEyeColor; xPixFix = fixPos.RE_Xpix; yPixFix = fixPos.RE_Ypix; whichEye = 'RE';
        elseif S(currCond).randcolorstart(end) == 1 % IF FIRST COLOR WAS RED (RIGHT EYE), PRESENT GREEN (LEFT) NOW
            xPix = S(currCond).value(end);       % set dummy variables for x and y presentation of stimuli
            yPix = S(currCond).fixationdistPi;
            lineColor = leftEyeColor; xPixFix = fixPos.LE_Xpix; yPixFix = fixPos.LE_Ypix; whichEye = 'LE';
        end
        glTranslatef(xPix, 0, 0);
        Screen('DrawLine', window, lineColor, xPixFix, yPixFix-yPix-(seglengthPi/2), xPixFix, yPixFix-yPix+(seglengthPi/2));
    elseif S(currCond).vertPres == 0 % Cyclotorsion Checks. Stimulus right / left of fixation
        if S(currCond).randcolorstart(end) == 0     % IF FIRST COLOR IS GREEN (LEFT EYE), PRESENT RED (RIGHT) NOW
            xPix = S(currCond).fixationdistPi;      % set dummy variables for x and y presentation of stimuli
            yPix = S(currCond).value(end);
            lineColor = rightEyeColor; xPixFix = fixPos.RE_Xpix; yPixFix = fixPos.RE_Ypix; whichEye = 'RE';
        elseif S(currCond).randcolorstart(end) == 1 % IF FIRST COLOR IS RED (RIGHT EYE), PRESENT GREEN (LEFT) NOW
            xPix = S(currCond).fixationdistPi;      % set dummy variables for x and y presentation of stimuli
            yPix = -S(currCond).value(end);
            lineColor = leftEyeColor; xPixFix = fixPos.LE_Xpix; yPixFix = fixPos.LE_Ypix; whichEye = 'LE';
        end
        glTranslatef(0, yPix, 0); % DRAW TO LEFT OF MIDLINE (if value > 0)
        Screen('DrawLine', window, lineColor, xPixFix+xPix-(seglengthPi/2), yPixFix, xPixFix+xPix+(seglengthPi/2), yPixFix);
    end
    glPopMatrix;
    Screen(window, 'Flip');

    %%% HOLD
    WaitSecs(flash2dur);

    %%% OFF CYCLE: DELAY REPRESENTATION OF FIXATION CROSS TO PREVENT
    %%% MASKING OF 0 DEG ECCENTRICITY STIMULI
    S(currCond).fixationdistDeg
    if (S(currCond).fixationdistDeg == 0)
        Screen(window,'FillRect',backgroundColor);
        Screen(window, 'Flip');
        WaitSecs(.35);
    end
    
    %%% OFF CYCLE: SHOW NOTHING
    Screen(window,'FillRect',backgroundColor);

    drawFixationDotCP;
    drawNoniusLinesCP;
    Screen(window, 'Flip');

    % CHECK TO MAKE SURE KEY PRESS IS VALID FOR STIM PRESENTATION
    while ~(S(currCond).vertPres == 1 & (keyCode(keyNames.left) | keyCode(keyNames.right))) & ...
            ~(S(currCond).vertPres == 0 & (keyCode(keyNames.down) | keyCode(keyNames.up)))  & ...
            ~keyCode(keyNames.space) & ~keyCode(keyNames.esc)
        waitForSubjectResponseExpCP;
    end
    
    interpretKeyPressExpCP;
    S(currCond) = staircaseOneUpOneDownCP(S(currCond));

    % SYNC fullValueDeg and fullValuePi
    S(currCond).fullvaluePi = 2.*S(currCond).value;
    S(currCond).fullvalueDeg = 2.*atan((S(currCond).value.*pix2cm)./viewingDistCm).*180./pi;

    % SAVE STAIRCASE DATA TO D STRUCT
    D.S = S;
    D.expDurationMinutes = (GetSecs-startTime)./60;

    % SAVE DATA
    save([dataFileDir D.dataFileName],'D');

    %SHORT BREAK BEFORE NEXT STIMULUS
    WaitSecs(.2);

end
Screen('CloseAll');
ListenChar(0);