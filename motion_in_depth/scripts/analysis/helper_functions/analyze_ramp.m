function [] = analyze_ramp(filename)

set(0,'DefaultFigureWindowStyle','docked')

if isempty(filename)                                                            % open GUI to select files
    [filename,pathname,FilterIndex] = uigetfile({'*.asc' ; '*.mat'},...
        'Select Data Files to Load', '../data/ramps_ET/','MultiSelect','on');
end

if iscellstr(filename); filenames       = filename;                             % put filenames in cell structure
else                    filenames{1}    = filename; end

if length(filenames) == 1 && ~isempty(strfind(filename,'_proc'))                % load preprocessed data
    load([pathname filenames{1}]);
elseif length(filenames) > 1  && ~isempty(strfind(filename{1},'_proc'))         % combine preprocessed data from multiple subjs
    [Eall,Sall] = combine_multiple_subjects(pathname, filenames);
else                                                                            % process multiple individual sessions
    [Eall,Sall] = process_ET_data(pathname, filenames);
end

Eall = clean_ET_data(Eall,Sall);

plot_monocular_interaction(Eall,Sall);

keyboard

colors = {'k','r','b','m','k','r','b','m'};
lines = {'-',':'};
h = []; j = []; k = [];


k = plotEyeAngleMeans(Eall,trialSampleTime,colors,stimDisparity,k,sampleRate,preludeSec);
h = plotConditionMeans(Eall,trialSampleTime,colors,stimDisparity,h);
j = plotAbsolutes(Eall,trialSampleTime,colors,stimDisparity,j);
plotMonocularInteraction(Eall,trialSampleTime,colors,stimDisparity);



for x = unique(Eall.condition)
    
    figure(1); hold on;
    subplot(2,4,x); hold on; title(Sall.conditiontypes{x})
    plotEyeAngles(Eall,trialSampleTime,x);
    
    figure(2); hold on;
    subplot(2,4,x); hold on; title(Sall.conditiontypes{x})
    plotVergenceAngles(Eall,trialSampleTime,x);
    
    figure(3); hold on;
    subplot(2,4,x); hold on; title(Sall.conditiontypes{x})
    plotVersionAngles(Eall,trialSampleTime,x);
    
    
    figure(6); hold on;
    j = plotAbsolutes(Eall,trialSampleTime,x,colors,stimDisparity,j);
    
    
    
end
figure(1); hold on;
suptitle('Each Eye X Angles');
figure(2); hold on;
suptitle('Vergence Angles');
figure(3); hold on;
suptitle('Version Angles');
figure(6); hold on;
suptitle('Absolute Vergence and Version');



figure; hold on;
for x = 1:8
    
    bar(x,100*(sum(Eall.isCorrect(:,Eall.condition == x))./length(Eall.isCorrect(:,Eall.condition == x))));
    
end




keyboard


function [] = plotEyeAngles(Eall,trialSampleTime,x)

plot(trialSampleTime,Eall.LExAng(:,Eall.condition == x & Eall.isNear == 1),'-','LineWidth',0.5,'Color',[0.9 0.9 1]);
plot(trialSampleTime,Eall.LExAng(:,Eall.condition == x & Eall.isNear == -1),'-','LineWidth',0.5,'Color',[0.9 1 1]);
plot(trialSampleTime,Eall.RExAng(:,Eall.condition == x & Eall.isNear == 1),'-','LineWidth',0.5,'Color',[1 0.9 0.9]);
plot(trialSampleTime,Eall.RExAng(:,Eall.condition == x & Eall.isNear == -1),'-','LineWidth',0.5,'Color',[1 0.9 1]);

h(1) = plot(trialSampleTime,nanmean(Eall.LExAng(:,Eall.condition == x & Eall.isNear == 1),2),'-','LineWidth',0.5,'Color',[0 0 1]);
h(2) = plot(trialSampleTime,nanmean(Eall.LExAng(:,Eall.condition == x & Eall.isNear == -1),2),'-','LineWidth',0.5,'Color',[0 1 1]);

h(3) = plot(trialSampleTime,nanmean(Eall.RExAng(:,Eall.condition == x & Eall.isNear == 1),2),'-','LineWidth',0.5,'Color',[1 0 0]);
h(4) = plot(trialSampleTime,nanmean(Eall.RExAng(:,Eall.condition == x & Eall.isNear == -1),2),'-','LineWidth',0.5,'Color',[1 0 1]);

ylim([-5 5]);
xlim([0 max(trialSampleTime)]);

if x == 1
    legend(h,'LEx Near','LEx Far','REx Near','REx Far');
end


function [] = plotVergenceAngles(Eall,trialSampleTime,x)

plot(trialSampleTime,Eall.vergenceH(:,Eall.condition == x & Eall.isNear == 1),'-','LineWidth',0.5,'Color',[0.9 0.9 0.9])
plot(trialSampleTime,Eall.vergenceH(:,Eall.condition == x & Eall.isNear == -1),'-','LineWidth',0.5,'Color',[0.9 0.9 1])
plot(trialSampleTime,Eall.vergenceV(:,Eall.condition == x & Eall.isNear == 1),'-','LineWidth',0.5,'Color',[1 0.9 0.9])
plot(trialSampleTime,Eall.vergenceV(:,Eall.condition == x & Eall.isNear == -1),'-','LineWidth',0.5,'Color',[1 0.9 1])

h(1) = plot(trialSampleTime,nanmean(Eall.vergenceH(:,Eall.condition == x & Eall.isNear == 1),2),'-','LineWidth',0.5,'Color',[0 0 0]);
h(2) = plot(trialSampleTime,nanmean(Eall.vergenceH(:,Eall.condition == x & Eall.isNear == -1),2),'-','LineWidth',0.5,'Color',[0 0 1]);
h(3) = plot(trialSampleTime,nanmean(Eall.vergenceV(:,Eall.condition == x & Eall.isNear == 1),2),'-','LineWidth',0.5,'Color',[1 0 0]);
h(4) = plot(trialSampleTime,nanmean(Eall.vergenceV(:,Eall.condition == x & Eall.isNear == -1),2),'-','LineWidth',0.5,'Color',[1 0 1]);

ylim([-2 9]);
xlim([0 max(trialSampleTime)]);

if x == 1
    legend(h,'vergenceH Near','vergenceH Far','vergenceV Near','vergenceV Far');
end

function [] = plotVersionAngles(Eall,trialSampleTime,x)

plot(trialSampleTime,Eall.versionH(:,Eall.condition == x & Eall.isNear == 1),'-','LineWidth',0.5,'Color',[0.9 0.9 0.9])
plot(trialSampleTime,Eall.versionH(:,Eall.condition == x & Eall.isNear == -1),'-','LineWidth',0.5,'Color',[0.9 0.9 1])
plot(trialSampleTime,Eall.versionV(:,Eall.condition == x & Eall.isNear == 1),'-','LineWidth',0.5,'Color',[1 0.9 0.9])
plot(trialSampleTime,Eall.versionV(:,Eall.condition == x & Eall.isNear == -1),'-','LineWidth',0.5,'Color',[1 0.9 1])

h(1) = plot(trialSampleTime,nanmean(Eall.versionH(:,Eall.condition == x & Eall.isNear == 1),2),'-','LineWidth',0.5,'Color',[0 0 0]);
h(2) = plot(trialSampleTime,nanmean(Eall.versionH(:,Eall.condition == x & Eall.isNear == -1),2),'-','LineWidth',0.5,'Color',[0 0 1]);
h(3) = plot(trialSampleTime,nanmean(Eall.versionV(:,Eall.condition == x & Eall.isNear == 1),2),'-','LineWidth',0.5,'Color',[1 0 0]);
h(4) = plot(trialSampleTime,nanmean(Eall.versionV(:,Eall.condition == x & Eall.isNear == -1),2),'-','LineWidth',0.5,'Color',[1 0 1]);

ylim([-5 5]);
xlim([0 max(trialSampleTime)]);

if x == 1
    legend(h,'versionH Near','versionH Far','versionV Near','versionV Far');
end









