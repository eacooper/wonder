function res = eyelink_load_calibration_quality(res,f,filename)
%
%

% generate calibration data file name
filename = strrep(strrep(strrep(filename,'stimulus','tracking'),'mat','asc'),'all','calibration');

% start with no data stored
res.calibrationLeft{f}          = 'No left eye calibration quality information stored';
res.calibrationRight{f}         = 'No right eye calibration quality information stored';
res.calibrationAvgLeftError(f)  = NaN;
res.calibrationAvgRightError(f) = NaN;
res.calibrationMaxLeftError(f)  = NaN;
res.calibrationMaxRightError(f) = NaN;

% look for calibration file
if exist(filename)
    
    % look for left and right eye calibration lines
    fid = fopen(filename);

    while(1)
        Line = fgetl( fid );    % read a line from file
        if( Line == -1 )        % reached end of file
            fclose(fid); break;
        end
        
        if strfind(Line,'!CAL VALIDATION HV13 LR LEFT');
            
            res.calibrationLeft{f} = Line;
            res.calibrationAvgLeftError(f) = str2num(cell2mat(regexp(Line,'(?<=ERROR )[^]+(?= avg.)', 'match')));
            res.calibrationMaxLeftError(f) = str2num(cell2mat(regexp(Line,'(?<=avg. )[^]+(?= max)', 'match')));
            
        elseif strfind(Line,'!CAL VALIDATION HV13 LR RIGHT');
            
            res.calibrationRight{f} = Line;
            res.calibrationAvgRightError(f) = str2num(cell2mat(regexp(Line,'(?<=ERROR )[^]+(?= avg.)', 'match')));
            res.calibrationMaxRightError(f) = str2num(cell2mat(regexp(Line,'(?<=avg. )[^]+(?= max)', 'match')));
            
        end
    end

end

