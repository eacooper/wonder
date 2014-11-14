function plot_results(subjs,conds,dirs,dyn,exp_name,res)
%
%

%conds = {'SingleDot','FullCue'};
%dirs  = {'towards','away','left','right'};
%dyn   = {'step','ramp'};


for s = 1:length(subjs)
    
    if strcmp(subjs(s),'All')
        subj_inds = ones(1,length(res.trials.subj));
    else
        subj_inds = strcmp(res.trials.subj,subjs{s});
        
    end
    
    for d = 1:length(dyn);
        
        f(d) = figure; hold on; setupfig(14,10,10);
        suptitle([subjs{s} ' ' dyn{d} ' L eye R eye']);
        
        %f(d*10) = figure; hold on; setupfig(14,10,10);
        %suptitle([subjs{s} ' ' dyn{d} 'Vergence/Version']);
        
        cnt = 1;
        
        for c = 1:length(conds)
            
            for r = 1:length(dirs);
                
                subplot(3,3,cnt); hold on; title([conds{c} ' ' dirs{r}]); box on;
                
                
                inds = find(subj_inds & ...
                    strcmp(res.trials.condition,conds{c}) & ...
                    strcmp(res.trials.dynamics,dyn{d})  & ...
                    strcmp(res.trials.direction,dirs{r})  & ...
                    strcmp(res.trials.exp_name,exp_name) & ...
                    res.trials.isGood == 1);
                
                dp = res.trials.vergenceH(inds,:);
                
                for t = 1:length(inds)
                    
                    figure(f(d)); hold on; subplot(3,3,cnt); hold on;
                    
                    [ax,h1,h2] = plotyy(1:length(res.trials.LExAng(inds(t),:)),res.trials.LExAng(inds(t),:),...
                        1:length(res.trials.RExAng(inds(t),:)),res.trials.RExAng(inds(t),:));
                    
                    set(h1,'color',ColorIt(2).^(0.1))
                    set(h2,'color',ColorIt(1).^(0.1))
                    set(ax(1),'YLim',[0 5],'Ycolor',ColorIt(2))
                    set(ax(2),'YLim',[-5 0],'Ycolor',ColorIt(1))
                    
                    %plot(res.trials.LExAng(inds(t),:),'color',ColorIt(1).^(0.1));
                    %plot(-res.trials.RExAng(inds(t),:),'color',ColorIt(2).^(0.1));
                    
                    %                     figure(f(d*10)); hold on; subplot(3,3,cnt); hold on;
                    %                     plot(res.trials.vergenceH(inds(t),:),'color',ColorIt(3).^(0.1));
                    %                     plot(res.trials.versionH(inds(t),:),'color',ColorIt(4).^(0.1));
                end
                
                figure(f(d)); hold on; subplot(3,3,cnt); hold on;
                
               [ax2,h1,h2] = plotyy(1:length(mean(res.trials.LExAng(inds,:),1)),mean(res.trials.LExAng(inds,:),1),...
                    1:length(mean(res.trials.LExAng(inds,:),1)),mean(res.trials.RExAng(inds,:),1));
                
                set(h1,'color',ColorIt(2))
                    set(h2,'color',ColorIt(1))
                    set(ax2(1),'YLim',[0 5],'Ycolor',ColorIt(2))
                    set(ax2(2),'YLim',[-5 0],'Ycolor',ColorIt(1))
                %plot(mean(res.trials.LExAng(inds,:),1),'color',ColorIt(1));
                %plot(mean(-res.trials.RExAng(inds,:),1),'color',ColorIt(2));
                
                if length(inds) > 0
                    [ax,h1,h2] = plotyy(1:length(res.trials.predictionLE(inds(1),:)),res.trials.predictionLE(inds(1),:),...
                    1:length(res.trials.predictionLE(inds(1),:)),res.trials.predictionRE(inds(1),:));
                    %plot(res.trials.predictionLE(inds(1),:),'color',ColorIt(1));
                    %plot(-res.trials.predictionRE(inds(1),:),'color',ColorIt(2));
                    
                    set(h1,'color',ColorIt(2))
                    set(h2,'color',ColorIt(1))
                    set(ax(1),'YLim',[0 5],'Ycolor',ColorIt(2))
                    set(ax(2),'YLim',[-5 0],'Ycolor',ColorIt(1))
                end
                
                

                ylabel('LE(+)/RE(-)');
                cnt = cnt + 1;
                
            end
            
        end
        
    end
    
end

