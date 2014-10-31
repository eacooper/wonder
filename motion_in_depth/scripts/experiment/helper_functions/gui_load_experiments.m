function experiments = gui_load_experiments
%
% load possible experiment types into array

listing = dir('./settings/*.m');

cnt = 1;
for x = 1:length(listing)
    
    if ~strcmp(listing(x).name,'template.m')
        
        experiments(cnt).name = strtok(listing(x).name,'.');
        cnt = cnt + 1;
        
    end
    
end
