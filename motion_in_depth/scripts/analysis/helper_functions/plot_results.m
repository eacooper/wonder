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
        
    case 'velocity'
        
        LE = 'LExAngVelo';
        RE = 'RExAngVelo';
        Verg = 'vergenceH';
        Vers = 'versionH';
        
end


% for each requested plot type
for p = 1:length(plt)
    
    
    % for each subject (should really only be one ever)
    for s = 1:length(subjs)
        
        
        % get data indices (use all indices if 'All' subject selected)
        if strcmp(subjs(s),'All')
            subj_trial_inds = ones(1,length(res.trials.subj));
            subj_session_inds = ones(1,length(res.subj));
        else
            subj_trial_inds = strcmp(res.trials.subj,subjs{s});
            subj_session_inds = strcmp(res.subj,subjs{s});
        end
        
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
                    inds_all = subj_trial_inds & ...
                        strcmp(res.trials.condition,conds{c}) & ...
                        strcmp(res.trials.dynamics,dyn{d})  & ...
                        strcmp(res.trials.direction,dirs{r})  & ...
                        strcmp(res.trials.exp_name,exp_name);
                    
                    % clean out trials with blinks and bad stimulus timing
                    inds = find(inds_all & ...
                        res.trials.isGood == 1 & ...
                        res.trials.goodTiming);
                    
                    display(['plotting data for ' num2str(numel(inds)) ' good trials out of ' num2str(sum(inds_all)) ' total']);
                    
                    % for each trials
                    for t = 1:length(inds)
                        
                        % plot requested result type
                        switch plt{p}
                            
                            case 'monocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.(LE){inds(t)}),res.trials.(LE){inds(t)},...
                                    1:length(res.trials.(RE){inds(t)}),res.trials.(RE){inds(t)});
                                color_yy(ax,h1,h2,0,1);
                                
                                set(ax(1),'YLabel',[])
                                set(ax(2),'YLabel',[])
                                
                            case 'binocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.vergenceH{inds(t)}),res.trials.vergenceH{inds(t)},...
                                    1:length(res.trials.versionH{inds(t)}),res.trials.versionH{inds(t)});
                                color_yy(ax,h1,h2,0,0);
                                
                                set(ax(1),'YLabel',[])
                                set(ax(2),'YLabel',[])
                                
                            case 'vergence'
                                
                                plot(1:length(res.trials.vergenceH{inds(t)}),res.trials.vergenceH{inds(t)},'color',ColorIt(3).^0.1);
                                
                            case 'version'
                                
                                plot(1:length(res.trials.versionH{inds(t)}),res.trials.versionH{inds(t)},'color',ColorIt(4).^0.1);
                                
                        end
                        
                    end
                    
                    % now plot average of all trials
                    switch plt{p}
                        
                        case 'monocular'
                            
                            [ax,h1,h2] = plotyy(1:length(mean(cell2mat(res.trials.LExAng(inds)),2)),mean(cell2mat(res.trials.LExAng(inds)),2),...
                                1:length(mean(cell2mat(res.trials.RExAng(inds)),2)),mean(cell2mat(res.trials.RExAng(inds)),2));
                            color_yy(ax,h1,h2,1,1);
                            
                        case 'binocular'
                            
                            [ax,h1,h2] = plotyy(1:length(mean(cell2mat(res.trials.vergenceH(inds)),2)),mean(cell2mat(res.trials.vergenceH(inds)),2),...
                                1:length(mean(cell2mat(res.trials.versionH(inds)),2)),mean(cell2mat(res.trials.versionH(inds)),2));
                            color_yy(ax,h1,h2,1,0);
                            
                        case 'vergence'
                            
                            plot(1:length(mean(cell2mat(res.trials.vergenceH(inds)),2)),mean(cell2mat(res.trials.vergenceH(inds)),2),'color',ColorIt(3));
                            
                        case 'version'
                            
                            plot(1:length(mean(cell2mat(res.trials.versionH(inds)),2)),mean(cell2mat(res.trials.versionH(inds)),2),'color',ColorIt(4));
                    end
                    
                    % ...and prediction
                    if length(inds) > 0
                        
                        switch plt{p}
                            
                            case 'monocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.predictionLE{inds(1)}),res.trials.predictionLE{inds(1)},...
                                    1:length(res.trials.predictionRE{inds(1)}),res.trials.predictionRE{inds(1)});
                                
                                color_yy(ax,h1,h2,1,1);
                                
                            case 'binocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.predictionLE{inds(1)}),res.trials.predictionLE{inds(1)}...
                                    -res.trials.predictionRE{inds(1)},...
                                    1:length(res.trials.predictionLE{inds(1)}),mean([res.trials.predictionLE{inds(1)} ; res.trials.predictionRE{inds(1)}]));
                                
                                color_yy(ax,h1,h2,1,0);
                                
                            case 'vergence'
                                
                                plot(1:length(res.trials.predictionLE{inds(1)}),res.trials.predictionLE{inds(1)}...
                                    -res.trials.predictionRE{inds(1)},'color',ColorIt(3));
                                
                            case 'version'
                                
                                plot(1:length(res.trials.predictionLE{inds(1)}),...
                                    mean([res.trials.predictionLE{inds(1)} ; res.trials.predictionRE{inds(1)}]),'color',ColorIt(4));    
                                
                        end
                        
                        
                    end
                    
                    cnt = cnt + 1;      % increment subplot counter
                    
                end
                
            end
            
        end
        
    end
    
end


function color_yy(ax,h1,h2,flag1,flag2)
%
% adjust plotting colors

if(flag1)
    set(h1,'color',ColorIt(2))
    set(h2,'color',ColorIt(1))
else
    set(h1,'color',ColorIt(2).^(0.1))
    set(h2,'color',ColorIt(1).^(0.1))
end


set(ax(1),'Ycolor',ColorIt(2))
set(ax(2),'Ycolor',ColorIt(1))

if(flag2)
    
    % set(ax(1),'YLim',[0 5],'Ytick',0:5)
    % set(ax(2),'YLim',[-5 0],'Ytick',-5:0)
    
    set(ax(1),'YLim',[0 9],'Ytick',0:9)
    set(ax(2),'YLim',[-7 2],'Ytick',-7:2)
    
    set(get(ax(1),'Ylabel'),'String','Left Eye Position (deg)')
    set(get(ax(2),'Ylabel'),'String','Right Eye Position (deg)')
    
else
    
    set(ax(1),'YLim',[6 8],'Ytick',6:8)
    set(ax(2),'YLim',[-1 1],'Ytick',-1:1)
    
    set(get(ax(1),'Ylabel'),'String','Vergence (deg)')
    set(get(ax(2),'Ylabel'),'String','Version (deg)')
    
end
