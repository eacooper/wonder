function [res,tcnt] = eyelink_load_data(tcnt,res,f,filename,el)
%
% load eyetracking data

eld     = eyelink_import_data(strrep(strrep(filename,'stimulus','tracking'),'mat','asc'));      % import data from eyelink asc file
starts  = find(~cellfun(@isempty,strfind(eld.f2,'STARTTIME')));                                 % find all trial start flags
stops   = find(~cellfun(@isempty,strfind(eld.f2,'STOPTIME')));                                  % find all trial end flags
fields  = {'f2','f3','f5','f6','f1','f8',};                                                     % eld structure fields to use
vals    = {'LEx','LEy','REx','REy','meta','qual'};                                              % fields 1-4 are data, 5-6 are meta

for s = 1:length(starts)
    
    [condition,dynamics,direction,trialnum] = eyelink_parse_startline(eld.f2(starts(s)));       % parse startline into trial info
    
    for x = 1:length(fields)
        data{x} = eld.(fields{x})(starts(s)+1:stops(s)-1);
    end
    
    % indices to keep
    Datalines       = ~cellfun(@isempty,cellfun(@str2num,data{5},'un',0));      % these are the data sample lines (others are meta lines)
    GoodQuallines   = strcmp(data{6},'.....') & ~strcmp(data{1},'.') & ~strcmp(data{2},'.') & ~strcmp(data{3},'.') & ~strcmp(data{4},'.');
    
    isGood = 1;
    
    for d = 1:4
        
        data_clean{d} = data{d};                                                % copy data in array for cleaning
        data_clean{d}(~GoodQuallines) = {'1e100'};                              % replace NaNs with very small value
        data_clean{d} = data_clean{d}(Datalines);                               % remove indices that a meta lines
        data_clean{d} = data_clean{d}...                                        % omit a few extra measurements
            (1:round(el.sampleRate*(res.preludeSec(f)+res.cycleSec(f))));
        
        data_nums = cellfun(@str2double,data_clean{d});                            % convert data to numbers             
        data_nums(data_nums == 1e100) = NaN;                                    % replace bad values with NaNs
        
        res.trials.(vals{d})(tcnt,:) = data_nums;                               % store cleaned eye position href data

        if sum(isnan(data_nums)) > 0                                            % flag this trial is there's bad data
            isGood = 0;
        end
        
    end
    
    res.trials.condition{tcnt}  = cell2mat(condition);
    res.trials.dynamics{tcnt}   = cell2mat(dynamics);
    res.trials.direction{tcnt}  = cell2mat(direction);
    res.trials.trialnum(tcnt)   = trialnum;
    res.trials.isGood(tcnt)     = isGood;
    
    res.trials.extra_time(tcnt) = length(data{1}(Datalines)) - ...          % number of extra EL samples for diagnostics
            round(el.sampleRate*(res.preludeSec(f)+res.cycleSec(f)));
    
    tcnt = tcnt + 1;
    
end

