whichScreen=0;
screenInfo.displayType = 'monitor';
[screenInfo.Xpix, screenInfo.Ypix]= Screen('WindowSize', whichScreen);
[screenInfo.Xmm,  screenInfo.Ymm ]= Screen('DisplaySize', whichScreen);

screenInfo.Xcm = screenInfo.Xmm/10;
screenInfo.Ycm = screenInfo.Ymm/10;

% Measurements that determine converesion from Helmholtz code's getScreenInfo.m
pix2cm = screenInfo.Xcm./screenInfo.Xpix;       % multiply pix by pix2cm to get cm
cm2pix = inv(pix2cm); % multiply cm by cm2pix to get pix