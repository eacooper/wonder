function [] = plot_vergence_version(Eall,Sall)

fontsz = 18;
offset = 0.2;

tracks = unique(Eall.trackFix);

colr = {'r','b','k'};

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
            
            versionH = nanmean([Eall.versionH(:,inds & Eall.isNear == 1) ...
                -Eall.versionH(:,inds & Eall.isNear == -1)],2);
            
            vergenceH = nanmean([Eall.vergenceH(:,inds & Eall.isNear == 1) ...
                -Eall.vergenceH(:,inds & Eall.isNear == -1)],2);
            
            versionHS = nanstd([Eall.versionH(:,inds & Eall.isNear == 1) ...
                -Eall.versionH(:,inds & Eall.isNear == -1)],[],2);
            
            vergenceHS = nanstd([Eall.vergenceH(:,inds & Eall.isNear == 1) ...
                -Eall.vergenceH(:,inds & Eall.isNear == -1)],[],2);
            
            %PCorr = 100*sum(Eall.isCorrect(:,Eall.condition == conditionOrder(c)))...
            %    /length(Eall.isCorrect(:,Eall.condition == conditionOrder(c)));
            
            %PCorr = 100*sum(Eall.isCorrect(:,inds))...
            %    /sum(Eall.probes(:,inds));
            
            goodTrialInds = sum(isnan(Eall.RExAng),1) ~= Sall.trialLength;
            goodTrialInds = inds & goodTrialInds;
            goodTrials = sum(goodTrialInds);
            
            PCorr = 100*sum(Eall.isCorrect(:,goodTrialInds))...
                /sum(Eall.probes(:,goodTrialInds));
            
            if conditionOrder(c) > 4
            subplot(1,2,1);
            %subaxis(2,3,c,'Spacing',0.01, 'Padding', 0.04, 'Margin', 0.05);
            hold on; 
            title('Lateral Motion Version','FontSize',fontsz); box on; set(gca,'FontSize',fontsz)
            
            
%             if conditionOrder(c) > 4
%                 plot(Sall.trialSampleTime,zeros(1,offset+length(Sall.trialSampleTime)),'--','LineWidth',1,'Color','k');
%                 plot(Sall.trialSampleTime,-Sall.stimDisparity/2,':','LineWidth',0.5,'Color','m');
%                 
%                 
%             else
%                 plot(Sall.trialSampleTime,zeros(1,length(Sall.trialSampleTime)),'--','LineWidth',1,'Color','m');
%                 plot(Sall.trialSampleTime,offset+-Sall.stimDisparity,':','LineWidth',0.5,'Color','k');
%             end
            
            plot([Sall.preludeSec Sall.preludeSec],[-0.2 0.9],'k--');
            
            %goodTrialInds = sum(isnan(Eall.RExAng(:,inds)),1) ~= Sall.trialLength;
            %goodTrials = sum(sum(isnan(Eall.RExAng(:,inds)),1) ~= Sall.trialLength);
            
            h(label_inds(c)) = shadedErrorBar(Sall.trialSampleTime,versionH,versionHS/sqrt(goodTrials),colr{label_inds(c)});
            %h(2) = shadedErrorBar(Sall.trialSampleTime,offset+vergenceH,vergenceHS/sqrt(goodTrials),'k-');
            
            else
                
                            subplot(1,2,2);
            %subaxis(2,3,c,'Spacing',0.01, 'Padding', 0.04, 'Margin', 0.05);
            hold on; 
            title('Motion-in-Depth Vergence','FontSize',fontsz); box on; set(gca,'FontSize',fontsz)
            
            plot([Sall.preludeSec Sall.preludeSec],[-0.2 0.9],'k--');
            
            shadedErrorBar(Sall.trialSampleTime,vergenceH,vergenceHS/sqrt(goodTrials),colr{label_inds(c)});
            
            end
            %text(0.33,0.45,[num2str(goodTrials) ' trials'],'FontSize',14);
            %text(0.33,0.4,[num2str(PCorr,3) '% correct'],'FontSize',14);
            
            axis square; xlabel('Time (Sec)'); xlim([.25 1]);
            ylim([-0.1 0.5]);
            

            %if c == 1
            %    legend([h(1).mainLine h(2).mainLine],'Version','Vergence');
            %end
            if label_inds(c) == 1
                ylabel('Eye Angle (Deg)');
            end
            
        end
        
                    legend([h(1).mainLine h(2).mainLine h(3).mainLine],'Correlated + Constant','Uncorrelated + Constant','Correlated + Changing');
            
        
    end
    
end

%fn = ['../plots/bino_' datestr(clock,'mm_dd_yy_HHMMSS') '.pdf'];
fn = ['../plots/bino_conditions_' Sall.subj '.pdf'];
export_fig(fn)
