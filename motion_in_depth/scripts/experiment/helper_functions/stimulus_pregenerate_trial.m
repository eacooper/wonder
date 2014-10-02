function [dotsLEcr,dotsREcr] = stimulus_pregenerate_trial(dat,stm,condition,dynamics,direction)
%
% pre-generate stimulus frames for this trial

[dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,stm,condition); % first frame dots


switch dynamics                                                 % dynamics of subsequent frames
    
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
    
    % we will flip the RE disparities if using the planar display
    if strcmp(dat.display,'planar'); REflip = -1;       
    else REflip = 1;
    end
    
    % new dot pattern at each update for CDOT/ half of Mixed
    if strcmp(condition,'CDOT')                                    
        [dotsLE,dotsRE] = stimulus_make_left_right_dots(dat,stm,condition);
    end
    
    if strcmp(condition,'Mixed')  
        
        [dots] = stimulus_make_random_dots(stm.dotSizePix,stm.xmax,stm.ymax,round(stm.numDots/2));
        
        dotsLE(1:round(dat.numDots/2),:)      = dots;
        dotsRE(1:round(dat.numDots/2),:)      = dots;
    end
    
    switch direction
        
        case 'towards'
            
            dotsLEall = dotsLE - [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE + [REflip*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        case 'away'
            
            dotsLEall = dotsLE + [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE - [REflip*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        case 'left'
            
            dotsLEall = dotsLE - [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE - [REflip*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        case 'right'
            
            dotsLEall = dotsLE + [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
            dotsREall = dotsRE + [REflip*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
            
        otherwise
            
            error('invalid direction');
            
    end
   
    % crop to circle
    dotsLEcr{x} = dotsLEall(:,(dotsLEall(1,:).^2 + (dotsLEall(2,:)./dat.Yscale).^2 < dat.stimRadSqPix));
    dotsREcr{x} = dotsREall(:,(dotsREall(1,:).^2 + (dotsREall(2,:)./dat.Yscale).^2 < dat.stimRadSqPix));
    
end
