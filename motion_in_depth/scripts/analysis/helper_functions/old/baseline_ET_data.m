function [datNorm] = baseline_ET_data(dat,Sall,prelude_samples)


baseline = nanmean(dat(prelude_samples,:));

datNorm = dat - repmat(baseline,length(dat),1);


%datNorm = (Eall.dat - repmat(Eall.dat(prelude_samples,:),Sall.trialLength,1)) + baseline;

%Eall.vergenceHnormAbs = Eall.vergenceH - repmat(Eall.vergenceH(prelude_samples,:),Sall.trialLength,1);

%Eall.vergenceHnormAbs(:,Eall.isNear == -1) = -(Eall.vergenceH(:,Eall.isNear == -1) - repmat(Eall.vergenceH(prelude_samples,Eall.isNear == -1),Sall.trialLength,1));
