function [dat,scr] = gui_settings(settings)
%
% gui for loading and setting motion in depth experiment

% load in options
dspl        = displays;
conds       = conditions;
dyn         = dynamics;
ipdmat      = ipds;
dirs        = {'away','towards','left','right'};
exp         = gui_load_experiments;

% load in experiment settings
if isempty(settings)
    dat             = default;
    dat.exp_name    = 'default';
    scr				= dspl(find(strcmp({dspl(:).name},dat.display)));
else
    dat             = eval(settings{1});
    dat.exp_name    = settings{1};
    dat.subj        = 'XX';
    scr				= dspl(find(strcmp({dspl(:).name},dat.display)));
    
    return
end

% don't start experiment until all settings are selected
go      = 0;
subj    = 'XX';
ipd     = 0;
exp_mod = 0;
num_trials = 0;
update_num_trials(0);


%  Create and then hide the GUI as it is being constructed
sz      = [0,0,800,800];
marg    = 0.02;
text_sz = 0.1;
text_ht = 0.04;
box_sp  = 0.075;
f       = figure('Visible','off','Position',sz);
a       = axes;
set(a, 'Visible', 'off');
set(a, 'Position', [0, 0, 1, 1]);   % Stretch the axes over the whole figure.
set(a, 'Xlim', [0, 1], 'YLim', [0, 1]); % Switch off autoscaling.

% Main experiment options box
box1 = [marg 1-marg-text_ht 0.5 0.81]; % left top right bottom box coords
[epopup,warn_me,pbox,dpopup] = draw_main_options_box(box1);


% Recording and feedback options box
box2 = [box1(1) box1(4)-box_sp 0.5 0.725]; % left top right bottom box coords
[rradio,fradio] = draw_recording_options_box(box2);


% Dot options box
box3 = [box2(1) box2(4)-box_sp*1.2 0.5 0.5]; % left top right bottom box coords
[d1box,d2box,d3box,d4box,d8box] = draw_dots_options_box(box3);


% Timing options box
box4 = [box3(1) box3(4)-box_sp*1.2 0.5 0.3]; % left top right bottom box coords
[d5box,d6box,d7box,numtext,durtext] = draw_timing_options_box(box4);


% Conditions options box
box5 = [box1(3)+box_sp box1(2)-text_ht 0.725 0.6]; % left top right bottom box coords
[cradio] = draw_condition_options_box(box5);


% Dynamics options box
box6 = [box5(3)+box_sp box1(2)-text_ht 0.95 0.75]; % left top right bottom box coords
[dradio] = draw_dynamics_options_box(box6);


% Directions options box
box7 = [box5(3)+box_sp box6(4)-box_sp 0.95 0.5]; % left top right bottom box coords
[tradio] = draw_directions_options_box(box7);



% Experiment start box
box_end = [marg 0.09 0.35 marg]; % left top right bottom box coords
[start,zbox,store] = draw_start_options_box(box_end);



% Run the GUI

set(findall(f,'-property','FontSize'),'FontSize',12)
set(f,'Name','MID Experiment Settings') %GUI title
movegui(f,'center');             % Move the GUI to the center of the screen
set(f,'Visible','on');              % Make the GUI visible
waitfor(f);                         % Exit if Gui is closed

gui_store_ipd(dat,ipds)                  % store initials/IPD pair for this session

if(~go)
    error('GUI exited without pressing Start');
end

%  Callbacks for gui. These callbacks automatically
%  have access to component handles and initialized data
%  because they are nested at a lower level.


    function exp_Callback(source,eventdata)
        
        str = get(source, 'String');
        val = get(source,'Value');
        dat             = eval(str{val});
        dat.subj        = subj;
        dat.ipd         = ipd;
        dat.exp_name    = str{val};
        scr				= dspl(find(strcmp({dspl(:).name},dat.display)));
        
        update_num_trials(1)
        
        set(dpopup,'Value',find(strcmp({dspl(:).name},dat.display)));
        set(rradio,'Value',dat.recording);
        set(fradio,'Value',dat.training);
        
        set(d1box,'String',num2str(dat.dispArcmin));
        set(d8box,'String',num2str(dat.rampSpeedDegSec));
        set(d2box,'String',num2str(dat.stimRadDeg));
        set(d3box,'String',num2str(dat.dotSizeDeg));
        set(d4box,'String',num2str(dat.dotDensity));
        
        set(d5box,'String',num2str(dat.preludeSec));
        set(d6box,'String',num2str(dat.cycleSec));
        set(d7box,'String',num2str(dat.cond_repeats));
        
        for x = 1:length(cradio)
            set(cradio(x),'Value',ismember(get(cradio(x),'String'),dat.conditions));
        end
        
        for y = 1:length(dradio)
            set(dradio(y),'Value',ismember(get(dradio(y),'String'),dat.dynamics));
        end
        
        for z = 1:length(tradio)
            set(tradio(z),'Value',ismember(get(tradio(z),'String'),dat.directions));
        end
        
        
    end


    function subj_Callback(source,eventdata)
        
        str = get(source, 'String');
        subj = str;
        
        if sum(ismember(ipdmat.subj,subj)) > 0
            ipd = ipdmat.ipd(ismember(ipdmat.subj,subj));
            set(pbox,'String',ipd);
        end
    end

    function ipd_Callback(source,eventdata)
        
        str = get(source, 'String');
        ipd = str2num(str);
        
    end


    function display_Callback(source,eventdata)
        str			= get(source, 'String');
        val			= get(source,'Value');
        dat.display = str{val};
        scr			= dspl(find(strcmp({dspl(:).name},dat.display)));
        exp_mod     = 1;
        
        set(warn_me,'String','Conditions changed, rename exp','BackgroundColor',ColorIt(5));
    end


    function recording_Callback(source,eventdata)
        
        val = get(source,'Value');
        dat.recording = val;
        
        set(warn_me,'String','Conditions changed, but Okay to run','BackgroundColor',ColorIt(5));
    end


    function feedback_Callback(source,eventdata)
        
        val = get(source,'Value');
        dat.training = val;
        
        set(warn_me,'String','Conditions changed, but Okay to run','BackgroundColor',ColorIt(5));
    end


    function start_Callback(source,eventdata)
        
        go          = 1;
        dat.subj    = subj;
        dat.ipd     = ipd;
        
        if ipd == 0
            set(warn_me,'String','WARNING: IPD cannot be zero','BackgroundColor',ColorIt(1));
            error('cannot run experiment without IPD filled in')
        end
        
        if exp_mod == 1
            set(warn_me,'String','WARNING: Exp modified, rename it','BackgroundColor',ColorIt(1));
            error('cannot run experiment without changing name')
        end
        
        close all;
    end


    function newName_Callback(source,eventdata)
        
        str = get(source, 'String');
        
        if ~isempty(str2num(str(1))) && ~strcmp('i',str(1)) && ~strcmp('j',str(1))
            dat.exp_name = 'tmpfile';
        else
            dat.exp_name = str;
        end
    end


    function storeExp_Callback(source,eventdata)
        
        if strcmp(dat.exp_name,'tmpfile')
            set(warn_me,'String','WARNING: Filename cannot start with a number','BackgroundColor',ColorIt(1));
            error('Filename cannot start with a number');
        else
            gui_create_new_experiment(dat)
            
            exp         = gui_load_experiments;
            set(epopup,'String',{exp(:).name}, ...
                'Value',find(strcmp({exp(:).name},dat.exp_name)));
            set(warn_me,'String','','BackgroundColor',[.94 .94 .94]);
            
            exp_mod     = 0;
        end
        
    end



    function text_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.(get(source,'tag')) = str2num(str);
        
        if ~strcmp(get(source,'tag'),'cond_repeats')
            exp_mod     = 1;
        else
            update_num_trials(1)
        end
        
        if ~strcmp(get(source,'tag'),'cond_repeats')
            set(warn_me,'String','Conditions changed, Rename exp','BackgroundColor',ColorIt('r'));
        else
            set(warn_me,'String','Conditions changed, but Okay to run','BackgroundColor',ColorIt('p'));
        end
        
        
    end


    function condition_Callback(source,eventdata)
        
        val = get(source,'Value');
        
        cname = get(source,'String');
        
        if val && ~ismember(cname,dat.conditions)
            dat.conditions{end+1} = cname;
        elseif ~val && ismember(cname,dat.conditions)
            ind = find(ismember(dat.conditions,cname));
            dat.conditions(ind) = [];
        end
        
        update_num_trials(1)
        
        set(warn_me,'String','Conditions changed, but Okay to run','BackgroundColor',ColorIt(5));
    end



    function dynamics_Callback(source,eventdata)
        
        val = get(source,'Value');
        
        dname = get(source,'String');
        
        if val && ~ismember(dname,dat.dynamics)
            dat.dynamics{end+1} = dname;
        elseif ~val && ismember(dname,dat.dynamics)
            ind = find(ismember(dat.dynamics,dname));
            dat.dynamics(ind) = [];
        end
        
        update_num_trials(1)
        
        set(warn_me,'String','Conditions changed, but Okay to run','BackgroundColor',ColorIt(5));
    end


    function directions_Callback(source,eventdata)
        
        val = get(source,'Value');
        
        tname = get(source,'String');
        
        if val && ~ismember(tname,dat.directions)
            dat.directions{end+1} = tname;
        elseif ~val && ismember(tname,dat.directions)
            ind = find(ismember(dat.directions,tname));
            dat.directions(ind) = [];
        end
        
        update_num_trials(1)
        
        set(warn_me,'String','Conditions changed, but Okay to run','BackgroundColor',ColorIt(5));
    end

    function  update_num_trials(flag)
        
        num_trials  = (dat.cond_repeats...
            *length(dat.directions)*length(dat.dynamics)...
            *length(dat.conditions));
        
        if(flag)
            set(numtext,'String',['Num Trials: ' num2str(num_trials)]);
            set(durtext,'String',['Duration: ' num2str((num_trials*(5+dat.preludeSec+dat.cycleSec))/60) ' Min']);
        end
        
    end

    function [epopup,warn_me,pbox,dpopup] = draw_main_options_box(box)
        
        % experiment options
        etext = uicontrol('Style','text','String','Experiment',...
            'Units','normalized', ...
            'Position',[box(1),box(2),text_sz,text_ht]);
        
        epopup = uicontrol('Style','popupmenu',...
            'Units','normalized', ...
            'String',{exp(:).name},...
            'Position',[box(1)+text_sz,box(2),text_sz*2,text_ht],...
            'Callback',{@exp_Callback},...
            'Value',find(strcmp({exp(:).name},dat.exp_name)));
        
        
        % warning if these got changed
        warn_me = uicontrol('Style','text','String','All Settings are good',...
            'BackgroundColor',ColorIt(4), ...
            'Units','normalized', ...
            'Position',[box(1)+text_sz*3,box(2),text_sz*1.5,text_ht]);
        
        align([etext,epopup,warn_me],'None','Top');
        
        
        % subject initials
        stext = uicontrol('Style','text','String','Subject',...
            'Units','normalized', ...
            'Position',[box(1),box(2)-text_ht-marg,text_sz,text_ht]);
        
        sbox = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',subj,...
            'Position',[box(1)+text_sz,box(2)-text_ht-marg,text_sz,text_ht],...
            'Callback',{@subj_Callback});
        
        
        % IPD
        ptext = uicontrol('Style','text','String','IPD (cm)',...
            'Units','normalized', ...
            'Position',[box(1)+text_sz*2,box(2)-text_ht-marg,text_sz,text_ht]);
        
        pbox = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',ipd,...
            'Position',[box(1)+text_sz*3,box(2)-text_ht-marg,text_sz,text_ht],...
            'Callback',{@ipd_Callback});
        
        align([stext,sbox,ptext,pbox],'None','Top');
        
        
        % display options
        dtext = uicontrol('Style','text','String','Display',...
            'Units','normalized', ...
            'Position',[box(1),box(2)-text_ht*2-marg*2,text_sz,text_ht]);
        dpopup = uicontrol('Style','popupmenu',...
            'Units','normalized', ...
            'String',{dspl(:).name},...
            'Position',[box(1)+text_sz,box(2)-text_ht*2-marg*2,text_sz*2,text_ht],...
            'Callback',{@display_Callback},...
            'Value',find(strcmp({dspl(:).name},dat.display)));
        
        
        align([dtext,dpopup],'None','Top');
        
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end




    function [rradio,fradio] = draw_recording_options_box(box)
        
        % recording options
        rradio = uicontrol('Style', 'radiobutton', ...
            'Units','normalized', ...
            'String',   'record', ...
            'Callback', @recording_Callback, ...
            'Position',[box(1),box(2),text_sz*2,text_ht],...
            'Value',    dat.recording);
        
        % feedback options
        fradio = uicontrol('Style', 'radiobutton', ...
            'Units','normalized', ...
            'String',   'provide feedback', ...
            'Callback', @feedback_Callback, ...
            'Position',[box(1)+text_sz*2,box(2),text_sz*2,text_ht],...
            'Value',    dat.training);
        
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end


    function [d1box,d2box,d3box,d4box,d8box] = draw_dots_options_box(box)
        
        % dot options
        
        
        % disparity magnitude
        d1text = uicontrol('Style','text','String','Step Disp (arcmin)',...
            'Units','normalized', ...
            'Position',[box(1),box(2),text_sz,text_ht]);
        d1box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.dispArcmin,...
            'Position',[box(1)+text_sz,box(2),text_sz,text_ht],...
            'BackgroundColor',ColorIt(3), ...
            'Tag','dispArcmin', ...
            'Callback',{@text_Callback});
        
        % ramp velocity
        d8text = uicontrol('Style','text','String','Mono Speed (deg/sec)',...
            'Units','normalized', ...
            'Position',[box(1),box(2)-text_ht-marg,text_sz,text_ht]);
        d8box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.rampSpeedDegSec,...
            'Position',[box(1)+text_sz,box(2)-text_ht-marg,text_sz,text_ht],...
            'BackgroundColor',ColorIt(3), ...
            'Tag','rampSpeedDegSec', ...
            'Callback',{@text_Callback});
        
        % stimulus radius
        d2text = uicontrol('Style','text','String','Stim Radius (deg)',...
            'Units','normalized', ...
            'Position',[box(1)+text_sz*2,box(2),text_sz,text_ht]);
        d2box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.stimRadDeg,...
            'Position',[box(1)+text_sz*3,box(2),text_sz,text_ht],...
            'Tag','stimRadDeg', ...
            'Callback',{@text_Callback});
        
        % dot diameter
        d3text = uicontrol('Style','text','String','Dot Diam (deg)',...
            'Units','normalized', ...
            'Position',[box(1)+text_sz*2,box(2)-text_ht-marg,text_sz,text_ht]);
        d3box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.dotSizeDeg,...
            'Position',[box(1)+text_sz*3,box(2)-text_ht-marg,text_sz,text_ht],...
            'Tag','dotSizeDeg', ...
            'Callback',{@text_Callback});
        
        % dot density
        d4text = uicontrol('Style','text','String','Density (d/deg2)',...
            'Units','normalized', ...
            'Position',[box(1)+text_sz*2,box(2)-text_ht*2-marg*2,text_sz,text_ht]);
        d4box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.dotDensity,...
            'Position',[box(1)+text_sz*3,box(2)-text_ht*2-marg*2,text_sz,text_ht],...
            'Tag','dotDensity', ...
            'Callback',{@text_Callback});
        
        text(box(1),box(2) + text_ht*1.2+ 0.01,'Stimulus Properties');
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end




    function [d5box,d6box,d7box,numtext,durtext] = draw_timing_options_box(box)
        
        % timing
        
        % prelude time
        d5text = uicontrol('Style','text','String','Prelude (sec)',...
            'Units','normalized', ...
            'Position',[box(1),box(2),text_sz,text_ht]);
        d5box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.preludeSec,...
            'Position',[box(1)+text_sz,box(2),text_sz,text_ht],...
            'Tag','preludeSec', ...
            'Callback',{@text_Callback});
        
        % stim time
        d6text = uicontrol('Style','text','String','Stim (sec) (one ramp)',...
            'Units','normalized', ...
            'Position',[box(1),box(2)-text_ht-marg,text_sz,text_ht]);
        d6box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.cycleSec,...
            'Position',[box(1)+text_sz,box(2)-text_ht-marg,text_sz,text_ht],...
            'Tag','cycleSec', ...
            'Callback',{@text_Callback});
        
        % condition repeats
        d7text = uicontrol('Style','text','String','Num repeats',...
            'Units','normalized', ...
            'Position',[box(1)+text_sz*2,box(2),text_sz,text_ht]);
        d7box = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String',dat.cond_repeats,...
            'Position',[box(1)+text_sz*3,box(2),text_sz,text_ht],...
            'Tag','cond_repeats', ...
            'Callback',{@text_Callback});
        
        
        numtext = uicontrol('Style','text','String',...
            ['Num Trials: ' num2str(num_trials)],...
            'Units','normalized', ...
            'BackgroundColor',ColorIt(3),...
            'Position',[box(1)+text_sz*3,box(2)-text_ht-marg,text_sz,text_ht]);
        
        durtext = uicontrol('Style','text','String',...
            ['Duration: ' num2str((num_trials*(5+dat.preludeSec+dat.cycleSec))/60) ' Min'],...
            'Units','normalized', ...
            'BackgroundColor',ColorIt(3),...
            'Position',[box(1)+text_sz*3,box(2)-text_ht*2-marg,text_sz,text_ht]);
        
        
        
        text(box(1),box(2) + text_ht*1.2+ 0.01,'Timing');
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end



    function [cradio] = draw_condition_options_box(box)
        
        
        % condition options
        for c = 1:length(conds)
            cradio(c) = uicontrol('Style', 'radiobutton', ...
                'String',   conds{c}, ...
                'Units','normalized', ...
                'Callback', @condition_Callback, ...
                'Position',[box(1),box(2)-text_ht*(c-1),text_sz*1.2,text_ht],...
                'Value',    ismember(conds{c},dat.conditions));
        end
        
        text(box(1),box(2) + text_ht*1.2+ 0.01,'Conditions');
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end


    function [dradio] = draw_dynamics_options_box(box)
        
        
        for d = 1:length(dyn)
            dradio(d) = uicontrol('Style', 'radiobutton', ...
                'String',   dyn{d}, ...
                'Units','normalized', ...
                'Callback', @dynamics_Callback, ...
                'Position',[box(1),box(2)-text_ht*(d-1),text_sz*1.2,text_ht],...
                'Value',    ismember(dyn{d},dat.dynamics));
        end
        
        text(box(1),box(2) + text_ht*1.2+ 0.01,'Dynamics');
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end


    function [tradio] = draw_directions_options_box(box)
        
        
        for t = 1:length(dirs)
            
            tradio(t) = uicontrol('Style', 'radiobutton', ...
                'String',   dirs{t}, ...
                'Units','normalized', ...
                'Callback', @directions_Callback, ...
                'Position',[box(1),box(2)-text_ht*(t-1),text_sz*1.2,text_ht],...
                'Value',    ismember(dirs{t},dat.directions));
        end
        
        
        text(box(1),box(2) + text_ht*1.2+ 0.01,'Directions');
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end


    function [start,zbox,store] = draw_start_options_box(box)
        
        
        % start experiment
        start = uicontrol('Style', 'pushbutton', ...
            'Units','normalized', ...
            'String',   'Start', ...
            'Callback', @start_Callback, ...
            'BackgroundColor',ColorIt(4), ...
            'Position',[box(1),box(2),text_sz,text_ht]);
        
        
        % save as new experiment
        zbox = uicontrol('Style','edit',...
            'Units','normalized', ...
            'String','NewName',...
            'Position',[box(1),box(2)-text_ht*1.1,text_sz*2,text_ht],...
            'Callback',{@newName_Callback});
        
        store = uicontrol('Style', 'pushbutton', ...
            'Units','normalized', ...
            'String',   'Store Settings', ...
            'Callback', @storeExp_Callback, ...
            'Position',[box(1)+text_sz*2,box(2)-text_ht*1.1,text_sz*1.1,text_ht]);
        
        %text(box(1),box(2) + text_ht*1.2+ 0.01,'Directions');
        rectangle('Position',[box(1)-0.01,box(4),box(3) - box(1),box(2) + text_ht + 0.01 - box(4)])
        
        
    end








end