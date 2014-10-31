function store_results(dat)
%
% store stimulus info, behavioral and eyetracking data

if dat.recording
    Eyelink('CloseFile');
    eyelink_transfer_file(dat,'tmp.edf','_all_')
else
    eyelink_transfer_file(dat,[],'_all_')
end