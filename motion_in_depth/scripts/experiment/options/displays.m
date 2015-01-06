function dspl = displays
%
% load display options and info


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(1).name              = 'OLEDhaplo';

dspl(1).viewDistCm        = 77;                              % distance subject views from

dspl(1).width_cm          = 54.3;                            % display width
dspl(1).height_cm         = 30.6;                            % display height

dspl(1).loadDistortion    = 1;                               % load distortion file for haploscope
dspl(1).snellShiftPix     = 3;                               % shift red and blue values to correct for prisms (determined by eye)

dspl(1).prismD            = 15;                              % prism diopters
dspl(1).prismShiftCm      = (dspl(1).prismD*...
    dspl(1).viewDistCm)/100;                                 % left/right image shift to center in prisms

dspl(1).screenElevationCm = 16.2;                            % height to bottom of dspleen on table
dspl(1).prismElevationCm  = 29.6;                            % height to pricm centers
dspl(1).stimCenterYCm     = dspl(1).prismElevationCm - ...
    (dspl(1).screenElevationCm + (dspl(1).height_cm/2));      % height adjustment of stimulus to center in prisms

dspl(1).topbottom         = 0;                               % does this display take top/bottom stereo format

dspl(1).skipSync          = 0;                               % 0 if this is a testing display that PTB doesn't like timing of
dspl(1).signRight         = 1;                               % 1 if displays are oriented the same, -1 if displays are mirrored


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(2).name              = 'laptop';

dspl(2).viewDistCm        = 50;

dspl(2).width_cm          = 33.2;
dspl(2).height_cm         = 20.7;

dspl(2).loadDistortion    = 0;
dspl(2).snellShiftPix     = 0;

dspl(2).prismShiftCm      = 5;
dspl(2).stimCenterYCm     = 0;

dspl(2).topbottom         = 0;

dspl(2).skipSync          = 1;
dspl(2).signRight         = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(3).name              = 'laptopRB';

dspl(3).viewDistCm        = 50;

dspl(3).width_cm          = 33.2;
dspl(3).height_cm         = 20.7;

dspl(3).loadDistortion    = 0;
dspl(3).snellShiftPix     = 0;

dspl(3).prismShiftCm      = 0;
dspl(3).stimCenterYCm     = 0;

dspl(3).topbottom         = 0;

dspl(3).skipSync          = 1;
dspl(3).signRight         = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(4).name              = 'planar';

dspl(4).viewDistCm        = 50;

%fixed dspleen width to handle native resolution
dspl(4).width_cm     = 45.8399; % *True* width is 55.008
dspl(4).height_cm    = 34.38;

dspl(4).loadDistortion    = 0;
dspl(4).snellShiftPix     = 0;

dspl(4).prismShiftCm      = 0;
dspl(4).stimCenterYCm     = 0;

dspl(4).topbottom         = 0;

dspl(4).skipSync            = 1;
dspl(4).signRight = -1;             % displays are mirrored so flip the right image


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(5).name              = 'LG3D';

dspl(5).viewDistCm        = 80;

dspl(5).width_cm     = 50.88;
dspl(5).height_cm    = 28.64;

dspl(5).loadDistortion    = 0;
dspl(5).snellShiftPix     = 0;

dspl(5).prismShiftCm      = 0;
dspl(5).stimCenterYCm     = 0;

dspl(5).topbottom         = 1;

dspl(5).skipSync            = 1;
dspl(5).signRight = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(6).name  =            'LG3DRB';

dspl(6).viewDistCm        = 80;

dspl(6).width_cm     = 50.92;
dspl(6).height_cm    = 28.64;

dspl(6).loadDistortion    = 0;
dspl(6).snellShiftPix     = 0;

dspl(6).prismShiftCm      = 0;
dspl(6).stimCenterYCm     = 0;

dspl(6).topbottom         = 0;

dspl(6).skipSync            = 1;
dspl(6).signRight = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(7).name  =            'LG3DLR';

dspl(7).viewDistCm        = 80;

dspl(7).width_cm     = 50.92;
dspl(7).height_cm    = 28.64;

dspl(7).loadDistortion    = 0;
dspl(7).snellShiftPix     = 0;

dspl(7).prismShiftCm      = 10;
dspl(7).stimCenterYCm     = 0;

dspl(7).topbottom         = 0;

dspl(7).skipSync            = 1;
dspl(7).signRight = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(8).name  =           'Bravia';

dspl(8).viewDistCm        = 300;

dspl(8).width_cm     = 143;
dspl(8).height_cm    = 80.5;

dspl(8).loadDistortion    = 0;
dspl(8).snellShiftPix     = 0;

dspl(8).prismShiftCm      = 0;
dspl(8).stimCenterYCm     = 0;

dspl(8).topbottom         = 1;

dspl(8).skipSync            = 0;
dspl(8).signRight = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dspl(9).name  =            'CinemaDisplayRB';

dspl(9).viewDistCm        = 80;

dspl(9).width_cm     = 50.92;
dspl(9).height_cm    = 28.64;

dspl(9).loadDistortion    = 0;
dspl(9).snellShiftPix     = 0;

dspl(9).prismShiftCm      = 0;
dspl(9).stimCenterYCm     = 0;

dspl(9).topbottom         = 0;

dspl(9).skipSync        = 1;
dspl(9).signRight       = 1;
