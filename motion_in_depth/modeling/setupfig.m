function [] = setupfig(wid,ht,fl)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [1 1 wid ht]);

if fl == 1 || fl == 3
    set(0,'DefaultlineMarkerSize',3)
elseif fl == 2
    set(0,'DefaultlineMarkerSize',8)
end


