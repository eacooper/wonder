function [] = plot_IOVD_accuracy(Eall,Sall)

tracks = unique(Eall.trackFix);

for t = 1:length(tracks)
    
    track = tracks(t);
    
    ramps = unique(Eall.rampSize);
    
    for r = 1:length(ramps)
        
        ramp = ramps(r);
        
        figure; hold on;
        set(gcf,'color','w');
        set(findall( gcf,'type','text'),'fontSize',16,'fontWeight','normal')
        
        subjs = unique(Eall.subj);
        
        for s = 1:length(subjs)
            
            subj = subjs(s);
            
            inds = Eall.condition == 1 & Eall.rampSize == ramp & Eall.trackFix == track & Eall.subj == subj;
            
            versionH = nanmean([Eall.versionH(:,inds & Eall.isNear == 1) ...
                -Eall.versionH(:,inds & Eall.isNear == -1)],2);
            
            vergenceH = nanmean([Eall.vergenceH(:,inds & Eall.isNear == 1) ...
                -Eall.vergenceH(:,inds & Eall.isNear == -1)],2);

            vergence_max = mean(vergenceH(abs(Sall.stimDisparity) == max(abs(Sall.stimDisparity))));
            version_max = mean(versionH(abs(Sall.stimDisparity) == max(abs(Sall.stimDisparity))));
            
            goodTrialInds = sum(isnan(Eall.RExAng),1) ~= Sall.trialLength;
            goodTrialInds = inds & goodTrialInds;
            goodTrials = sum(goodTrialInds);
            
            PCorr = 100*sum(Eall.isCorrect(:,goodTrialInds))...
                /sum(Eall.probes(:,goodTrialInds));
            
            subplot(2,3,1); hold on; ylabel('response accuracy','FontSize',14); box on; set(gca,'FontSize',14)
            plot(vergence_max,PCorr,'ko');

            
            subplot(2,3,2); hold on; title('IOVD accuracy','FontSize',14); box on; set(gca,'FontSize',14)
            plot(version_max,PCorr,'ko');
            
            
        end
        
    end
    
end

fn = ['../plots/iovdacc_' datestr(clock,'mm_dd_yy_HHMMSS')];
export_fig(fn)
