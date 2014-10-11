% set up
close all;
set(0,'defaultlinelinewidth',1)
LEcolr = [0 0 1];
REcolr = [1 0 0];

% eyes
[x,y,z] = sphere(13);   % coordinates for eye shape
ipd     = 3;            % eye separation in cm
RE      = [0 0 ipd/2];  % right eye center world coords
LE      = [0 0 -ipd/2]; % left eye center world coords


%eye locations
RE = [0 0 ipdh];
LE = [0 0 -ipdh];

%fixation and projected point
f1 = [6 4 -3];
%f2 = [20 -5 -8];

pt = [12 0 0];

%f3 = pt;

maxz = max([f1(1) f2(1) pt(1)]);
maxx = max([f1(3) f2(3) pt(3)]);

fpt = f1;


%axis and angle rotation for each eye
angleLE = acosd(dot([1 0 0],(f-LE)/norm(f-LE)));
axisLE = cross([1 0 0],(f-LE)/norm(f-LE))./norm(cross([1 0 0],(f-LE)/norm(f-LE)));

angleRE = acosd(dot([1 0 0],(f-RE)/norm(f-RE)));
axisRE = cross([1 0 0],(f-RE)/norm(f-RE))./norm(cross([1 0 0],(f-RE)/norm(f-RE)));

%vergence angle
%dv = atand(RE(3)/f(1));

%vertical angle
dv = atand(f(2)/f(1));

%target vertical angle
dvp = atand(pt(2)/pt(1));

%intersect of visual axes with eyes
fLE = intersectLineSphere([f f-LE],[LE 1]);
fRE = intersectLineSphere([f f-RE],[RE 1]);

pLE = intersectLineSphere([pt pt-LE],[LE 1]);
pRE = intersectLineSphere([pt pt-RE],[RE 1]);

%epipolar plane
%[X,Y] = meshgrid(-ipdh-1:0.1:ipdh+1,-1:0.1:f(1)+1);
[X,Y] = meshgrid([-max([abs(f(3)) ipdh])-2 max([abs(f(3)) ipdh])+2],[-2 f(1)+2]);
Z = zeros(size(X));

%pt plane
[Xp,Yp] = meshgrid([-max([ abs(pt(3)) ipdh])-2 max([ abs(pt(3)) ipdh])+2],[-2 pt(1)+2]);
Zp = zeros(size(Xp));


for v = 3:4
    
    figure; hold on
    
    %draw eyes
    sLE = surf(x+LE(1),y+LE(2),z+LE(3));
    sRE = surf(x+RE(1),y+RE(2),z+RE(3));
    
    set(sLE,'FaceColor',[0 0 1],'FaceAlpha',0.1);
    set(sRE,'FaceColor',[1 0 0],'FaceAlpha',0.1);
    
    %rotate to look at fixation pt
    rotate(sLE,axisLE,angleLE,LE)
    rotate(sRE,axisRE,angleRE,RE)
    
    %plot fixation lines
    fp = plot3(f(1),f(2),f(3),'ko','MarkerSize',10,'MarkerFaceColor','k');
    
    fpl1 = line([fLE(1,1) f(1)],[fLE(1,2) f(2)],[fLE(1,3) f(3)],'color','k');
    fpl2 = line([fRE(1,1) f(1)],[fRE(1,2) f(2)],[fRE(1,3) f(3)],'color','k');
    
    %plot projection lines
    dp = plot3(pt(1),pt(2),pt(3),'mo','MarkerSize',10,'MarkerFaceColor','m');
    
    ptpl1 = line([pLE(1,1) pt(1)],[pLE(1,2) pt(2)],[pLE(1,3) pt(3)],'color','b');
    ptpl2 = line([pRE(1,1) pt(1)],[pRE(1,2) pt(2)],[pRE(1,3) pt(3)],'color','r');
    
    %intersection of visual axes and eyes
    fh1 = plot3(fLE(1,1),fLE(1,2),fLE(1,3),'ko','MarkerSize',10,'MarkerFaceColor','k');
    fh2 = plot3(fRE(1,1),fRE(1,2),fRE(1,3),'ko','MarkerSize',10,'MarkerFaceColor','k');
    
    %fh3 = plot3(fLE(2,1),fLE(2,2),fLE(2,3),'ko','MarkerSize',20,'MarkerFaceColor','auto','LineWidth',2);
    %fh4 = plot3(fRE(2,1),fRE(2,2),fRE(2,3),'ko','MarkerSize',20,'MarkerFaceColor','auto','LineWidth',2);
    
    ph1 = plot3(pLE(1,1),pLE(1,2),pLE(1,3),'bo','MarkerSize',10,'MarkerFaceColor','b');
    ph2 = plot3(pRE(1,1),pRE(1,2),pRE(1,3),'ro','MarkerSize',10,'MarkerFaceColor','r');
    
    % epipolar plane
    pl = surf(Y,Z,X);
    set(pl)
    %cmp = flipud(gray);
    %colormap(cmp)
    %set(pl,'EdgeColor','none','FaceAlpha',0.1);
    set(pl,'FaceColor',[0 0 0],'FaceAlpha',0.1);
    rotate(pl,[0 0 1],dv,[0 0 0])
    
    %target plane
    tl = surf(Yp,Zp,Xp);
    set(tl,'FaceColor',[1 0 1],'FaceAlpha',0.1);
    rotate(tl,[0 0 1],dvp,[0 0 0])
    
    zlim([-3 maxz]);
    
    axis tight
    axis equal
    
    %grid on
    %box on
    box off
    axis off
    
    xlabel('1');
    ylabel('2');
    zlabel('3');
    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    set(gca,'ztick',[])
    set(gca,'zticklabel',[])
    
    
    
    set(gca,'Projection','perspective')
    
    
    
    %view([-80 -60])
    %view([-120 0])
    
    
    if v == 1
        view([-180 0])
    elseif v == 2
        
        set(gca,'Projection','orthographic')
        view([0 0])
    elseif v == 3
        view([-187 -58])
        camdolly(0,0,0.75);
        
        %xlim([-2 20]);
    elseif v == 4
        
        view([-90 0])
        
        set(sLE, 'z', get(sLE,'z') + ipdh );
        set(sRE, 'z', get(sRE,'z') - ipdh );
        
        set(fh1, 'z', get(fh1,'z') + ipdh );
        set(fh2, 'z', get(fh2,'z') - ipdh );
        
        set(ph1, 'z', get(ph1,'z') + ipdh );
        set(ph2, 'z', get(ph2,'z') - ipdh );
        
        rotate(sLE,axisLE,-angleLE,[0 0 0])
        rotate(sRE,axisRE,-angleRE,[0 0 0])
        
        rotate(fh1,axisLE,-angleLE,[0 0 0])
        rotate(fh2,axisRE,-angleRE,[0 0 0])
        
        rotate(ph1,axisLE,-angleLE,[0 0 0])
        rotate(ph2,axisRE,-angleRE,[0 0 0])
        
        delete(fp)
        delete(dp)
        delete(fpl1)
        delete(fpl2)
        delete(ptpl1)
        delete(ptpl2)
        delete(pl)
        delete(tl)
        
        camroll(-90)
        
        axis tight
        
        set(gca,'Projection','orthographic')
        
    end
end




