function [dat,scr] = gui_settings(settings)
%
% gui for loading and setting motion in depth experiment

% load in options
dspl        = displays;
conds       = conditions;
dyn         = dynamics;
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


%  Create and then hide the GUI as it is being constructed
sz      = [360,500,500,500];
marg    = 30;
f       = figure('Visible','off','Position',sz);


% experiment options
etext = uicontrol('Style','text','String','Experiment',...
    'Position',[marg,sz(2) - marg,60,25]);
epopup = uicontrol('Style','popupmenu',...
    'String',{exp(:).name},...
    'Position',[marg + 60,sz(2) - marg,200,26],...
    'Callback',{@exp_Callback},...
    'Value',find(strcmp({exp(:).name},dat.exp_name)));

warn_me = uicontrol('Style','text','String','',...
    'Position',[marg + 275,sz(2) - marg,190,25]);

align([etext,epopup,warn_me],'None','Top');


% subject initials
stext = uicontrol('Style','text','String','Subject',...
    'Position',[marg,sz(2) - marg*2,60,25]);
sbox = uicontrol('Style','edit',...
    'String',subj,...
    'Position',[marg + 60,sz(2) - marg*2,60,26],...
    'Callback',{@subj_Callback});

% IPD
ptext = uicontrol('Style','text','String','IPD (cm)',...
    'Position',[marg + 130,sz(2) - marg*2,60,25]);
pbox = uicontrol('Style','edit',...
    'String',ipd,...
    'Position',[marg + 190,sz(2) - marg*2,60,26],...
    'Callback',{@ipd_Callback});

align([stext,sbox,ptext,pbox],'None','Top');


% display options
dtext = uicontrol('Style','text','String','Display',...
    'Position',[marg,sz(2) - marg*3,60,25]);
dpopup = uicontrol('Style','popupmenu',...
    'String',{dspl(:).name},...
    'Position',[marg + 60,sz(2) - marg*3,200,26],...
    'Callback',{@display_Callback},...
    'Value',find(strcmp({dspl(:).name},dat.display)));


align([dtext,dpopup],'None','Top');


% recording options
rradio = uicontrol('Style', 'radiobutton', ...
    'String',   'record', ...
    'Callback', @recording_Callback, ...
    'Position',[marg + 60,sz(2) - marg*4,200,25],...
    'Value',    dat.recording);

% feedback options
fradio = uicontrol('Style', 'radiobutton', ...
    'String',   'provide feedback', ...
    'Callback', @feedback_Callback, ...
    'Position',[marg + 60,sz(2) - marg*5,200,25],...
    'Value',    dat.training);


% start experiment
start = uicontrol('Style', 'pushbutton', ...
    'String',   'Start', ...
    'Callback', @start_Callback, ...
    'BackgroundColor',get_color(4), ...
    'Position',[marg + 60,sz(2) - marg*14.5,200,25]);


% save as new experiment
zbox = uicontrol('Style','edit',...
    'String','NewName',...
    'Position',[marg + 60,marg,200,25],...
    'Callback',{@newName_Callback});

store = uicontrol('Style', 'pushbutton', ...
    'String',   'Store Settings', ...
    'Callback', @storeExp_Callback, ...
    'Position',[marg + 275,marg,100,25]);

align([store,zbox],'None','Top');





% dot options


% disparity magnitude
d1text = uicontrol('Style','text','String','Disparity (am)',...
    'Position',[marg,sz(2) - marg*7,60,30]);
d1box = uicontrol('Style','edit',...
    'String',dat.dispArcmin,...
    'Position',[marg + 60,sz(2) - marg*7,50,31],...
    'BackgroundColor',ColorIt(3), ...
    'Tag','dispArcmin', ...
    'Callback',{@text_Callback});

align([d1text,d1box],'None','Center');

% stimulus radius
d2text = uicontrol('Style','text','String','Stim Radius (deg)',...
    'Position',[marg + 150,sz(2) - marg*7,60,30]);
d2box = uicontrol('Style','edit',...
    'String',dat.stimRadDeg,...
    'Position',[marg + 210,sz(2) - marg*7,50,31],...
    'Tag','stimRadDeg', ...
    'Callback',{@text_Callback});

align([d2text,d2box],'None','Center');

% dot diameter
d3text = uicontrol('Style','text','String','Dot Diam (deg)',...
    'Position',[marg,sz(2) - marg*8,60,30]);
d3box = uicontrol('Style','edit',...
    'String',dat.dotSizeDeg,...
    'Position',[marg + 60,sz(2) - marg*8,50,31],...
    'Tag','dotSizeDeg', ...
    'Callback',{@text_Callback});

align([d3text,d3box],'None','Center');

% dot density
d4text = uicontrol('Style','text','String','Density (d/deg2)',...
    'Position',[marg + 150,sz(2) - marg*8,60,30]);
d4box = uicontrol('Style','edit',...
    'String',dat.dotDensity,...
    'Position',[marg + 210,sz(2) - marg*8,50,31],...
    'Tag','dotDensity', ...
    'Callback',{@text_Callback});

align([d4text,d4box],'None','Center');



% timing



% prelude time
d5text = uicontrol('Style','text','String','Prelude (sec)',...
    'Position',[marg,sz(2) - marg*9,60,30]);
d5box = uicontrol('Style','edit',...
    'String',dat.preludeSec,...
    'Position',[marg + 60,sz(2) - marg*9,50,31],...
    'Tag','preludeSec', ...
    'Callback',{@text_Callback});

align([d5text,d5box],'None','Center');

% stim time
d6text = uicontrol('Style','text','String','Stim (sec) (one ramp)',...
    'Position',[marg + 150,sz(2) - marg*9,60,30]);
d6box = uicontrol('Style','edit',...
    'String',dat.cycleSec,...
    'Position',[marg + 210,sz(2) - marg*9,50,31],...
    'Tag','cycleSec', ...
    'Callback',{@text_Callback});

align([d6text,d6box],'None','Center');

% condition repeats
d7text = uicontrol('Style','text','String','Num repeats',...
    'Position',[marg,sz(2) - marg*10,60,30]);
d7box = uicontrol('Style','edit',...
    'String',dat.cond_repeats,...
    'Position',[marg + 60,sz(2) - marg*10,50,31],...
    'Tag','cond_repeats', ...
    'Callback',{@text_Callback});

align([d7text,d7box],'None','Center');



% condition options

for c = 1:length(conds)
    cradio(c) = uicontrol('Style', 'radiobutton', ...
        'String',   conds{c}, ...
        'Callback', @condition_Callback, ...
        'Position',[sz(1) - marg,sz(2) - marg*(4 + c),200,25],...
        'Value',    ismember(conds{c},dat.conditions));
end


for d = 1:length(dyn)
    dradio(d) = uicontrol('Style', 'radiobutton', ...
        'String',   dyn{d}, ...
        'Callback', @dynamics_Callback, ...
        'Position',[sz(1) - marg,sz(2) - marg*(11 + d),200,25],...
        'Value',    ismember(dyn{d},dat.dynamics));
end


for t = 1:length(dirs)
    
    if t <= 2; locx = 1; else locx = 2; end
    if mod(t,2)==0; locy = 1; else locy = 2; end
    
    tradio(t) = uicontrol('Style', 'radiobutton', ...
        'String',   dirs{t}, ...
        'Callback', @directions_Callback, ...
        'Position',[marg + 90*locx,sz(2) - marg*(11 + locy),100,25],...
        'Value',    ismember(dirs{t},dat.directions));
end



% draw boxes

a = axes;
set(a, 'Visible', 'off');
%# Stretch the axes over the whole figure.
set(a, 'Position', [0, 0, 1, 1]);
%# Switch off autoscaling.
set(a, 'Xlim', [0, 1], 'YLim', [0, 1]);

%# Draw!
hold on;
text(0.05,0.66,'Stimulus Properties');
rectangle('Position',[0.05,0.39,0.53,0.25])
text(0.23,0.345,'Motion Directions');
rectangle('Position',[0.23,0.22,0.29,0.11])
text(0.65,0.77,'Cue Properties');
rectangle('Position',[0.65,0.39,0.2,0.365])
text(0.65,0.34,'Dynamics');
rectangle('Position',[0.65,0.15,0.2,0.175])

hold off



% Run the GUI

set(f,'Name',[dat.exp_name ' MID Experiment Settings']) %GUI title
movegui(f,'center');             % Move the GUI to the center of the screen
set(f,'Visible','on');              % Make the GUI visible
waitfor(f);                         % Exit if Gui is closed

if(~go)
    error('GUI exited without pressing Start');
end

%  Callbacks for simple_gui. These callbacks automatically
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
        
        %set(sbox,'String',subj);
        set(dpopup,'Value',find(strcmp({dspl(:).name},dat.display)));
        set(rradio,'Value',dat.recording);
        set(fradio,'Value',dat.training);
        
        set(d1box,'String',num2str(dat.dispArcmin));
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
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end


    function recording_Callback(source,eventdata)
        
        val = get(source,'Value');
        dat.recording = val;
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end


    function feedback_Callback(source,eventdata)
        
        val = get(source,'Value');
        dat.training = val;
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end


    function start_Callback(source,eventdata)
        
        go          = 1;
        dat.subj    = subj;
        dat.ipd     = ipd;
        
        if ipd == 0
            set(warn_me,'String','WARNING: IPD cannot be zero','BackgroundColor',ColorIt(4));
            error('cannot run experiment without IPD filled in')
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
            set(warn_me,'String','WARNING: Filename cannot start with a number','BackgroundColor',ColorIt(2));
            error('Filename cannot start with a number');
        else
            gui_create_new_experiment(dat)
            
            exp         = gui_load_experiments;
            set(epopup,'String',{exp(:).name}, ...
                'Value',find(strcmp({exp(:).name},dat.exp_name)));
            set(warn_me,'String','','BackgroundColor',[.94 .94 .94]);
        end
        
    end



    function text_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.(get(source,'tag')) = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end


    function disp_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.dispArcmin = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end


    function radius_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.stimRadDeg = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end

    function size_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.dotSizeDeg = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end

    function density_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.dotDensity = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end

    function prelude_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.preludeSec = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end

    function cycle_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.cycleSec = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end

    function repeat_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.cond_repeats = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
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
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
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
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
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
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',get_color(1));
    end


end