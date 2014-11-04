function [] = plot_monocular_interaction(Eall,Sall,expType)


fontsz = 18;

tracks = unique(Eall.trackFix);
tracks = 2;

for t = 1:length(tracks)
    
    track = tracks(t);
    
    ramps = unique(Eall.rampSize);
    
    for r = 1:length(ramps)
        
        ramp = ramps(r);
        
        figure; hold on;
        set(gcf,'color','w');
        set(findall( gcf,'type','text'),'fontSize',fontsz,'fontWeight','normal')
        
        %suptitle(Sall.subj);
        
        conditionOrder = [7 5 6 3 1 2];
        label_inds = [1 2 3 1 2 3];
        labels = {'Correlated + Constant','Uncorrelated + Constant','Correlated + Changing'};
        
        for c = 1:length(conditionOrder)
            
            inds = Eall.condition == conditionOrder(c) & Eall.rampSize == ramp & Eall.trackFix == track;
            
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
            
            subplot(2,3,c); hold on; title(labels{label_inds(c)},'FontSize',fontsz); box on; set(gca,'FontSize',fontsz)
            
            
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
            
            text(0.2,0.8,[num2str(goodTrials) ' trials'],'FontSize',14);
            text(0.2,0.7,[num2str(PCorr,3) '% correct'],'FontSize',14);
            
            axis square; xlabel('Time (Sec)');  xlim([0 max(Sall.trialSampleTime)]);
            ylim([-0.9 0.9]);
            
            if c == 1
                legend([h(1).mainLine h(2).mainLine],'Right Eye','Left Eye','Location','SouthEast');
                
            end
            if label_inds(c) == 1
                ylabel('Eye Angle (Deg)');
            end
            
        end
        
    end
    
end

%fn = ['../plots/mono_' datestr(clock,'mm_dd_yy_HHMMSS') '.pdf'];
fn = ['../plots/' expType '_mono_' Sall.subj '.pdf'];
export_fig(fn)
