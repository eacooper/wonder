function [condition,dynamics,direction,trialnum] = eyelink_parse_startline(startline)
%
%

[~,startline] = strtok(startline,' ');
[~,startline] = strtok(startline,' ');

[condition,startline] = strtok(startline,' ');
[dynamics,startline] = strtok(startline,' ');
[direction,trialnum] = strtok(startline,' ');
trialnum = str2num(cell2mat(trialnum));

