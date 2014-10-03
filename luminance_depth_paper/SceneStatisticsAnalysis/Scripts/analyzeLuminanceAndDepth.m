function [] = analyzeLuminanceAndDepth()

% This function takes in the data structure built by buildPatchDataStruct
% and runs the increment/decrement depth analysis
%
% Emily Cooper, Stanford University 2014

close all;
set(0,'DefaultFigureWindowStyle','docked')
set(0,'DefaultAxesFontSize', 18)
set(0,'DefaultAxesFontWeight', 'Normal')
set(0,'DefaultTextFontSize', 18)
set(0, 'DefaultAxesBox', 'on');
set(0,'defaultlinelinewidth',3)

%LI threshhold
thresh = 0.05; %percent preference required for scene points and cells to be considered an inc or dec

%do you want to show an image with a bunch of example patches
showPatches = 1;

% Load in data
load(['patchInfoNature_1.5degradius_15to30ppd.mat'])

%some patch info
display(['radius : ' num2str(patch_radius_deg)]);
display(['michelson contrast threshhold : ' num2str(thresh)]);
display(['total number of patches: ' num2str(length(patchLum))]);
display(['total number of scenes: ' num2str(length(unique(patchScene)))]);
display(['min arcmin per pixel: ' num2str(min(60*((patch_radius_deg*2)./patchSizePix)))]);
display(['max arcmin per pixel: ' num2str(max(60*((patch_radius_deg*2)./patchSizePix)))]);
display(['central depth region is on average this wide: ' num2str(median(60*((patch_radius_deg*2)./patchSizePix))*7)]);

%initialize space for data mats
allvalsRawA     = NaN.*ones(length(patchLum)*5000,1); %raw luminance values
allvalsA        = NaN.*ones(length(patchLum)*5000,1); %michelson contrast
allZsA          = NaN.*ones(length(patchLum)*5000,1); %raw depth values
allZsMeanA      = NaN.*ones(length(patchLum)*5000,1); %central patch depth
allDsA          = NaN.*ones(length(patchLum)*5000,1); %calculated disparities

%counters
ind1 = 1; %pixel indices
cnt = 1; %patch indices

%for each patch
for p = 1:length(patchLum)
    
    %display(num2str(p));
    
    %determine circle cropping region for this square patch
    patchSize = size(patchLum{p},1);
    [xx,yy]=ndgrid(1:patchSize, 1:patchSize);
    pRad = floor(patchSize/2);
    CroppingMask= ( (xx-ceil(patchSize/2)).^2+(yy-ceil(patchSize/2)).^2<=pRad^2 );
    
    % LUMINANCE VALUES
    
    %set values outside circle to NaN
    patchLum{p}(~CroppingMask) = NaN;
    patchDepth{p}(~CroppingMask) = NaN;
    
    %exclude exact zero luminances, which are caused by sensor artifacts
    patchLum{p}(patchLum{p} == 0) = NaN;
    
    %mean luminance of patch
    meanval = nanmean(patchLum{p}(:));
    
    %convert values to michelson contrast
    allvals = patchLum{p}(~isnan(patchLum{p}) & ~isnan(patchDepth{p}));
    allvalsnorm = (allvals - meanval)./...
        (allvals + meanval);
    
    % DEPTHS
    
    %mean depth of patch center
    %patch center is 7pix x 7pix
    indsC = round(patchSize/2);
    patchCenter = patchDepth{p}(indsC - 3:indsC + 3,indsC - 3:indsC + 3);
    meanZ = nanmean(patchCenter(:));
    
    %convert Zs to relative depth from center distance
    allZsOrig = patchDepth{p}(~isnan(patchLum{p}) & ~isnan(patchDepth{p}));
    allZs = allZsOrig - meanZ;
    
    %predicted disparities for fixation distance, arcmin
    allDs = (6.4/100).*((1/meanZ) - (1./(allZsOrig))).*(180/pi).*60;
    
    %put patch data into mata mats
    allvalsA(ind1:ind1+numel(allvals)-1) = allvalsnorm;
    allvalsRawA(ind1:ind1+numel(allvals)-1) = allvals;
    allZsA(ind1:ind1+numel(allvals)-1) = allZsOrig;
    allZsMeanA(ind1:ind1+numel(allvals)-1) = meanZ;
    allDsA(ind1:ind1+numel(allvals)-1) = allDs;
    
    ind1 = ind1+numel(allvals);
    cnt = cnt + 1;
    
end

%remove extra values
allvalsA    = allvalsA(~isnan(allvalsA));
allZsA      = allZsA(~isnan(allvalsA));
allZsMeanA  = allZsMeanA(~isnan(allvalsA));
allZsDiffA  = allZsA - allZsMeanA;
allDsA      = allDsA(~isnan(allvalsA));

allZsMean   = unique(allZsMeanA); %all fixation distances


%data groups
%relative depths br/dk
ZScenebr = allZsDiffA(allvalsA >= thresh);
ZScenedk = allZsDiffA(allvalsA <= -thresh);
%disparitity br/dk
dispScenebr = allDsA(allvalsA >= thresh);
dispScenedk = allDsA(allvalsA <= -thresh);

% save data
%save('SPL_pixels.mat','allvalsA','allZsA','allZsMeanA','allZsDiffA','allDsA','ZScenebr','ZScenedk','dispScenebr','dispScenedk')


%MAKE FIGURE 2
ff = figure; hold on;

%relative depth br/dk
subplot(2,5,[1 2 6 7]);
[f1,xi1,uZbr] = ksdensity(ZScenebr,linspace(quantile(allZsDiffA,0.05),quantile(allZsDiffA,0.95),101));
[f2,xi2,uZdk] = ksdensity(ZScenedk,linspace(quantile(allZsDiffA,0.05),quantile(allZsDiffA,0.95),101));

g(1) = semilogy(xi1,f1,'r-'); hold on;
g(2) = semilogy(xi2,f2,'b-');
axis([-10 10 0.008 0.7]);

legend(g,'increments','decrements');
xlabel('Relative Depth (meters)');
ylabel('Probability');

%fixation distances
subplot(2,5,3);
[f1,xi1,uZmean] = ksdensity(allZsMean,linspace(min(allZsMean),max(allZsMean),101));

k(1) = semilogy(xi1,f1,'k-'); hold on;
axis([0 105 0.0001 0.05]);
xlabel('Patch Distance (meters)');

%disparities br/dk
subplot(2,5,8);
[f1,xi1,uDbr] = ksdensity(dispScenebr,linspace(-60,60,101));
[f2,xi2,uDdk] = ksdensity(dispScenedk,linspace(-60,60,101));

semilogy(xi1,f1,'r-'); hold on;
semilogy(xi2,f2,'b-');
axis([-20 20 0.0001 5]);
set(gca,'XTick',[-60 0 60]);
xlabel('Predicted Binocular Disparity (arcmin)');


%load samonds data disparities tunings from macaque V1
load('../Data/cells_LI_versus_disparity.mat')

dispLIbr = DisparityFit(LI >= thresh);
dispLIdk = DisparityFit(LI <= -thresh);

%plot samonds data
subplot(2,5,[4 5 9 10]); hold on;

[f1,xi1] = hist(dispLIbr.*60,linspace(-60,60,11));
[f2,xi2] = hist(dispLIdk.*60,linspace(-60,60,11));

plot(xi1,f1./numel(dispLIbr),'r-'); hold on;
plot(xi2,f2./numel(dispLIdk),'b-');

xlabel('Binocular Disparity (arcmin)');
ylabel('Cell density');


%SUMMARY STATS

display(['all pixels in dataset: ' num2str(numel(allvalsA))]);

display(['percent disparities less than 20 arcmin: ' num2str(sum(abs(allDsA <= 20))./numel(allDsA),3)]);

display(['num inc pref cells: ' num2str(numel(dispLIbr))]);
display(['num dec pref cells: ' num2str(numel(dispLIdk))]);

display(['num incs: ' num2str(numel(dispScenebr))]);
display(['num decs: ' num2str(numel(dispScenedk))]);

% num incs
display(['percent scene incs: ' num2str(numel(dispScenebr)/numel(allDsA),3)]);
%num decs
display(['percent scene decs: ' num2str(numel(dispScenedk)/numel(allDsA),3)]);

% percent brighter near preferred
display(['percent incs near scenes: ' num2str(sum(dispScenebr < 0)/numel(dispScenebr),3)]);
% percent darker near perferred
display(['percent decs near scenes: ' num2str(sum(dispScenedk < 0)/numel(dispScenedk),3)]);

% percent brighter near preferred CELLS
display(['percent incs near cells: ' num2str(sum(dispLIbr < 0)/numel(dispLIbr),3)]);
% percent darker near perferred CELLS
display(['percent decs near cells: ' num2str(sum(dispLIdk < 0)/numel(dispLIdk),3)]);


% STATISTICAL TESTS

%test if the median dark disparity is greater than the median bright using
%rank-sum test
display('Rank Sum Scenes');
[ps,hs,statss] = ranksum(dispScenedk,dispScenebr,'alpha',0.01,'tail','right')

display(['median incs: ' num2str(median(dispScenebr))]);
display(['num incs: ' num2str(numel(dispScenebr))]);
display(['median decs: ' num2str(median(dispScenedk))]);
display(['num decs: ' num2str(numel(dispScenedk))]);

display('Rank Sum Cells');
[pc,hc,statsc] = ranksum(dispLIdk,dispLIbr,'alpha',0.01,'tail','right')

display(['median incs: ' num2str(median(dispLIbr))]);
display(['num incs: ' num2str(numel(dispLIbr))]);
display(['median decs: ' num2str(median(dispLIdk))]);
display(['num decs: ' num2str(numel(dispLIdk))]);

%calculate U's (see doc ranksum)
cellU = statsc.ranksum - ((numel(dispLIdk)*(numel(dispLIdk) + 1))/2);
sceneU = statss.ranksum - ((numel(dispScenedk)*(numel(dispScenedk) + 1))/2);

%probability that bright preceeds dark
cellR = ((cellU)/(numel(dispLIdk)*numel(dispLIbr)));
sceneR = ((sceneU)/(numel(dispScenedk)*numel(dispScenebr)));

display(['probability that brighter scene point is nearer :' num2str(sceneR,2)]);
display(['probability that brighter cell is tuned nearer :' num2str(cellR,2)]);

keyboard

if(showPatches)
    
    %%% MAKE EXAMPLE PATCHES IMAGE
    %make big image
    imageIndices = round(linspace(1,13393,324));
    fewerPatches = patchLumMatch(:,:,imageIndices);
    fewerPatchesZ = patchDepthMatch(:,:,imageIndices);
    imagePatches = zeros(900,900);
    depthPatches = zeros(900,900);
    
    %determine circle cropping region
    [xx,yy]=ndgrid(1:50, 1:50);
    CroppingMask= ( (xx-ceil(50/2)).^2+(yy-ceil(50/2)).^2<=floor(50/2)^2 );
    
    inx = 1;
    iny = 1;
    cnt = 1;
    for x = 1:18
        for y = 1:18
            tmpIm = fewerPatches(:,:,cnt);
            tmpIm = (tmpIm - min(tmpIm(:)))./range(tmpIm(:));
            tmpIm = imadjust(tmpIm,[0.05; 0.95],[0; 1]);
            tmpIm(~CroppingMask) = 1;
            
            tmpZ = fewerPatchesZ(:,:,cnt);
            tmpZ = (tmpZ - min(tmpZ(:)))./range(tmpZ(:));
            tmpZ(~CroppingMask) = 1;
            
            imagePatches(inx:inx+50-1,iny:iny+50-1) = tmpIm;
            depthPatches(inx:inx+50-1,iny:iny+50-1) = tmpZ;
            
            cnt = cnt + 1;
            iny = iny + 50;
            if iny > 900
                iny = 1;
            end
        end
        inx = inx + 50;
    end
    
    figure; hold on;
    imshow(imagePatches);
    imwrite(imagePatches,'exampleImagePatches.png');
    figure; hold on;
    imshow(depthPatches);
    imwrite(depthPatches,'exampleDepthPatches.png');
    
end
