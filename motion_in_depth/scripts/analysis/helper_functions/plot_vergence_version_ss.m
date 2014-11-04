function [] = plot_vergence_version_ss(Eall,Sall,S,expType)

fontsz = 18;
offset = 0.2;

tracks = unique(Eall.trackFix);
tracks = 2;

if strcmp(expType,'ss')
    
    tmp = find(Eall.rampSize == 90);
    
    tmp = tmp(1);
    Sall.stimDisparity   = [zeros(1,Sall.preludeSec*Sall.sampleRate) ...                                   % stimulus disparity at each time point
        reshape(repmat(S(tmp).dat.allStepsPix.*(S(tmp).dat.pix2arcmin),Sall.sampleRate/S(tmp).dat.dotUpdateHz,1),...
        1,length(S(tmp).dat.allStepsPix)*Sall.sampleRate/S(tmp).dat.dotUpdateHz) ...
        zeros(1,Sall.preludeSec*Sall.sampleRate)]./60;
end

for t = 1:length(tracks)
    
    track = tracks(t);
    
    ramps = unique(Eall.rampSize);
    ramps = 90;
    
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
        
            
            if strcmp(expType,'ss') && conditionOrder(c) > 4; continue; end
            
            inds = Eall.condition == conditionOrder(c) & Eall.rampSize == ramp & Eall.trackFix == track;
            
            versionH = nanmean([Eall.versionH(:,inds & Eall.isNear == 1) ...
                -Eall.versionH(:,inds & Eall.isNear == -1)],2);
            
            vergenceH = nanmean([Eall.vergenceH(:,inds & Eall.isNear == 1) ...
                -Eall.vergenceH(:,inds & Eall.isNear == -1)],2);
            
            versionHS = nanstd([Eall.versionH(:,inds & Eall.isNear == 1) ...
                -Eall.versionH(:,inds & Eall.isNear == -1)],[],2);
            
            vergenceHS = nanstd([Eall.vergenceH(:,inds & Eall.isNear == 1) ...
                -Eall.vergenceH(:,inds & Eall.isNear == -1)],[],2);
            
            
            goodTrialInds = sum(isnan(Eall.RExAng),1) ~= Sall.trialLength;
            goodTrialInds = inds & goodTrialInds;
            goodTrials = sum(goodTrialInds);
            
            PCorr = 100*sum(Eall.isCorrect(:,goodTrialInds))...
                /sum(Eall.probes(:,goodTrialInds));
            
%             if strcmp(expType,'ramps')
%                 
%                 subplot(2,3,c);
%             else
%                 subplot(2,3,c-3)
%             end
            %subaxis(2,3,c,'Spacing',0.01, 'Padding', 0.04, 'Margin', 0.05);
            hold on;
            title(labels{label_inds(c)},'FontSize',fontsz); box on; set(gca,'FontSize',fontsz)
            
            
            if conditionOrder(c) > 4
                plot(Sall.trialSampleTime,zeros(1,offset+length(Sall.trialSampleTime)),'--','LineWidth',1,'Color','k');
                %plot(Sall.trialSampleTime,-Sall.stimDisparity/2,':','LineWidth',0.5,'Color','m');
                
                
            else
                
                %plot(Sall.trialSampleTime,zeros(1,length(Sall.trialSampleTime)),'--','LineWidth',1,'Color','m');
                plot(Sall.trialSampleTime,-Sall.stimDisparity,':','LineWidth',0.5,'Color','k');
                
            end
            
            %plot([Sall.preludeSec Sall.preludeSec],[-0.2 0.9],'k--');
            
            %h(1) = shadedErrorBar(Sall.trialSampleTime,versionH,versionHS/sqrt(goodTrials),'m-');
            shadedErrorBar(Sall.trialSampleTime,vergenceH,vergenceHS/sqrt(goodTrials),'k-');
            
            if strcmp(expType,'ramps')
                text(0.33,0.45,[num2str(goodTrials) ' trials'],'FontSize',14);
                text(0.33,0.4,[num2str(PCorr,3) '% correct'],'FontSize',14);
                xlim([.25 1]);
            else
                text(0.33,1.8,[num2str(goodTrials) ' trials'],'FontSize',14);
                %text(0.33,0.4,[num2str(PCorr,3) '% correct'],'FontSize',14);
                xlim([0 max(Sall.trialSampleTime)]);
            end
            
            
            
            %axis square; 
            xlabel('Time (Sec)');
            ylim([-0.5 2]);
            
            %if c == 1
            %    legend([h(1).mainLine h(2).mainLine],'Version','Vergence');
            %end
            if label_inds(c) == 1
                ylabel('Vergence (Deg)');
            end
            
            fn = ['../plots/' expType '_bino_verg_cond' num2str(c) '_' Sall.subj '.pdf'];
export_fig(fn)
            
        end
        
    end
    
end

%fn = ['../plots/bino_' datestr(clock,'mm_dd_yy_HHMMSS') '.pdf'];

