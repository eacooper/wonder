function [] = plot_individual_conditions(Eall,Sall)


fontsz = 18;

tracks = unique(Eall.trackFix);

for t = 1:length(tracks)
    
    track = tracks(t);
    
    ramps = unique(Eall.rampSize);
    
    for r = 1:length(ramps)
        
        ramp = ramps(r);
        
        %suptitle(Sall.subj);
        
        conditionOrder = [7 5 6 3 1 2];
        label_inds = [1 2 3 1 2 3];
        labels = {'Correlated + Constant','Uncorrelated + Constant','Correlated + Changing'};
        
        for c = 1:length(conditionOrder)
            
            figure; hold on;
            set(gcf,'color','w');
            set(findall( gcf,'type','text'),'fontSize',fontsz,'fontWeight','normal')

            suptitle(labels{label_inds(c)});
            
            subjs_orig = unique(Eall.subj);
            
            subjs = [subjs_orig 100];
            
            for s = 1:length(subjs)
                
                subj = subjs(s);
                
                if subj <= length(subjs_orig)
                    inds = Eall.condition == conditionOrder(c) & Eall.rampSize == ramp & Eall.trackFix == track & Eall.subj == subj;
                    sn = ['subj ' num2str(subj)];
                else
                    inds = Eall.condition == conditionOrder(c) & Eall.rampSize == ramp & Eall.trackFix == track;
                    sn = 'all';
                end
                
                %inds = Eall.condition == conditionOrder(c) & Eall.rampSize == ramp & Eall.trackFix == track;
                
                RExAng = nanmean([Eall.RExAng(:,inds & Eall.isNear == 1) ...
                    -Eall.RExAng(:,inds & Eall.isNear == -1)],2);
                
                LExAng = nanmean([Eall.LExAng(:,inds & Eall.isNear == 1) ...
                    -Eall.LExAng(:,inds & Eall.isNear == -1)],2);
                
                RExAngS = nanstd([Eall.RExAng(:,inds & Eall.isNear == 1) ...
                    -Eall.RExAng(:,inds & Eall.isNear == -1)],[],2);
                
                LExAngS = nanstd([Eall.LExAng(:,inds & Eall.isNear == 1) ...
                    -Eall.LExAng(:,inds & Eall.isNear == -1)],[],2);
                
                %PCorr = 100*sum(Eall.isCorrect(:,Eall.condition == conditionOrder(c)))...
                %    /length(Eall.isCorrect(:,Eall.condition == conditionOrder(c)));
                
                %PCorr = 100*sum(Eall.isCorrect(:,inds))...
                %    /sum(Eall.probes(:,inds));
                
                goodTrialInds = sum(isnan(Eall.RExAng),1) ~= Sall.trialLength;
                goodTrialInds = inds & goodTrialInds;
                goodTrials = sum(goodTrialInds);
                
                PCorr = 100*sum(Eall.isCorrect(:,goodTrialInds))...
                    /sum(Eall.probes(:,goodTrialInds));
                
                subplot(2,3,s); hold on; box on; set(gca,'FontSize',fontsz)
                
                
                if conditionOrder(c) > 4
                    plot(Sall.trialSampleTime,-Sall.stimDisparity/2,'--','LineWidth',1,'Color','r');
                    plot(Sall.trialSampleTime,-Sall.stimDisparity/2,':','LineWidth',1,'Color','b');
                else
                    plot(Sall.trialSampleTime,Sall.stimDisparity/2,'--','LineWidth',1,'Color','r');
                    plot(Sall.trialSampleTime,-Sall.stimDisparity/2,':','LineWidth',1,'Color','b');
                end
                
                %goodTrials = sum(sum(isnan(Eall.RExAng(:,inds)),1) ~= Sall.trialLength);
                
                h(1) = shadedErrorBar(Sall.trialSampleTime,RExAng,RExAngS/sqrt(goodTrials),'r-');
                h(2) = shadedErrorBar(Sall.trialSampleTime,LExAng,LExAngS/sqrt(goodTrials),'b-');
                
                text(0.2,0.85,[sn],'FontSize',14,'FontAngle','italic');
                text(0.2,0.75,[num2str(goodTrials) ' trials'],'FontSize',14);
                text(0.2,0.65,[num2str(PCorr,3) '% correct'],'FontSize',14);
                
                axis square; xlabel('Time (Sec)');  xlim([0 max(Sall.trialSampleTime)]);
                ylim([-0.9 0.9]);
                
                if s == 1
                    legend([h(1).mainLine h(2).mainLine],'Right Eye','Left Eye','Location','SouthEast');
                    
                end
                if label_inds(s) == 1
                    ylabel('Eye Angle (Deg)');
                end
                
            end
            
            fn = ['../plots/mono_' Sall.subj '_cond' num2str(c) '.pdf'];
            export_fig(fn)
            
        end
        
    end
    
end

