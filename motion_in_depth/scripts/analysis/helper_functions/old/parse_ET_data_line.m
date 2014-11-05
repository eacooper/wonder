function tmpLine = parse_ET_data_line(Line)

if( strfind( Line, '.....' ) )                  % the dots indicate that the data in this line have good corneal reflections

    tmpLine = str2num( Line(1:end-6) );         % store this data
    
    if isempty(tmpLine)                         % sometimes this is still empty
        tstamp = str2num(strtok(Line,' '));     % just grab timestamp
        tmpLine = [tstamp(1) NaN.*ones(1,6)];   % set the rest of the data to NaNs
    end
    
else                                            % fill with NaNs
    
    tstamp = str2num(strtok(Line,' '));
    tmpLine = [tstamp(1) NaN.*ones(1,6)];
    
end