function Sall = build_stimulus_data_struct(S,sampleRate)

Sall                 = S(1).dat;                                                             % store all stimulus info

Sall.ipd             = S(1).dat.ipdCm;                                                       % ipd in cm
Sall.L               = [-Sall.ipd/2 0 0];                                                    % translation vector from head to left eye
Sall.R               = [Sall.ipd/2 0 0];                                                     % translation vector from hear to right eye
Sall.sampleRate      = sampleRate;
Sall.preludeSec      = S(1).dat.preludeSec;                                                  % prelude duration
Sall.postludeSec     = S(1).dat.preludeSec;                                                  % postlude is equal to prelude
Sall.numCycles       = S(1).dat.numCycles;                                                   % stimulus cycles
Sall.stimDurSec      = (S(1).dat.numCycles*S(1).dat.cycleSec*2) + 1/S(1).dat.dotUpdateHz;    % add one frame
Sall.stimSampleTime  = linspace(0,Sall.stimDurSec,Sall.stimDurSec*Sall.sampleRate);                         % time axis for stimulus
Sall.cycleSampleTime = linspace(0,Sall.stimDurSec/Sall.numCycles,(Sall.stimDurSec/Sall.numCycles)*Sall.sampleRate);   % time axis for each cycle

Sall.trialLength     = Sall.stimDurSec*Sall.sampleRate + 2*Sall.preludeSec*Sall.sampleRate;                      % number of samples in a trial
Sall.trialSampleTime = linspace(0,Sall.stimDurSec + 2*Sall.preludeSec,Sall.trialLength);                    % time axis for full trial

Sall.stimDisparity   = [zeros(1,Sall.preludeSec*Sall.sampleRate) ...                                   % stimulus disparity at each time point
    reshape(repmat(S(1).dat.allStepsPix.*(S(1).dat.pix2arcmin),Sall.sampleRate/S(1).dat.dotUpdateHz,1),...
    1,length(S(1).dat.allStepsPix)*sampleRate/S(1).dat.dotUpdateHz) ...
    zeros(1,Sall.preludeSec*Sall.sampleRate)]./60;

