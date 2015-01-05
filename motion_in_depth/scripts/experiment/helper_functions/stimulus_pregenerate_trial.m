function [dotsLEcr,dotsREcr] = stimulus_pregenerate_trial(scr,stm,condition,dynamics,direction,delay)
%
% pre-generate stimulus frames for this trial
% if stimType is delay, this is for a radnom delay period with no motion


% first frame dots
[dotsLE,dotsRE] = stimulus_make_left_right_dots(scr,stm,condition);


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


disparities_delay = zeros(1,delay);                     % number of delay frames
disparities       = [disparities_delay disparities];    % add in delay frames
disparities       = disparities/2;                      % divide disparities by two, half for each eye

% generate all frames
for x = 1:length(disparities)
	
	
	% new dot pattern at each update for CDOT and first half of Mixed Dots
	switch condition
		
		case 'CDOT'
			
			[dotsLE,dotsRE] = stimulus_make_left_right_dots(scr,stm,condition);
			
		case {'Mixed','MixedIncons','MixedCons'}
			
			[dots] = stimulus_make_random_dots(stm.xmax,stm.ymax,round(stm.numDots/2));
			
			dotsLE(:,1:round(stm.numDots/2))      = dots;
			dotsRE(:,1:round(stm.numDots/2))      = dots;
			
	end
	
	% generate LE and RE shifts for this frame
	shiftLE = [repmat(disparities(x),1,size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
	shiftRE = [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
	
	% reverse uncorrelated dots for the Mixed, Inconsistent condition
	if strcmp(condition,'MixedIncons')
		
		shiftLE(:,round(stm.numDots/2)+1:end) = -shiftLE(:,round(stm.numDots/2)+1:end);
		shiftRE(:,round(stm.numDots/2)+1:end) = -shiftRE(:,round(stm.numDots/2)+1:end);
		
	end
	
	switch direction
		
		case 'towards'
			
			dotsLEall = dotsLE + shiftLE;
			dotsREall = dotsRE - shiftRE;
			
		case 'away'
			
			dotsLEall = dotsLE - shiftLE;
			dotsREall = dotsRE + shiftRE;
			
		case 'left'
			
			dotsLEall = dotsLE - shiftLE;
			dotsREall = dotsRE - shiftRE;
			
		case 'right'
			
			dotsLEall = dotsLE + shiftLE;
			dotsREall = dotsRE + shiftRE;
			
		otherwise
			
			error('invalid direction');
			
	end
	
	if ~strcmp(condition,'SingleDot')
		% crop to circle
		dotsLEcr{x} = dotsLEall(:,(dotsLEall(1,:).^2 + (dotsLEall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
		dotsREcr{x} = dotsREall(:,(dotsREall(1,:).^2 + (dotsREall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
	else
		dotsLEcr{x} = dotsLEall;
		dotsREcr{x} = dotsREall;
	end
	
end
