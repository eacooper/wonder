function plot_results(subjs,conds,dirs,dyn,exp_name,res,plt)
%
%


for p = 1:length(plt)
    
    for s = 1:length(subjs)
        
        if strcmp(subjs(s),'All')
            subj_inds = ones(1,length(res.trials.subj));
        else
            subj_inds = strcmp(res.trials.subj,subjs{s});
            
        end
        
        for d = 1:length(dyn);
            
            for c = 1:length(conds)
                
                            f(d) = figure; hold on; setupfig(10,10,10);
            suptitle([subjs{s} ' ' dyn{d} ' L eye R eye']);
            
            cnt = 1;
                
                for r = 1:length(dirs);
                    
                    subplot(2,2,cnt); hold on; title([conds{c} ' ' dirs{r}]); box on;
                    
                    
                    inds = find(subj_inds & ...
                        strcmp(res.trials.condition,conds{c}) & ...
                        strcmp(res.trials.dynamics,dyn{d})  & ...
                        strcmp(res.trials.direction,dirs{r})  & ...
                        strcmp(res.trials.exp_name,exp_name) & ...
                        res.trials.isGood == 1);
                    
                    figure(f(d)); hold on; subplot(2,2,cnt); hold on;
                    
                    for t = 1:length(inds)
                                              
                        switch plt{p}
                            
                            case 'monocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.LExAng(inds(t),:)),res.trials.LExAng(inds(t),:),...
                                    1:length(res.trials.RExAng(inds(t),:)),res.trials.RExAng(inds(t),:));
                                color_yy(ax,h1,h2,0,1);

                            case 'binocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.vergenceH(inds(t),:)),res.trials.vergenceH(inds(t),:),...
                                    1:length(res.trials.versionH(inds,:)),res.trials.versionH(inds,:));
                                color_yy(ax,h1,h2,0,0);
                                
                            case 'vergence'
                                
                                plot(1:length(res.trials.vergenceH(inds(t),:)),res.trials.vergenceH(inds(t),:),'color',ColorIt(3).^0.1);
                                
                                
                        end
                        
                        
                        
                        
                    end
                    
                    
                    
                    %figure(f(d)); hold on; subplot(2,2,cnt); hold on;
                    
                    switch plt{p}
                        
                        case 'monocular'
                            
                            [ax,h1,h2] = plotyy(1:length(mean(res.trials.LExAng(inds,:),1)),mean(res.trials.LExAng(inds,:),1),...
                                1:length(mean(res.trials.LExAng(inds,:),1)),mean(res.trials.RExAng(inds,:),1));
                            color_yy(ax,h1,h2,1,1);
                            
                        case 'binocular'
                            
                            [ax,h1,h2] = plotyy(1:length(mean(res.trials.vergenceH(inds,:),1)),mean(res.trials.vergenceH(inds,:),1),...
                                1:length(mean(res.trials.versionH(inds,:),1)),mean(res.trials.versionH(inds,:),1));
                            color_yy(ax,h1,h2,1,0);
                            
                        case 'vergence'
                            
                            plot(1:length(mean(res.trials.vergenceH(inds,:),1)),mean(res.trials.vergenceH(inds,:),1),'color',ColorIt(3));
                    end
                    
                    if length(inds) > 0
                        
                        switch plt{p}
                            
                            case 'monocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.predictionLE(inds(1),:)),res.trials.predictionLE(inds(1),:),...
                                    1:length(res.trials.predictionRE(inds(1),:)),res.trials.predictionRE(inds(1),:));
                                
                                color_yy(ax,h1,h2,1,1);
                                
                            case 'binocular'
                                
                                [ax,h1,h2] = plotyy(1:length(res.trials.predictionLE(inds(1),:)),res.trials.predictionLE(inds(1),:)...
                                    -res.trials.predictionRE(inds(1),:),...
                                    1:length(res.trials.predictionLE(inds(1),:)),mean([res.trials.predictionLE(inds(1),:) ; res.trials.predictionRE(inds(1),:)]));
                                
                                color_yy(ax,h1,h2,1,0);
                                
                            case 'vergence'
                                
                                plot(1:length(res.trials.predictionLE(inds(1),:)),res.trials.predictionLE(inds(1),:)...
                                    -res.trials.predictionRE(inds(1),:),'color',ColorIt(3));
                                
                        end
                        
                        
                    end
                    
                    %ylabel('LE(+)/RE(-)');
                    cnt = cnt + 1;
                    
                end
                
            end
            
        end
        
    end
    
end


function color_yy(ax,h1,h2,flag,flag2)

if(flag)
    
    set(h1,'color',ColorIt(2))
    set(h2,'color',ColorIt(1))
else
    
    set(h1,'color',ColorIt(2).^(0.1))
    set(h2,'color',ColorIt(1).^(0.1))
end


set(ax(1),'Ycolor',ColorIt(2))
set(ax(2),'Ycolor',ColorIt(1))

if(flag2)
    
    set(ax(1),'YLim',[0 5],'Ytick',0:5)
    set(ax(2),'YLim',[-5 0],'Ytick',-5:0)
    
    set(get(ax(1),'Ylabel'),'String','Left Eye Position')
    set(get(ax(2),'Ylabel'),'String','Right Eye Position')
    
else
    
    set(ax(1),'YLim',[6 8],'Ytick',6:8)
    set(ax(2),'YLim',[-1 1],'Ytick',-1:1)
    
end
