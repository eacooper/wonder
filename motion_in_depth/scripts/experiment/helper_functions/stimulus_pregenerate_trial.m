function [dotsLEcr,dotsREcr] = stimulus_pregenerate_trial(dat,scr,stm,condition,dynamics,direction)
%
% pre-generate stimulus frames for this trial


% first frame dots
[dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,scr,stm,condition);


% dynamics of subsequent frames
switch dynamics
    
    case 'step'
        disparities = stm.dynamics.step;
        
    case 'ramp'
        disparities = stm.dynamics.ramp;
        
    case 'stepramp'
        disparities = stm.dynamics.stepramp;
        
    otherwise
        error('not a valid experiment type');
        
end


% divide disparities by two, half for each eye
disparities = disparities/2;


% generate all frames
for x = 1:length(disparities)
    
    
    % new dot pattern at each update for CDOT and first half of Mixed Dots
    switch condition
        
        case 'CDOT'
            
            [dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,scr,stm,condition);
            
        case {'Mixed','MixedIncons','MixedCons'}
            
            [dots] = stimulus_make_random_dots(stm.dotSizePix,stm.xmax,stm.ymax,round(stm.numDots/2));
            
            dotsLE(:,1:round(stm.numDots/2))      = dots;
            dotsRE(:,1:round(stm.numDots/2))      = dots;
            
    end
    
    % generate LE and RE shifts for this frame
    shiftLE = [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
    shiftRE = [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
    
    
    %     % new dot pattern at each update for CDOT/ half of Mixed
    %     if strcmp(condition,'CDOT')
    %         [dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,scr,stm,condition);
    %     end
    %
    %     if ~isempty(strfind(condition,'Mixed'))
    %
    %         [dots] = stimulus_make_random_dots(stm.dotSizePix,stm.xmax,stm.ymax,round(stm.numDots/2));
    %
    %         dotsLE(:,1:round(stm.numDots/2))      = dots;
    %         dotsRE(:,1:round(stm.numDots/2))      = dots;
    %     end
    
    switch direction
        
        case 'towards'
            
            dotsLEall = dotsLE - shiftLE;
            dotsREall = dotsRE + shiftRE;
            
        case 'away'
            
            dotsLEall = dotsLE + shiftLE;
            dotsREall = dotsRE - shiftRE;
            
        case 'left'
            
            dotsLEall = dotsLE - shiftLE;
            dotsREall = dotsRE - shiftRE;
            
        case 'right'
            
            dotsLEall = dotsLE + shiftLE;
            dotsREall = dotsRE + shiftRE;
            
        otherwise
            
            error('invalid direction');
            
    end
    
    % crop to circle
    dotsLEcr{x} = dotsLEall(:,(dotsLEall(1,:).^2 + (dotsLEall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
    dotsREcr{x} = dotsREall(:,(dotsREall(1,:).^2 + (dotsREall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
    
end
