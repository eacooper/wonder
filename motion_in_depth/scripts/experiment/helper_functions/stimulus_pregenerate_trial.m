function [dotsLEcr,dotsREcr] = stimulus_pregenerate_trial(dat,scr,stm,condition,dynamics,direction)
%
% pre-generate stimulus frames for this trial

[dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,scr,stm,condition); % first frame dots


% dynamics of subsequent frames
switch dynamics                                                 
    
    case 'step'
        disparities = stm.dynamics.step/2;
        
    case 'ramp'
        disparities = stm.dynamics.ramp/2;
        
    case 'stepramp'
        disparities = stm.dynamics.stepramp/2;
        
    otherwise
        error('not a valid experiment type');
        
end

% generate all frames
for x = 1:length(disparities)
    
    % new dot pattern at each update for CDOT/ half of Mixed
    if strcmp(condition,'CDOT')                                    
        [dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,scr,stm,condition);
    end
    
    if strcmp(condition,'Mixed')  
        
        [dots] = stimulus_make_random_dots(stm.dotSizePix,stm.xmax,stm.ymax,round(stm.numDots/2));
        
        dotsLE(:,1:round(stm.numDots/2))      = dots;
        dotsRE(:,1:round(stm.numDots/2))      = dots;
    end
    
    switch direction
        
        case 'towards'
            
            dotsLEall = dotsLE - [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE + [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        case 'away'
            
            dotsLEall = dotsLE + [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE - [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        case 'left'
            
            dotsLEall = dotsLE - [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE - [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        case 'right'
            
            dotsLEall = dotsLE + [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE + [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        otherwise
            
            error('invalid direction');
            
    end
   
    % crop to circle
    dotsLEcr{x} = dotsLEall(:,(dotsLEall(1,:).^2 + (dotsLEall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
    dotsREcr{x} = dotsREall(:,(dotsREall(1,:).^2 + (dotsREall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
    
end
