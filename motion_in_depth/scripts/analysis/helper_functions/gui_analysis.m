function [] = gui_analysis
%
% gui for loading and setting motion in depth experiment

% load in pre-processed data if available
if exist('../../data/all_data.mat')
    res         = load_data(0);
else
    res         = load_data(1);
end

% initialize options
exp_names   = unique(res.trials.exp_name);
exp_name    = exp_names{1};
subj        = [];
cond        = [];
dir         = [];
dyn         = [];
renable     = {'off','on'};
plts        = {'monocular','binocular','vergence','version'};
plt         = plts(1);
datatypes   = {'position','velocity'};
datatype    = datatypes{1};
set_experiment;

%  Create and then hide the GUI as it is being constructed
sz      = [360,500,500,500];
marg    = 30;
f       = figure('Visible','off','Position',sz);


% experiment options

etext = uicontrol('Style',  'text', ...
    'String',   'Experiment',...
    'Position', [marg,sz(2) - marg,60,25]);

epopup = uicontrol('Style', 'popupmenu',...
    'String',   exp_names,...
    'Position', [marg + 60,sz(2) - marg,200,26],...
    'Callback', {@exp_Callback},...
    'Value',    1);


% reload all data
loadit = uicontrol('Style', 'pushbutton', ...
    'String',           'Reprocess All', ...
    'Callback',         @load_Callback, ...
    'BackgroundColor',  ColorIt('g'), ...
    'Position',         [marg + 300,sz(2) - marg,120,25]);

align([etext,epopup,loadit],'None','Top');


% reload specific data
loadit = uicontrol('Style', 'pushbutton', ...
    'String',           'Process New Session', ...
    'Callback',         @loadSingle_Callback, ...
    'BackgroundColor',  ColorIt('y'), ...
    'Position',         [marg + 300,sz(2) - marg*2,120,25]);



% subject initials
stext = uicontrol('Style','text','String','Subject',...
    'Position',[marg,sz(2) - marg*2,60,25]);
spopup = uicontrol('Style','popupmenu',...
    'String',subjs,...
    'Position',[marg + 60,sz(2) - marg*2,200,26],...
    'Callback',{@subj_Callback},...
    'Value',numel(subjs));

align([stext,spopup],'None','Top');


% data type (position or velocity)
dttext = uicontrol('Style','text','String','Data Type',...
    'Position',[marg,sz(2) - marg*3,60,25]);
dtpopup = uicontrol('Style','popupmenu',...
    'String',datatypes,...
    'Position',[marg + 60,sz(2) - marg*3,100,26],...
    'Callback',{@datatype_Callback},...
    'Value',1);

align([dttext,dtpopup],'None','Top');



% start plotting
plotit = uicontrol('Style', 'pushbutton', ...
    'String',   'Plot It', ...
    'Callback', @plotit_Callback, ...
    'BackgroundColor',ColorIt('b'), ...
    'Position',[marg + 60,sz(2) - marg*14.5,200,25]);



% dot options

% disparity magnitude
d1text = uicontrol('Style','text','String',['Disparity (am): ' num2str(dispArcmin)],...
    'Position',[marg,sz(2) - marg*7,90,30]);

% % stimulus radius
d2text = uicontrol('Style','text','String',['Stim Radius (deg): ' num2str(stimRadDeg)],...
    'Position',[marg + 150,sz(2) - marg*7,90,30]);

% dot diameter
d3text = uicontrol('Style','text','String',['Dot Diam (deg): ' num2str(dotSizeDeg)],...
    'Position',[marg + 150,sz(2) - marg*9,90,30]);

% dot density
d4text = uicontrol('Style','text','String',['Density (d/deg2): ' num2str(dotDensity)],...
    'Position',[marg + 150,sz(2) - marg*8,90,30]);

% prelude time
d7text = uicontrol('Style','text','String',['Mono Velo (deg/sec):' num2str(rampSpeedDegSec)],...
    'Position',[marg,sz(2) - marg*8,90,30]);

% timing

% prelude time
d5text = uicontrol('Style','text','String',['Prelude (sec):' num2str(preludeSec)],...
    'Position',[marg,sz(2) - marg*9,90,30]);

% stim time
d6text = uicontrol('Style','text','String',['Stim (sec) (one ramp): ' num2str(cycleSec)],...
    'Position',[marg,sz(2) - marg*10,90,30]);



% condition options

for c = 1:length(conds)
    cradio(c) = uicontrol('Style', 'radiobutton', ...
        'String',   conds{c}, ...
        'Callback', @condition_Callback, ...
        'Position',[sz(1) - marg,sz(2) - marg*(4 + c),200,25],...
        'Value',    ismember(conds{c},cond), ...
        'Enable', renable{ismember(conds{c},cond) + 1});
end


for d = 1:length(dyns)
    dradio(d) = uicontrol('Style', 'radiobutton', ...
        'String',   dyns{d}, ...
        'Callback', @dynamics_Callback, ...
        'Position',[sz(1) - marg,sz(2) - marg*(11 + d),200,25],...
        'Value',    ismember(dyns{d},dyn), ...
        'Enable', renable{ismember(dyns{d},dyn) + 1});
end


for t = 1:length(dirs)
    
    if t <= 2; locx = 0; else locx = 1; end
    if mod(t,2)==0; locy = 1; else locy = 2; end
    
    tradio(t) = uicontrol('Style', 'radiobutton', ...
        'String',   dirs{t}, ...
        'Callback', @directions_Callback, ...
        'Position',[marg + 90*locx,sz(2) - marg*(11 + locy),100,25],...
        'Value',    ismember(dirs{t},dir), ...
        'Enable', renable{ismember(dirs{t},dir) + 1});
end


% plot type options
for p = 1:length(plts)
    
    if p <= 2; locx = 0; else locx = 1; end
    if mod(p,2)==0; locy = 1; else locy = 2; end
    
    pradio(p) = uicontrol('Style', 'radiobutton', ...
        'String',   plts{p}, ...
        'Callback', @plots_Callback, ...
        'Position',[marg + 90*locx,sz(2) - marg*(3 + locy),100,25],...
        'Value',    ismember(plts{p},plt));
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
text(0.05,0.66,'Stimulus Properties','fontweight','bold','fontsize',14);
%rectangle('Position',[0.05,0.45,0.49,0.2])
text(0.05,0.345,'Motion Directions','fontweight','bold','fontsize',14);
%rectangle('Position',[0.05,0.22,0.33,0.11])
text(0.65,0.77,'Cue Properties','fontweight','bold','fontsize',14);
%rectangle('Position',[0.65,0.39,0.2,0.365])
text(0.65,0.34,'Dynamics','fontweight','bold','fontsize',14);
%rectangle('Position',[0.65,0.15,0.2,0.175])

hold off


% Run the GUI

set(f,'Name','Data Analysis')       %GUI title
movegui(f,'center');                % Move the GUI to the center of the screen
set(f,'Visible','on');              % Make the GUI visible
waitfor(f);                         % Exit if Gui is closed

%  Callbacks for gui. These callbacks automatically
%  have access to component handles and initialized data
%  because they are nested at a lower level.

    function set_experiment
        
        exp_inds    = strcmp(res.trials.exp_name,exp_name);
        
        subjs       = unique(res.trials.subj(exp_inds));
        if length(subjs) > 1
            subjs{end+1} = 'All';
        end
        
        conds = conditions;
        dyns = dynamics;
        dirs = {'left','right','towards','away'};
        
        dispArcmin  = unique(res.trials.dispArcmin(exp_inds));
        stimRadDeg  = unique(res.trials.stimRadDeg(exp_inds & ~strcmp(res.trials.condition,'SingleDot')));
        dotSizeDeg  = unique(res.trials.dotSizeDeg(exp_inds));
        dotDensity  = unique(res.trials.dotDensity(exp_inds));
        preludeSec  = unique(res.trials.preludeSec(exp_inds));
        cycleSec    = unique(res.trials.cycleSec(exp_inds));
        
        if isfield(res.trials,'rampSpeedDegSec')
            rampSpeedDegSec = unique(res.trials.rampSpeedDegSec(exp_inds));
        else
            rampSpeedDegSec = NaN;
        end
        
        subj       = subjs(end);
        cond       = unique(res.trials.condition(exp_inds));
        dyn        = unique(res.trials.dynamics(exp_inds));
        dir        = unique(res.trials.direction(exp_inds));
        
        datatype   = datatypes{1};
        
        if numel(dispArcmin) > 1 || numel(stimRadDeg) > 1 || numel(dotSizeDeg) > 1 ||...
                numel(dotDensity) > 1 || numel(preludeSec) > 1 || numel(cycleSec) > 1 || numel(rampSpeedDegSec) > 1
            error('Experiment has multiple protocols, need to manually delete conflicting data sets')
        end
        
    end


    function exp_Callback(source,~)
        
        str = get(source, 'String');
        val = get(source,'Value');
        
        exp_name = str{val};
        set_experiment;
        
        for x = 1:length(cradio)
            set(cradio(x),'Value',ismember(get(cradio(x),'String'),cond));
            set(cradio(x),'Enable', renable{ismember(get(cradio(x),'String'),cond) + 1});
        end
        
        for y = 1:length(dradio)
            set(dradio(y),'Value',ismember(get(dradio(y),'String'),dyn));
            set(dradio(y),'Enable', renable{ismember(get(dradio(y),'String'),dyn) + 1});
        end
        
        for z = 1:length(tradio)
            set(tradio(z),'Value',ismember(get(tradio(z),'String'),dir));
            set(tradio(z),'Enable', renable{ismember(get(tradio(z),'String'),dir) + 1});
        end
        
        set(spopup,'String',subjs,'Value',numel(subjs));
        
        set(d1text,'String',['Disparity (am): ' num2str(dispArcmin)]);
        set(d2text,'String',['Stim Radius (deg): ' num2str(stimRadDeg)]);
        set(d3text,'String',['Dot Diam (deg): ' num2str(dotSizeDeg)]);
        set(d4text,'String',['Density (d/deg2): ' num2str(dotDensity)]);
        set(d5text,'String',['Prelude (sec):' num2str(preludeSec)]);
        set(d6text,'String',['Stim (sec) (one ramp): ' num2str(cycleSec)]);
        
    end


    function subj_Callback(source,~)
        
        val = get(source,'Value');
        subj = subjs(val);
    end

    function datatype_Callback(source,~)
        
        val = get(source,'Value');
        datatype = datatypes{val};
    end

    function plotit_Callback(source,eventdata)
        
        plot_results(subj,cond,dir,dyn,exp_name,res,plt,datatype)
        
    end


    function load_Callback(source,~)
        
        set(source, 'String', 'Working...','BackgroundColor',ColorIt('r'));
        drawnow;
        
        res = load_data(1);
        exp_names   = unique(res.trials.exp_name);
        set_experiment;
        
        set(epopup,'String',exp_names,'Value',1);
        set(source, 'String', 'Reprocess All','BackgroundColor',ColorIt('g'));
        
    end


    function loadSingle_Callback(source,~)
        
        set(source, 'String', 'Working...','BackgroundColor',ColorIt('r'));
        drawnow;
        
        res = load_data(2);
        exp_names   = unique(res.trials.exp_name);
        set_experiment;
        
        set(epopup,'String',exp_names,'Value',1);
        set(source, 'String', 'Process New Session','BackgroundColor',ColorIt('y'));
        
    end


    function newName_Callback(source,eventdata)
        
        str = get(source, 'String');
        
        if ~isempty(str2num(str(1))) && ~strcmp('i',str(1)) && ~strcmp('j',str(1))
            dat.exp_name_new = 'tmpfile';
            warning('Filename cannot start with a number or i or j');
        else
            dat.exp_name_new = str;
        end
    end


    function storeExp_Callback(source,eventdata)
        
        gui_create_new_experiment(dat)
        
        exp         = gui_load_experiments;
        set(epopup,'String',{exp(:).name}, ...
            'Value',find(strcmp({exp(:).name},dat.exp_name_new)));
        
    end


    function condition_Callback(source,eventdata)
        
        val = get(source,'Value');
        cname = get(source,'String');
        
        if val && ~ismember(cname,cond)
            cond{end+1} = cname;
        elseif ~val && ismember(cname,cond)
            ind = find(ismember(cond,cname));
            cond(ind) = [];
        end
        
    end



    function dynamics_Callback(source,eventdata)
        
        val = get(source,'Value');
        dname = get(source,'String');
        
        if val && ~ismember(dname,dyn)
            dyn{end+1} = dname;
        elseif ~val && ismember(dname,dyn)
            ind = find(ismember(dyn,dname));
            dyn(ind) = [];
        end
        
    end


    function directions_Callback(source,eventdata)
        
        val = get(source,'Value');
        tname = get(source,'String');
        
        if val && ~ismember(tname,dir)
            dir{end+1} = tname;
        elseif ~val && ismember(tname,dir)
            ind = find(ismember(dir,tname));
            dir(ind) = [];
        end
        
    end


    function plots_Callback(source,eventdata)
        
        val = get(source,'Value');
        pname = get(source,'String');
        
        if val && ~ismember(pname,plt)
            plt{end+1} = pname;
        elseif ~val && ismember(pname,plt)
            ind = find(ismember(plt,pname));
            plt(ind) = [];
        end
        
    end

end