function [IPDcm] = getSubjInfo(subjName)

% function IPDcm = getSubjIPD(subjName)
% 
%   returns subject IPD  in cm

if strcmp(subjName,'JUNK')
    IPDcm = 6.2;
else
    error(['getSubjInfo: WARNING! subject ' subjName ' info not entered. Please add to getSubjIPD']);
end    

