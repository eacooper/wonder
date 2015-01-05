% set up
clear all; close all;
setfigdefaults;

eyes(1).colr = getcol(3);
eyes(2).colr = getcol(2);
eyes(3).colr = [0.5 0.5 0.5];

time(1).colr = getcol(1);
time(2).colr = getcol(5);

% NOTE world coordinate system is: zyx
% positive: forward up right


% eyes
[x,y,z]     = sphere(14);   % coordinates for eye shape
ipdh        = 3;            % half eye separation in cm
eyes(1).wc  = [0 0 -ipdh];  % left eye center world coords
eyes(2).wc  = [0 0  ipdh];  % right eye center world coords
eyes(3).wc  = [0 0 0];      % cyclopean eye center world coords

% viewing geometry
fp          = [12 0 0];    % fixation point

[xs,ys] = meshgrid(-4:2:4,-4:2:4);
xs = xs(:);
ys = ys(:);

zs = repmat(fp(1),size(xs));

po = [zs ys xs];

for t = 1:2
    
    pt(:,:,t) = po;
    pt(:,1,t) = po(:,1) - (t-1)*3;
    
    for p = 1:size(pt,1)
        
        for n = 1:length(eyes)
            
            eyes(n).fvec = unit_vec(fp-eyes(n).wc);                     % normalized direction vector from eye to fp
            eyes(n).pvec(p,:,t) = unit_vec(pt(p,:,t)-eyes(n).wc);                     % normalized direction vector from eye to pt
            
            eyes(n).ang = acosd(dot([1 0 0],eyes(n).fvec));             % rotation angle from Prime Pos
            eyes(n).ax  = unit_vec(cross([1 0 0],eyes(n).fvec));        % rotation axis from Prime Pos
            
            if eyes(n).ang == 0
                eyes(n).ax  = [1 0 0];                                  % if no rotation, just let axis be z axis
            end
            
            fovea = ...
                intersectLineSphere([fp eyes(n).fvec],[eyes(n).wc 1]);  % intersection of visual axis and eye
            eyes(n).fovea = fovea(1,:);  % intersection of visual axis and eye
            
            point = ...
                intersectLineSphere([pt(p,:,t) eyes(n).pvec(p,:,t)],[eyes(n).wc 1]);  % projection of point in eye
            
            eyes(n).point(p,:,t) = point(1,:);  % projection of point in eye
        end
    end
    
end

for n = 1:length(eyes)
    eyes(n).diff(:,:,:) = eyes(n).point(:,:,2) - eyes(n).point(:,:,1);
end

iovd = eyes(1).diff - eyes(2).diff;

eyes(3).iovd(:,:,1) = eyes(3).point(:,:,1);
eyes(3).iovd(:,:,2) = eyes(3).point(:,:,1) + iovd;

eyes(3).iovdh(:,:,1) = eyes(3).point(:,:,1);
eyes(3).iovdh(:,:,2) = eyes(3).point(:,:,1);
eyes(3).iovdh(:,3,2) = eyes(3).iovdh(:,3,2) + iovd(:,3);

eyes(3).iovdv(:,:,1) = eyes(3).point(:,:,1);
eyes(3).iovdv(:,:,2) = eyes(3).point(:,:,1);
eyes(3).iovdv(:,2,2) = eyes(3).iovdv(:,2,2) + iovd(:,2);

% define planes containing eyes and world points (fixation and disparity points)

padding = 1.5;        % padding for visuals

[fX,fY]   = meshgrid([-max([abs(fp(3)) ipdh])-padding max([abs(fp(3)) ipdh])+padding], ...
    [-padding fp(1)+padding]);
fZ = zeros(size(fX));
fA = atand(fp(2)/fp(1));

fig(1,:) = [7 5];
fig(2,:) = [3 3];
fig(3,:) = [3 5];
fig(4,:) = [3 3];

for v = 1:4
    
    figure; hold on;
    setupfig(fig(v,1),fig(v,2),v);
    
    f   = plot3(fp(1),fp(2),fp(3),'ko','MarkerFaceColor','k');                  % fixation point
    
    for t = 1:2
        for p = 1:size(pt,1)
            
            dp(p,t)  = plot3(pt(p,1,t),pt(p,2,t),pt(p,3,t),'color',time(t).colr,'marker','o','MarkerFaceColor',time(t).colr);  % disparity point
            
        end
        
    end
    
    
    for n = 1:length(eyes)
        
        s(n) = surf(x+eyes(n).wc(1),y+eyes(n).wc(2),z+eyes(n).wc(3));   % draw eyes
        set(s(n),'EdgeColor','k','linewidth',0.1,'FaceColor',eyes(n).colr,'FaceAlpha',1);             % set color
        rotate(s(n),eyes(n).ax,eyes(n).ang,eyes(n).wc)                  % rotate to look at fixation pt
        
        s2(n) = surf((0.2*x)+eyes(n).wc(1) + 1 - 0.1,0.4*y+eyes(n).wc(2),0.4*z+eyes(n).wc(3));   % draw eyes
        set(s2(n),'EdgeColor','none','linewidth',0.1,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.5);
        rotate(s2(n),eyes(n).ax,eyes(n).ang,eyes(n).wc)
        
        fpl(n) = line(  [eyes(n).fovea(1) fp(1)], ...                 % plot fixation line ...
            [eyes(n).fovea(2) fp(2)], ...
            [eyes(n).fovea(3) fp(3)],'color','k');
        
        fh(n) = plot3(eyes(n).fovea(1), ...                           % ... and fovea
            eyes(n).fovea(2), ...
            eyes(n).fovea(3),'ko','MarkerFaceColor','k');
        
        for p = 1:size(pt,1)
            
            for t = 1:2
                ptpl(n,p,t) = patchline(  [eyes(n).point(p,1,t) pt(p,1,t)], ...                % plot world point line ...
                    [eyes(n).point(p,2,t) pt(p,2,t)], ...
                    [eyes(n).point(p,3,t) pt(p,3,t)],'edgecolor',time(t).colr,'linestyle','-','edgealpha',0.1);
                
            end
            
            %                 ph(n,p,t) = plot3(eyes(n).point(p,1,1,t), ...                           % ... and retinal intersection
            %                     eyes(n).point(p,1,2,t), ...
            %                     eyes(n).point(p,1,3,t),'.','MarkerFaceColor',eyes(n).colr,'markeredgecolor',eyes(n).colr);
            %
            if n < 3 && v < 4
            ph(n,p) = plot3(squeeze(eyes(n).point(p,1,:)), ...                           % ... and retinal intersection
                squeeze(eyes(n).point(p,2,:)), ...
                squeeze(eyes(n).point(p,3,:)),'-','color',eyes(n).colr,'MarkerFaceColor',eyes(n).colr,'markeredgecolor',eyes(n).colr);
            
            ph2(n,p) = plot3(squeeze(eyes(n).point(p,1,2)), ...                           % ... and retinal intersection
                squeeze(eyes(n).point(p,2,2)), ...
                squeeze(eyes(n).point(p,3,2)),'o','color',eyes(n).colr,'MarkerFaceColor',eyes(n).colr,'markeredgecolor',eyes(n).colr);
            
            elseif n == 3 && v == 4
                
                ph(n,p) = plot3(squeeze(eyes(n).iovdv(p,1,:)), ...                           % ... and retinal intersection
                    squeeze(eyes(n).iovdv(p,2,:)), ...
                    squeeze(eyes(n).iovdv(p,3,:)),'-','color','r','MarkerFaceColor','k','markeredgecolor','k');
                
                ph2(n,p) = plot3(squeeze(eyes(n).iovdh(p,1,:)), ...                           % ... and retinal intersection
                    squeeze(eyes(n).iovdh(p,2,:)), ...
                    squeeze(eyes(n).iovdh(p,3,:)),'-','color','b','MarkerFaceColor','k','markeredgecolor','k');
               
                ph(n,p) = plot3(squeeze(eyes(n).iovd(p,1,:)), ...                           % ... and retinal intersection
                    squeeze(eyes(n).iovd(p,2,:)), ...
                    squeeze(eyes(n).iovd(p,3,:)),'-','color','m','MarkerFaceColor','k','markeredgecolor','k');
            end
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
        
    elseif v == 2 || v == 4
        
        for n = 1:length(eyes)
            set(s(n),'FaceColor',[1 1 1],'FaceAlpha',1,'linewidth',0.5);
        end
        set(gca,'Projection','orthographic')
        
        view([-90 0])
        
        for n = 1:size(ph,1)
            
            set(s(n), 'z', get(s(n),'z') - eyes(n).wc(3) );
            set(fh(n), 'z', get(fh(n),'z') - eyes(n).wc(3) );
            
            
            rotate(s(n),eyes(n).ax,-eyes(n).ang,[0 0 0])
            rotate(fh(n),eyes(n).ax,-eyes(n).ang,[0 0 0])
            
            %for t = 1:2
            for p = 1:size(pt,1)
                
                set(ph(n,p), 'z', get(ph(n,p),'z') - eyes(n).wc(3) );
                rotate(ph(n,p),eyes(n).ax,-eyes(n).ang,[0 0 0])
                
                set(ph2(n,p), 'z', get(ph2(n,p),'z') - eyes(n).wc(3) );
                rotate(ph2(n,p),eyes(n).ax,-eyes(n).ang,[0 0 0])
                
            end
            %end
            
        end
        
        delete(f)
        delete(dp)
        delete(fpl)
        
        for t = 1:2
            delete(ptpl(:,:,t))
        end
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




