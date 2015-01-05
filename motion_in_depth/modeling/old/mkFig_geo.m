% set up
clear all; close all;
setfigdefaults;

eyes(1).colr = [206 200 104]./255;
eyes(2).colr = [245 129 32]./255;

% NOTE world coordinate system is: zyx
% positive: forward up right


% eyes
[x,y,z]     = sphere(12);   % coordinates for eye shape
ipdh        = 2.5;            % half eye separation in cm
eyes(1).wc  = [0 0 -ipdh];  % left eye center world coords
eyes(2).wc  = [0 0  ipdh];  % right eye center world coords

% viewing geometry
fp          = [12 0 0];    % fixation point

cnt = 1;
for vert = -5:.1:5;
    pt(cnt,:)     = [12 vert 0];      % disparity point
    cnt = cnt + 1;
end

for horz = -5:.1:5;
    pt(cnt,:)     = [sqrt(12^2 - horz^2) 0 horz];      % disparity point
    cnt = cnt + 1;
end

for p = 1:size(pt,1)
    for n = 1:length(eyes)
        
        eyes(n).fvec = unit_vec(fp-eyes(n).wc);                     % normalized direction vector from eye to fp
        eyes(n).pvec(p,:) = unit_vec(pt(p,:)-eyes(n).wc);                     % normalized direction vector from eye to pt
        
        eyes(n).ang = acosd(dot([1 0 0],eyes(n).fvec));             % rotation angle from Prime Pos
        eyes(n).ax  = unit_vec(cross([1 0 0],eyes(n).fvec));        % rotation axis from Prime Pos
        
        eyes(n).fovea = ...
            intersectLineSphere([fp eyes(n).fvec],[eyes(n).wc 1]);  % intersection of visual axis and eye
        eyes(n).point(p,:,:) = ...
            intersectLineSphere([pt(p,:) eyes(n).pvec(p,:)],[eyes(n).wc 1]);  % projection of point in eye
        
    end
end

% define planes containing eyes and world points (fixation and disparity points)

padding = 1.5;        % padding for visuals

[fX,fY]   = meshgrid([-max([abs(fp(3)) ipdh])-padding max([abs(fp(3)) ipdh])+padding], ...
    [-padding fp(1)+padding]);
fZ = zeros(size(fX));
fA = atand(fp(2)/fp(1));

% %pt plane
% [pX,pY] = meshgrid([-max([ abs(pt(3)) ipdh])-padding max([ abs(pt(3)) ipdh])+padding], ...
%     [-padding pt(1)+padding]);
% pZ = zeros(size(pX));
% pA = atand(pt(2)/pt(1));


fig(1,:) = [7 5];
fig(2,:) = [3 3];
fig(3,:) = [3 5];

for v = 1:3
    
    figure; hold on;
    setupfig(fig(v,1),fig(v,2),v);
    
    f   = plot3(fp(1),fp(2),fp(3),'ko','MarkerFaceColor','k');                  % fixation point
    
    for p = 1:size(pt,1)
        
        dp(p)  = plot3(pt(p,1),pt(p,2),pt(p,3),'ro','MarkerFaceColor','r');  % disparity point
        
    end
    %lp = line([pt(1) pt(1)],[pt(2) 0],[pt(3) pt(3)],'color','k');
    
    for n = 1:length(eyes)
        
        s(n) = surf(x+eyes(n).wc(1),y+eyes(n).wc(2),z+eyes(n).wc(3));   % draw eyes
        set(s(n),'EdgeColor','k','linewidth',0.1,'FaceColor',eyes(n).colr,'FaceAlpha',1);             % set color
        rotate(s(n),eyes(n).ax,eyes(n).ang,eyes(n).wc)                  % rotate to look at fixation pt
        
        s2(n) = surf((0.2*x)+eyes(n).wc(1) + 1 - 0.1,0.4*y+eyes(n).wc(2),0.4*z+eyes(n).wc(3));   % draw eyes
        set(s2(n),'EdgeColor','none','linewidth',0.1,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.5);
        rotate(s2(n),eyes(n).ax,eyes(n).ang,eyes(n).wc)
        
        %cdata = x;
        %set(s(n),'CData',100*cdata,'facecolor','texturemap')
        %colormap gray
        
        fpl(n) = line(  [eyes(n).fovea(1,1) fp(1)], ...                 % plot fixation line ...
            [eyes(n).fovea(1,2) fp(2)], ...
            [eyes(n).fovea(1,3) fp(3)],'color','k');
        
        fh(n) = plot3(eyes(n).fovea(1,1), ...                           % ... and fovea
            eyes(n).fovea(1,2), ...
            eyes(n).fovea(1,3),'ko','MarkerFaceColor','k');
        
        %fh2(n) = plot3(eyes(n).fovea(2,1), ...                           % ... and fovea
        %    eyes(n).fovea(2,2), ...
        %    eyes(n).fovea(2,3),'ko','MarkerFaceColor','k');
        
        for p = 1:size(pt,1)
            
            ptpl(n,p) = patchline(  [eyes(n).point(p,1,1) pt(p,1)], ...                % plot world point line ...
                [eyes(n).point(p,1,2) pt(p,2)], ...
                [eyes(n).point(p,1,3) pt(p,3)],'edgecolor','r','linestyle','-','edgealpha',0.1);
            
            
            ph(n,p) = plot3(eyes(n).point(p,1,1), ...                           % ... and retinal intersection
                eyes(n).point(p,1,2), ...
                eyes(n).point(p,1,3),'.','MarkerFaceColor',eyes(n).colr,'markeredgecolor','k');
            
        end
        
    end
    
    % epipolar plane
    pl = surf(fY,fZ,fX);
    set(pl,'FaceColor',[0 0 0],'FaceAlpha',0.1);
    rotate(pl,[0 0 1],fA,[0 0 0])
    
    %     %target plane
    %     tl = surf(pY,pZ,pX);
    %     set(tl,'FaceColor',[1 0 1],'FaceAlpha',0.1);
    %     rotate(tl,[0 0 1],pA,[0 0 0])
    
    
    box off; axis off;
    axis equal; axis tight;
    %xlim([-ipdh-padding ipd+padding]);
    %ylim([-maxx maxx]);
    %zlim([-3 maxz+5]);
    
    
    if v == 1
        
        set(gca,'Projection','perspective')
        
        delete(fh)
        %delete(ph)
        
        %view([-187 -58])
        
        %view([174 -58]);
        view([-180 -66]);
        
        camdolly(0,0,.76);
        
        export_fig geo_p1.png -r300
        
    elseif v == 2
        
        for n = 1:length(eyes)
            set(s(n),'FaceColor',[1 1 1],'FaceAlpha',1,'linewidth',0.5);
        end
        set(gca,'Projection','orthographic')
        
        view([-90 0])
        
        for n = 1:length(eyes)
            
            set(s(n), 'z', get(s(n),'z') - eyes(n).wc(3) );
            set(fh(n), 'z', get(fh(n),'z') - eyes(n).wc(3) );
            
            
            rotate(s(n),eyes(n).ax,-eyes(n).ang,[0 0 0])
            rotate(fh(n),eyes(n).ax,-eyes(n).ang,[0 0 0])
            
            
            for p = 1:size(pt,1)
                
                set(ph(n,p), 'z', get(ph(n,p),'z') - eyes(n).wc(3) );
                rotate(ph(n,p),eyes(n).ax,-eyes(n).ang,[0 0 0])
                
            end
            
        end
        
        delete(f)
        delete(dp)
        delete(fpl)
        delete(ptpl)
        delete(pl)
        %delete(fh2);
        %delete(lp);
        delete(s2)
        %delete(tl)
        
        camroll(-90)
        axis tight
        
        export_fig geo_p2.png -r300
        
    elseif v == 3
        
        set(gca,'Projection','perspective')
        
        %delete(fh2);
        
        view([-92 0])
        camroll(-90)
        
        export_fig geo_p3.png -r300
        
    elseif v == 4
        
        view([-180 0])
        
        
    end
end




