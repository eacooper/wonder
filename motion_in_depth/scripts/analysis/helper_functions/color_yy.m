function color_yy(ax,h1,h2,flag1)
%
% adjust plotting colors
% flag1 = mean data colors, just darker

% set line colors
if(flag1)
    set(h1,'color',ColorIt(2))
    set(h2,'color',ColorIt(1))
else
    set(h1,'color',ColorIt(2).^(0.1))
    set(h2,'color',ColorIt(1).^(0.1))
end

% color of axes should match color of lines
set(ax(1),'Ycolor',ColorIt(2))
set(ax(2),'Ycolor',ColorIt(1))