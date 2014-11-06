function res = get_trial_data(res)
%
%

% fields that must be the same to combine data
fieldsSame = {'display','recording','training','stimRadDeg','dispArcmin',...
    'dotSizeDeg','dotDensity','preludeSec','cycleSec','dotUpdateHz','numCycles'};

% fields that can differ
fieldsDiffer = {'subj','exp_name'};

fields = [fieldsSame fieldsDiffer];

tcnt = 1;
for f = 1:length(res.fullpath)
    
    % experiment and response data
    load(res.fullpath{f});
    
    % fill in each field
    for i = 1:numel(fields)
        
        if isstr(dat.(fields{i}))
            res.(fields{i}){f} =  dat.(fields{i});
        else
            res.(fields{i})(f) =  dat.(fields{i});
        end  
        
    end
    
    % load and store calibration info
    
    % load eyetracking data
    eld     = eyelink_import_data(strrep(strrep(res.fullpath{f},'stimulus','tracking'),'mat','asc'));
    starts  = find(~cellfun(@isempty,strfind(eld.f2,'STARTTIME')));
    stops   = find(~cellfun(@isempty,strfind(eld.f2,'STOPTIME')));
    
    for s = 1:length(starts)
        
        flags = {eld.f1{starts(s)+1:stops(s)-1}};
        qual = {eld.f8{starts(s)+1:stops(s)-1}};
        
        data{1} = {eld.f2{starts(s)+1:stops(s)-1}};     % LE x
        data{2} = {eld.f3{starts(s)+1:stops(s)-1}};     % LE y
        data{3} = {eld.f5{starts(s)+1:stops(s)-1}};     % RE x
        data{4} = {eld.f6{starts(s)+1:stops(s)-1}};     % RE y
        
        % indices to keep
        Datalines       = ~cellfun(@isempty,cellfun(@str2num,flags,'un',0));
        GoodQuallines   = strcmp(qual,'.....');

        for d = 1:length(data)
            
            data_clean{d} = data{d};
            data_clean{d}(~GoodQuallines) = {NaN};
            data_clean{d} = data{d}(Datalines);
            
        end
        
        res.trials.LEx(tcnt,:) = cellfun(@str2num,data_clean{1});
        res.trials.LEy(tcnt,:) = cellfun(@str2num,data_clean{2});
        res.trials.REx(tcnt,:) = cellfun(@str2num,data_clean{3});
        res.trials.REy(tcnt,:) = cellfun(@str2num,data_clean{4});
        
        tcnt = tcnt + 1;
        
    end
    
    
    
    res.allinfo(f) = dat;
    
end




% % flip U/D HREF coords to get into proper coordinate system (pos/neg: up/down, right/left)
% Eall.rawData{trialCnt}(lineCnt,:)   = Line;
% Eall.LEx(lineCnt,trialCnt)          = Line(2).*href2cm;
% Eall.LEy(lineCnt,trialCnt)          = -Line(3).*href2cm;
% Eall.REx(lineCnt,trialCnt)          = Line(5).*href2cm;
% Eall.REy(lineCnt,trialCnt)          = -Line(6).*href2cm;
% 
% Eall.LExAng(lineCnt,trialCnt)       = convert_screen_to_deg(ipd,href_dist,Eall.LEx(lineCnt,trialCnt));
% Eall.LEyAng(lineCnt,trialCnt)       = convert_screen_to_deg(ipd,href_dist,Eall.LEy(lineCnt,trialCnt));
% Eall.RExAng(lineCnt,trialCnt)       = convert_screen_to_deg(-ipd,href_dist,Eall.REx(lineCnt,trialCnt));
% Eall.REyAng(lineCnt,trialCnt)       = convert_screen_to_deg(ipd,href_dist,Eall.REy(lineCnt,trialCnt));
% 
% Eall.vergenceH(lineCnt,trialCnt)    = Eall.LExAng(lineCnt,trialCnt) - Eall.RExAng(lineCnt,trialCnt);
% Eall.vergenceV(lineCnt,trialCnt)    = Eall.LEyAng(lineCnt,trialCnt) - Eall.REyAng(lineCnt,trialCnt);
% 
% Eall.versionH(lineCnt,trialCnt)     = mean([Eall.LExAng(lineCnt,trialCnt) Eall.RExAng(lineCnt,trialCnt)]);
% Eall.versionV(lineCnt,trialCnt)     = mean([Eall.LEyAng(lineCnt,trialCnt) Eall.REyAng(lineCnt,trialCnt)]);
% 
% Eall.saccadeStart(lineCnt,trialCnt) = 0;