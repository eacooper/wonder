function [Eall,Sall] =  process_ET_data(pathname, filenames, expType)


sampleRate  = 1000;                 % eyetracker sample rate in Hz
href_dist   = 50;                   % viewing distance in cm
href2cm     = (href_dist/15000);    % conversion factor between HREF units and cm
start_line  = 26;                   % line in EDF file where data start

trialCnt    = 1;
Eall        = [];

for f = 1:length(filenames)
    
    display(filenames{f});
    
    %%% store general subject stimulus info
    
    S(f) = load([strrep(pathname,'_ET','_stim') strrep(filenames{f},'asc','mat')]);
    
    if f == 1                                                                                   %get common info from first trial set
        Sall = build_stimulus_data_struct(S,sampleRate);
    else
            
        if(0)
            [df, match, er1, er2] = comp_struct(S(f).dat,S(f-1).dat,0); display(er1);
        end
    end
    
    %%% load ET data and split up trials
    
    fid                 = fopen([pathname filenames{f}]);
    lookForNextTrial    = 1;                                % start out looking for time sync message
    lineCnt             = 1;
    startCnt            = 0;
    blinking            = 0;
    firstEyeBlink       = 0;
    
    while(1)
        
        Line = fgetl( fid );    % read a line from file
        startCnt = startCnt + 1;          % increment overall line counter
        if( Line == -1 )        % reached end of file
            fclose(fid); break;
        end
        
        if( startCnt >= start_line ) % skip header, start at this line
            
            % FOUND START OF TRIAL
            if lookForNextTrial && ~isempty(strfind( Line, 'SYNCTIME' ))
                [Eall,lookForNextTrial] = get_trial_info(expType,Eall,S(f),Sall,Line,trialCnt);
            end
            
            if lookForNextTrial == 0
                
                % FOUND TRIAL DATA SAMPLE
                if ~isempty(str2num(Line(1))) %if this is a sample line not an event line
                    
                    tmpLine     = parse_ET_data_line(Line);
                    Eall        = add_line_to_ET_data_struct(Eall,trialCnt,lineCnt,tmpLine,href2cm,href_dist,Sall.ipd);
                    
                    if blinking
                        Eall.blinking(lineCnt,trialCnt) = 1;
                    end
                    
                    lineCnt     = lineCnt + 1;
                    
                % FOUND SACCADE
                elseif ~isempty(strfind( Line, 'SSACC' ))
                    
                    Eall.foundSaccade(trialCnt)         = Eall.foundSaccade(trialCnt) + 1;
                    Eall.saccadeStart(lineCnt,trialCnt) = 1;
                    
                elseif ~isempty(strfind( Line, 'SBLINK' ))
                    
                    Eall.foundBlink(trialCnt)         = Eall.foundBlink(trialCnt) + 1;
                    Eall.blinking(max([ 1 lineCnt - 45]):lineCnt-1,trialCnt) = 1;
                    blinking = 1;
                    
                elseif ~isempty(strfind( Line, 'EBLINK' ))
                    
                    firstEyeBlink = firstEyeBlink + 1;
                    
                    if firstEyeBlink == 2
                        Eall.blinking(lineCnt-1:lineCnt+45,trialCnt) = 1;
                        blinking = 0;
                        firstEyeBlink = 0;
                    end
                    
                end
                
                
                if lineCnt == Sall.trialLength + 1
                    lookForNextTrial    = 1;
                    trialCnt            = trialCnt + 1;
                    lineCnt             = 1;
                    
                    Eall.blinking = Eall.blinking(1:Sall.trialLength,:);
                end
                
            end
        end
        
    end

end

save(['../data/' expType '_ET/_proc_' S(1).dat.subj '_' datestr(clock,'mm_dd_yy_HHMMSS')]);
