function [] = gui_analysis
%
% gui for loading and setting motion in depth experiment

% load in pre-processed data
res = load_data(0);

% options
exp_names   = unique(res.trials.exp_name);
exp_name    = exp_names{1};
subj = [];
cond = [];
dir = [];
dyn = [];
set_experiment;

%  Create and then hide the GUI as it is being constructed
sz      = [360,500,500,500];
marg    = 30;
f       = figure('Visible','off','Position',sz);


% experiment options
etext = uicontrol('Style','text','String','Experiment',...
    'Position',[marg,sz(2) - marg,60,25]);
epopup = uicontrol('Style','popupmenu',...
    'String',exp_names,...
    'Position',[marg + 60,sz(2) - marg,200,26],...
    'Callback',{@exp_Callback},...
    'Value',1);

% reload data
loadit = uicontrol('Style', 'pushbutton', ...
    'String',   'Reprocess', ...
    'Callback', @load_Callback, ...
    'BackgroundColor',ColorIt(4), ...
    'Position',[marg + 300,sz(2) - marg,100,25]);

align([etext,epopup,loadit],'None','Top');


% subject initials
stext = uicontrol('Style','text','String','Subject',...
    'Position',[marg,sz(2) - marg*2,60,25]);
spopup = uicontrol('Style','popupmenu',...
    'String',subjs,...
    'Position',[marg + 60,sz(2) - marg*2,200,26],...
    'Callback',{@subj_Callback},...
    'Value',1);

align([stext,spopup],'None','Top');


% feedback options
fradio = uicontrol('Style', 'radiobutton', ...
    'String',   'provide feedback', ...
    'Callback', @feedback_Callback, ...
    'Position',[marg + 60,sz(2) - marg*5,200,25],...
    'Value',    0);


% start experiment
plotit = uicontrol('Style', 'pushbutton', ...
    'String',   'Plot It', ...
    'Callback', @plotit_Callback, ...
    'BackgroundColor',ColorIt(4), ...
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
d1text = uicontrol('Style','text','String',['Disparity (am): ' num2str(dispArcmin)],...
    'Position',[marg,sz(2) - marg*7,90,30]);

% % stimulus radius
d2text = uicontrol('Style','text','String',['Stim Radius (deg): ' num2str(stimRadDeg)],...
    'Position',[marg + 150,sz(2) - marg*7,90,30]);

% dot diameter
d3text = uicontrol('Style','text','String',['Dot Diam (deg): ' num2str(dotSizeDeg)],...
    'Position',[marg,sz(2) - marg*8,90,30]);

% dot density
d4text = uicontrol('Style','text','String',['Density (d/deg2): ' num2str(dotDensity)],...
    'Position',[marg + 150,sz(2) - marg*8,90,30]);

% timing

% prelude time
d5text = uicontrol('Style','text','String',['Prelude (sec):' num2str(preludeSec)],...
    'Position',[marg,sz(2) - marg*9,90,30]);

% stim time
d6text = uicontrol('Style','text','String',['Stim (sec) (one ramp): ' num2str(cycleSec)],...
    'Position',[marg + 150,sz(2) - marg*9,90,30]);




% condition options

for c = 1:length(conds)
    cradio(c) = uicontrol('Style', 'radiobutton', ...
        'String',   conds{c}, ...
        'Callback', @condition_Callback, ...
        'Position',[sz(1) - marg,sz(2) - marg*(4 + c),200,25],...
        'Value',    1);
end


for d = 1:length(dyns)
    dradio(d) = uicontrol('Style', 'radiobutton', ...
        'String',   dyns{d}, ...
        'Callback', @dynamics_Callback, ...
        'Position',[sz(1) - marg,sz(2) - marg*(11 + d),200,25],...
        'Value',    1);
end


for t = 1:length(dirs)
    
    if t <= 2; locx = 1; else locx = 2; end
    if mod(t,2)==0; locy = 1; else locy = 2; end
    
    tradio(t) = uicontrol('Style', 'radiobutton', ...
        'String',   dirs{t}, ...
        'Callback', @directions_Callback, ...
        'Position',[marg + 90*locx,sz(2) - marg*(11 + locy),100,25],...
        'Value',    1);
end



% draw boxes
%
% a = axes;
% set(a, 'Visible', 'off');
% %# Stretch the axes over the whole figure.
% set(a, 'Position', [0, 0, 1, 1]);
% %# Switch off autoscaling.
% set(a, 'Xlim', [0, 1], 'YLim', [0, 1]);
%
% % %# Draw!
% hold on;
% text(0.05,0.66,'Stimulus Properties');
% rectangle('Position',[0.05,0.39,0.53,0.25])
% text(0.23,0.345,'Motion Directions');
% rectangle('Position',[0.23,0.22,0.29,0.11])
% text(0.65,0.77,'Cue Properties');
% rectangle('Position',[0.65,0.39,0.2,0.365])
% text(0.65,0.34,'Dynamics');
% rectangle('Position',[0.65,0.15,0.2,0.175])

% hold off



% Run the GUI

set(f,'Name','Data Analysis')       %GUI title
movegui(f,'center');                % Move the GUI to the center of the screen
set(f,'Visible','on');              % Make the GUI visible
waitfor(f);                         % Exit if Gui is closed

% if(~go)
%     error('GUI exited without pressing Start');
% end

%  Callbacks for simple_gui. These callbacks automatically
%  have access to component handles and initialized data
%  because they are nested at a lower level.

    function set_experiment
        
        exp_inds    = strcmp(res.trials.exp_name,exp_name);
        
        subjs       = unique(res.trials.subj(exp_inds));
        subjs{end+1} = 'All';
        
        conds       = unique(res.trials.condition(exp_inds));
        dyns        = unique(res.trials.dynamics(exp_inds));
        dirs        = unique(res.trials.direction(exp_inds));
        
        dispArcmin = unique(res.trials.dispArcmin(exp_inds));
        stimRadDeg = unique(res.trials.stimRadDeg(exp_inds & ~strcmp(res.trials.condition,'SingleDot')));
        dotSizeDeg = unique(res.trials.dotSizeDeg(exp_inds));
        dotDensity = unique(res.trials.dotDensity(exp_inds));
        preludeSec = unique(res.trials.preludeSec(exp_inds));
        cycleSec = unique(res.trials.cycleSec(exp_inds));
        
        subj = subjs(end);
        cond = conds;
        dir = dirs;
        dyn = dyns;
        
    end

    function exp_Callback(source,eventdata)
        
        str = get(source, 'String');
        val = get(source,'Value');
        %dat             = eval(str{val});
        %dat.subj        = subj;
        exp_name    = str{val};
        set_experiment;
        %scr				= dspl(find(strcmp({dspl(:).name},dat.display)));
        
        %         %set(sbox,'String',subj);
        %         %set(dpopup,'Value',find(strcmp({dspl(:).name},dat.display)));
        %         set(rradio,'Value',dat.recording);
        %         set(fradio,'Value',dat.training);
        %
        %         set(d1box,'String',num2str(dat.dispArcmin));
        %         set(d2box,'String',num2str(dat.stimRadDeg));
        %         set(d3box,'String',num2str(dat.dotSizeDeg));
        %         set(d4box,'String',num2str(dat.dotDensity));
        %
        %         set(d5box,'String',num2str(dat.preludeSec));
        %         set(d6box,'String',num2str(dat.cycleSec));
        %         set(d7box,'String',num2str(dat.cond_repeats));
        %
        for x = 1:length(cradio)
            set(cradio(x),'Value',ismember(get(cradio(x),'String'),conds));
        end
        
        for y = 1:length(dradio)
            set(dradio(y),'Value',ismember(get(dradio(y),'String'),dyns));
        end
        
        for z = 1:length(tradio)
            set(tradio(z),'Value',ismember(get(tradio(z),'String'),dirs));
        end
        
        
    end


    function subj_Callback(source,eventdata)
        
        str = get(source, 'String');
        subj = str;
    end


    function feedback_Callback(source,eventdata)
        
        val = get(source,'Value');
        dat.training = val;
        
    end


    function plotit_Callback(source,eventdata)
        
        %go = 1;
        %dat.subj = subj;
        %close all;
        
        plot_results(subj,cond,dir,dyn,exp_name,res)
    end

    function load_Callback(source,eventdata)
        
        %go = 1;
        %dat.subj = subj;
        %close all;
        
        res = load_data(1);
        
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


    function disp_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.dispArcmin = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end


    function radius_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.stimRadDeg = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end

    function size_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.dotSizeDeg = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end

    function density_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.dotDensity = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end

    function prelude_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.preludeSec = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end

    function cycle_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.cycleSec = str2num(str);
        
        set(warn_me,'String','WARNING: Settings changed','BackgroundColor',ColorIt(1));
    end

    function repeat_Callback(source,eventdata)
        
        str = get(source, 'String');
        dat.cond_repeats = str2num(str);
        
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

end