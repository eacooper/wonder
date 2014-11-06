function eyelink_transfer_file(dat,edfFile,fileStr)


%timeNow = datestr(clock,'mm_dd_yy_HHMMSS');
    
if ~isempty(edfFile)
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
        %data file
        status=Eyelink('ReceiveFile');
        
        if status > 0
            fprintf('ReceiveFile status %d\n', status);
        end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch rdf
        fprintf('Problem receiving data file ''%s''\n', edfFile );
        rdf;
    end
    
    %move and convert file
    filename = [dat.data_track_dir dat.subj fileStr dat.timeNow '.edf'];
    movefile(edfFile,filename)
    command = ['/Applications/EyeLink/edfapi\ universal/edf2asc -sh ' filename];
    [status,cmdout] = system(command);
    
end

if ~strcmp(fileStr,'_calibration_')
    save([dat.data_stim_dir dat.subj fileStr dat.timeNow '.mat'],'dat');
end