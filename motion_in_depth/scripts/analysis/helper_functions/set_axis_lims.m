function [xlimits ylimits] = set_axis_lims(predLE,predRE,plt,time_points)
%
%

xlimits = [0 time_points(end)];

% vergence/version ranges
verg = predLE-predRE;
vers = mean([predLE ; predRE]);

switch plt
    
    case 'monocular'
        
        ylimits{1} = [min(predLE)-2 max(predLE)+2];
        ylimits{2} = [min(predRE)-2 max(predRE)+2];
        
    case 'binocular'
        
        
        ylimits{1} = [min(verg)-2 max(verg)+2];
        ylimits{2} = [min(vers)-2 max(vers)+2];
        
    case 'vergence'
        
        ylimits = [min(verg)-2 max(verg)+2];
        
    case 'version'
        
        ylimits = [min(vers)-2 max(vers)+2];
        
end
