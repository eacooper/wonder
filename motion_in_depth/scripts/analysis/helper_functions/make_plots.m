function make_plots(datatype,plt,res,inds,predLE,predRE,LE,RE,Verg,Vers,time_points,time_points_pred)
%
% draw the plots for this trial, depending on requested plot type


[xlimits ylimits] = set_axis_lims(res.trials.(predLE){inds(1)},res.trials.(predRE){inds(1)},plt,time_points);


if strcmp(datatype,'position')
    
    % for each trial
    for t = 1:length(inds)
        
        % plot requested result type
        switch plt
            
            case 'monocular'
                
                [ax,h1,h2] = plotyy(time_points,res.trials.(LE){inds(t)},...
                    time_points,res.trials.(RE){inds(t)});
                color_yy(ax,h1,h2,0);
                
                set(ax(1),'YLim',ylimits{1},'Ytick',[])
                set(ax(2),'YLim',ylimits{2},'Ytick',[])
                set(ax,'Xlim',xlimits)
                
            case 'binocular'
                
                [ax,h1,h2] = plotyy(time_points,res.trials.(Verg){inds(t)},...
                    time_points,res.trials.(Vers){inds(t)});
                color_yy(ax,h1,h2,0);
                
                set(ax(1),'YLim',ylimits{1},'Ytick',[])
                set(ax(2),'YLim',ylimits{2},'Ytick',[])
                set(ax,'Xlim',xlimits)
                
            case 'vergence'
                
                plot(time_points,res.trials.(Verg){inds(t)},'color',ColorIt(3).^0.1);
                xlim(xlimits);
                ylim(ylimits);
                
            case 'version'
                
                plot(time_points,res.trials.(Vers){inds(t)},'color',ColorIt(4).^0.1);
                xlim(xlimits);
                ylim(ylimits);
                
        end
        
        
        
    end
    
end


% now plot average of all trials
switch plt
    
    case 'monocular'
        
        [ax,h1,h2] = plotyy(time_points,mean(cell2mat(res.trials.(LE)(inds)),2),...
            time_points,mean(cell2mat(res.trials.(RE)(inds)),2));
        color_yy(ax,h1,h2,1);
        
        set(ax(1),'YLim',ylimits{1},'Ytick',[])
        set(ax(2),'YLim',ylimits{2},'Ytick',[])
        set(ax,'Xlim',xlimits)
        
    case 'binocular'
        
        [ax,h1,h2] = plotyy(time_points,mean(cell2mat(res.trials.(Verg)(inds)),2),...
            time_points,mean(cell2mat(res.trials.(Vers)(inds)),2));
        color_yy(ax,h1,h2,1);
        
        set(ax(1),'YLim',ylimits{1},'Ytick',[])
        set(ax(2),'YLim',ylimits{2},'Ytick',[])
        set(ax,'Xlim',xlimits)
        
    case 'vergence'
        
        plot(time_points,mean(cell2mat(res.trials.(Verg)(inds)),2),'color',ColorIt(3));
        xlim(xlimits);
        ylim(ylimits);
        
    case 'version'
        
        plot(time_points,mean(cell2mat(res.trials.(Vers)(inds)),2),'color',ColorIt(4));
        xlim(xlimits);
        ylim(ylimits);
        
end


% ...and prediction
if length(inds) > 0
    
    switch plt
        
        case 'monocular'
            
            [ax,h1,h2] = plotyy(time_points_pred,res.trials.(predLE){inds(1)},...
                time_points_pred,res.trials.(predRE){inds(1)});
            
            color_yy(ax,h1,h2,1);
            
            set(ax(1),'YLim',ylimits{1},'YTick',round(ylimits{1}(1)):round(ylimits{1}(2)))
            set(ax(2),'YLim',ylimits{2},'YTick',round(ylimits{2}(1)):round(ylimits{2}(2)))
            
            switch datatype
                
                case 'position'
                    
                    set(get(ax(1),'Ylabel'),'String','Left Eye Position (deg)')
                    set(get(ax(2),'Ylabel'),'String','Right Eye Position (deg)')
                    
                case 'velocity'
                    
                    set(get(ax(1),'Ylabel'),'String','Left Eye Velocity (deg/sec)')
                    set(get(ax(2),'Ylabel'),'String','Right Eye Velocity (deg/sec)')
                    
            end
            
            set(get(ax(1),'Xlabel'),'String','Seconds')
            set(ax,'Xlim',xlimits)
            
        case 'binocular'
            
            [ax,h1,h2] = plotyy(time_points_pred,res.trials.(predLE){inds(1)}...
                -res.trials.(predRE){inds(1)},...
                time_points_pred,mean([res.trials.(predLE){inds(1)} ; res.trials.(predRE){inds(1)}]));
            
            color_yy(ax,h1,h2,1);
            
            set(ax(1),'YLim',ylimits{1},'YTick',round(ylimits{1}(1)):round(ylimits{1}(2)))
            set(ax(2),'YLim',ylimits{2},'YTick',round(ylimits{2}(1)):round(ylimits{2}(2)))
            
            switch datatype
                
                case 'position'
                    
                    set(get(ax(1),'Ylabel'),'String','Vergence (deg)')
                    set(get(ax(2),'Ylabel'),'String','Version (deg)')
                    
                case 'velocity'
                    
                    set(get(ax(1),'Ylabel'),'String','Vergence Velocity (deg/sec)')
                    set(get(ax(2),'Ylabel'),'String','Version Velocity (deg/sec)')
                    
            end
            
            set(get(ax(1),'Xlabel'),'String','Seconds')
            set(ax,'Xlim',xlimits)
            
        case 'vergence'
            
            plot(time_points_pred,res.trials.(predLE){inds(1)}...
                -res.trials.(predRE){inds(1)},'color',ColorIt(3));
            
            xlim(xlimits);
            ylim(ylimits);
            set(gca,'YTick',round(ylimits(1)):round(ylimits(2)))
            
            switch plt
                
                case 'position'
                    
                    ylabel('Vergence (deg)');
                    
                case 'velocity'
                    
                    ylabel('Vergence Velocity (deg/sec)');
                    
            end
            
            xlabel('Seconds')
            
        case 'version'
            
            plot(time_points_pred,...
                mean([res.trials.(predLE){inds(1)} ; res.trials.(predRE){inds(1)}]),'color',ColorIt(4));
            
            xlim(xlimits);
            ylim(ylimits);
            set(gca,'YTick',round(ylimits(1)):round(ylimits(2)))
            
            
            switch plt
                
                case 'position'
                    
                    ylabel('Version (deg)');
                    
                case 'velocity'
                    
                    ylabel('Version Velocity (deg/sec)');
                    
            end
            
            xlabel('Seconds')
            
    end
    
end