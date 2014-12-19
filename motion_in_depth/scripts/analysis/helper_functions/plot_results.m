function plot_results(subjs,conds,dirs,dyn,exp_name,res,plt,datatype)
%
% use settings from analysis GUI to generate results plots

% deal with two possible data types
switch datatype
    
    case 'position'
        
        LE = 'LExAng';
        RE = 'RExAng';
        Verg = 'vergenceH';
        Vers = 'versionH';
        predLE = 'predictionLE';
        predRE = 'predictionRE';
        
    case 'velocity'
        
        LE = 'LExAngVelo';
        RE = 'RExAngVelo';
        Verg = 'vergenceHVelo';
        Vers = 'versionHVelo';
        predLE = 'predictionLEVelo';
        predRE = 'predictionREVelo';
        
end


% for each requested plot type
for p = 1:length(plt)
    
    
    % for each subject (should really only be one ever)
    for s = 1:length(subjs)
        
        
        % get data indices for trials and exp sessions (use all indices if 'All' subject selected)
        [subj_trial_inds, subj_session_inds] = get_subject_indices(subjs,s,res);
        
        % get calibration quality numbers
        cali_inds = subj_session_inds & strcmp(res.exp_name,exp_name);
        cali_LE_mean = mean(res.calibrationAvgLeftError(cali_inds));
        cali_RE_mean = mean(res.calibrationAvgRightError(cali_inds));
        
        % for each condition dynamics type (e.g., step, stepramp...)
        for d = 1:length(dyn);
            
            
            % for each stimulus condition (e.g., Single Dot, Full Cue...)
            for c = 1:length(conds)
                
                
                % open a new figure
                f(d) = figure; hold on; setupfig(10,10,10);
                suptitle([subjs{s} ' ' dyn{d} ' ' plt{p} ' ( L err ' num2str(cali_LE_mean,2) 'deg R err ' num2str(cali_RE_mean,2) 'deg )']);
                cnt = 1;     % subplot counter
                
                
                % for each motion direction
                for r = 1:length(dirs);
                    
                    
                    % open a subplot
                    subplot(2,2,cnt); hold on; title([conds{c} ' ' dirs{r}]); box on;
                    
                    % get the indices in the data matrix for this combination
                    inds_all = subj_trial_inds & ...                % this subject
                        strcmp(res.trials.condition,conds{c}) & ... % these conditions
                        strcmp(res.trials.dynamics,dyn{d})  & ...   % these dynamicss
                        strcmp(res.trials.direction,dirs{r})  & ... % these directions
                        strcmp(res.trials.exp_name,exp_name);       % this experiment
                    
                    % clean out trials with blinks and bad stimulus timing
                    inds = find(inds_all & ...
                        res.trials.isGood == 1 & ...                % ET data is good
                        res.trials.goodTiming);                     % timing is good
                    
                    % get time points
                    time_points = res.trials.recordingTimePointsSec{inds(1)};
                    time_points_pred = res.trials.prediction_time_points{inds(1)};
                    
                    
                    display(['plotting data for ' num2str(numel(inds)) ' good trials out of ' num2str(sum(inds_all)) ' total']);
                    
                    
                    % draw the plots for this trial, depending on
                    % requested plot type
                    make_plots(plt{p},res,inds,predLE,predRE,LE,RE,Verg,Vers,time_points,time_points_pred);
                    
                    cnt = cnt + 1;      % increment subplot counter
                    
                end
                
            end
            
        end
        
    end
    
end

