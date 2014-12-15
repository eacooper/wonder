function res     = check_trial_timing(res)
%
% look at timing info from PTB and Eyelink to see if any trials have timing
% problems

timingThreshold     = 0.025;     % threshold for discarding due to timing
goodStimulusTiming  = ...       % allow stimulus an extra few ms to display over requested timing
    res.trials.durationSecR - (res.trials.preludeSec + res.trials.cycleSec) < timingThreshold;
goodTrackingTiming  = ...       % allow recording an extra few ms to display over requested timing
    res.trials.recordingDurationSec - (res.trials.preludeSec + res.trials.cycleSec) < timingThreshold;

res.trials.goodTiming = goodStimulusTiming & goodTrackingTiming;