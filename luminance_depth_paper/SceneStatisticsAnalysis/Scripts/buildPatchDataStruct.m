function [] = buildPatchDataStruct()

% Ths function builds a data structure for analyzing natural scene statistics of luminance
% and depth from the Potetz & Lee dataset (acquired by contacting the
% researchers
%
% Dataset info:
%
% Potetz B, Lee TS (2003)
% Statistical correlations between two-dimensional images and three-dimensional structures in natural images.
% Journal of the Optical Society of America A 20:1292-1303.
%
% NOTE: if run as-is on the dataset, output file will be ~1gb
%
% Emily Cooper, Stanford University 2014

flag                = '_1.5degradius_15to30ppd'; %flag for output file
patch_radius_deg    = 1.5; %radius of patches to be selected
match_size_pix      = 50; %width of rescaled patches, useful for visualization of all patches at the same scale

%exclude low res, high res, artifact-heavy, and repeated scenes
low_res15 = [1 7 8 42 48 49 52 53 9 10 11 13 14 15 20 21 23 36 125 126 129 130 131 132 133 134 138 140 141 142]; % less than 15 pix per degree
hi_res30 = [94 96 101 135]; %more than 30 pix per degree
repeats = [10 11 14 19 21 30 40 41 45 59 91 104 111 112 113 119 121 122 130 136]; %mulple images of same scene
big_artifacts = [76 86 128 101 102]; %usually a solid black vertical line

%many scenes are of cities, we're going to just take the rural scenes
rural = [12 48 49 50 51 57 58 60 61 62 63 65 66 72 73 74 75 76 77 78 79 80 81 82 85 86 87 88 89 90 92 93 94 95 96 97 100 101 102 128 129 133 135 138 140 141 142];

scenes = setdiff(rural,[low_res15 hi_res30 repeats big_artifacts]);

%counters
scenecnt = 1; %count each scene
patchcnt = 1; %counter for all patches total

%for each scene
for scene = scenes
    
    display(num2str(scene));
    
    % Database is not included in Supplement, so this should just be the
    % path to where ever a database copy is kept
    load(['/Users/emily/Documents/NorciaLab/SceneStats/tsl/Scene_' sprintf('%03d',scene) '_1.mat'])
    
    %convert RGB to relative luminance
    imVorig = Data(:,:,2).*0.2989 + Data(:,:,3).*0.5870 + Data(:,:,4).*0.1140;
    
    %replace depth zeros with NaNs
    imZorig = Data(:,:,1);
    imZorig(imZorig == 0) = NaN;
    
    %make a grid of xy coordinates for each pixel
    [imYorig imXorig] = meshgrid(size(imVorig,1),size(imVorig,2));
    
    %pixels per degree
    Longitudes = Data(:,:,7);
    Latitudes = Data(:,:,6);
    widthLongitudeDeg = range(Longitudes(Longitudes ~= 0));
    widthLatitudeDeg = range(Latitudes(Latitudes ~= 0));
    pixPerDeg = mean([size(imVorig,1)/widthLatitudeDeg size(imVorig,2)/widthLongitudeDeg]);
    
    %size of patch in pixels - make sure it's odd so that there is a center pixel
    patch_size_pix = round(pixPerDeg*patch_radius_deg*2);
    if mod(patch_size_pix,2) == 0
        patch_size_pix = patch_size_pix + 1;
    end
 
    %find central image region divisible by patch size
    newdims = size(imVorig) - mod(size(imVorig),patch_size_pix) - 1;
    leftedge = round((size(imVorig,2)/2) - (newdims(2)/2));
    topedge = round((size(imVorig,1)/2) - (newdims(1)/2));
    num_blocks = (newdims+1)./patch_size_pix;
    
    %top left edges of each patch
    patch_left_edges = [ leftedge:patch_size_pix:patch_size_pix*(num_blocks(2)) ...
        leftedge+ceil(patch_size_pix/2):patch_size_pix:patch_size_pix*(num_blocks(2)-1) ];
    patch_top_edges = [ topedge:patch_size_pix:patch_size_pix*(num_blocks(1)) ...
        topedge+ceil(patch_size_pix/2):patch_size_pix:patch_size_pix*(num_blocks(1)-1) ];
    
    %for each block position, overlapping by 1/2 block, grab the image patch and info
    for x = patch_left_edges
        for y = patch_top_edges
            
            Vpatch = imVorig(y:y+patch_size_pix-1,x:x+patch_size_pix-1);
            Zpatch = imZorig(y:y+patch_size_pix-1,x:x+patch_size_pix-1);
            
            %only proceed if 95% of the depth values are intact
            if length(Zpatch(~isnan(Zpatch)))/length(Zpatch(:)) > 0.95
                
                %store luminance and depth
                patchLum{patchcnt} = Vpatch;
                patchDepth{patchcnt} = Zpatch;
                
                %resize to make all patches the same dims
                patchLumMatch(:,:,patchcnt) = imresize(patchLum{patchcnt},[match_size_pix match_size_pix]);
                patchDepthMatch(:,:,patchcnt) = imresize(inpaint_nans(patchDepth{patchcnt},2),[match_size_pix match_size_pix]);
                
                %other info
                %lum/depth correlation - exclude exact zero luminances
                %because these are caused by noise artifacts
                patchCorrelations(patchcnt) = corr(patchDepth{patchcnt}(~isnan(patchDepth{patchcnt}) & patchLum{patchcnt} > 0), ...
                    patchLum{patchcnt}(~isnan(patchDepth{patchcnt}) & patchLum{patchcnt} > 0));
                
                patchSizePix(patchcnt) = patch_size_pix;
                patchScene(patchcnt) = scene;
                patchCenter(patchcnt,:) = [y + floor(patch_size_pix/2) x + floor(patch_size_pix/2)];
                  
                patchcnt = patchcnt + 1;
                
            end
            
        end
    end
    
    scenecnt = scenecnt + 1;
    
end

%sort patches and patch info by correlation
[patchCorrelations,patchind] = sort(patchCorrelations);

patchLum = patchLum(patchind);
patchDepth = patchDepth(patchind);
patchLumMatch = patchLumMatch(:,:,patchind);
patchDepthMatch = patchDepthMatch(:,:,patchind);
patchSizePix = patchSizePix(patchind);
patchScene = patchScene(patchind);
patchCenter = patchCenter(patchind,:);

save(['patchInfoNature' flag '.mat'],'patchCorrelations','patchLum','patchDepth','patchLumMatch','patchDepthMatch',...
    'patchSizePix','patch_radius_deg','patchScene','patchCenter');





