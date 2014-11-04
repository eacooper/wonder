function scr = screen_load_display_info(dat)

scr.display = dat.display;

if strcmp(dat.display,'OLEDhaplo')
    
    scr.viewDistCm        = 77;
    
    scr.width_cm     = 54.3;                 
    scr.height_cm    = 30.6;
    
    scr.loadDistortion    = 1;                            %load distortion file for haploscope
    scr.snellShiftPix     = 3;                            %shift red and blue values to correct for prisms (determined by eye)
    
    scr.prismD            = 15;                           % prism diopters
    scr.prismShiftCm      = (scr.prismD*scr.viewDistCm)/100;  % left/right image shift to center in prisms
    
    scr.screenElevationCm = 16.2;                         % height to bottom of screen on table
    scr.prismElevationCm  = 29.6;                         % height to pricm centers
    scr.stimCenterYCm     = scr.prismElevationCm - ...
        (scr.screenElevationCm + (scr.height_cm/2));   % height adjustment of stimulus to center in prisms
    
    scr.topbottom         = 0;                            % does this display take top/bottom stereo format
    
    scr.skipSync            = 0;
    scr.signRight = 1;
    
elseif strcmp(dat.display,'laptop')
    
    scr.viewDistCm        = 50;
    
    scr.width_cm     = 33.2;
    scr.height_cm    = 20.7;

    scr.loadDistortion    = 0;
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 5;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 0;
    
    scr.skipSync          = 1;
    scr.signRight = 1;
    
elseif strcmp(dat.display,'laptopRB')
    
    scr.viewDistCm        = 50;
    
    scr.width_cm     = 33.2;
    scr.height_cm    = 20.7;
    
    scr.loadDistortion    = 0; 
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 0;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 0;
    
    scr.skipSync            = 1;
    scr.signRight = 1;
    
elseif strcmp(dat.display,'planar')
    
    scr.viewDistCm        = 50;
    
    %fixed screen width to handle native resolution
    scr.width_cm     = 45.8399; % *True* width is 55.008
    scr.height_cm    = 34.38;

    scr.loadDistortion    = 0;
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 0;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 0;
    
    scr.skipSync            = 0;
    scr.signRight = -1;             % displays are mirrored so flip the right image

    
elseif strcmp(dat.display,'LG3D')
    
    scr.viewDistCm        = 80;
    
    scr.width_cm     = 50.92;
    scr.height_cm    = 28.64;

    scr.loadDistortion    = 0; 
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 0;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 1;
    
    scr.skipSync            = 1;
    scr.signRight = 1;

elseif strcmp(dat.display,'LG3DRB')
    
    scr.viewDistCm        = 80;
    
    scr.width_cm     = 50.92;
    scr.height_cm    = 28.64;

    scr.loadDistortion    = 0; 
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 0;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 0;
    
    scr.skipSync            = 1;
    scr.signRight = 1;
    
elseif strcmp(dat.display,'LG3DLR')
    
    scr.viewDistCm        = 80;
    
    scr.width_cm     = 50.92;
    scr.height_cm    = 28.64;

    scr.loadDistortion    = 0; 
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 10;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 0;
    
    scr.skipSync            = 1;
    scr.signRight = 1;
    
elseif strcmp(dat.display,'Bravia')
    
    scr.viewDistCm        = 300;
    
    scr.width_cm     = 143;
    scr.height_cm    = 80.5;
    
    scr.loadDistortion    = 0;
    scr.snellShiftPix     = 0;
    
    scr.prismShiftCm      = 0;
    scr.stimCenterYCm     = 0;
    
    scr.topbottom         = 1;
    
    scr.skipSync            = 0;
    scr.signRight = 1;
end
