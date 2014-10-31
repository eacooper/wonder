function dat = open_gui(settings)
%
% gui for loading and setting motion in depth experiment

% load in options
dspl = displays;

% load in experiment settings
if isempty(settings)
    dat     = default;
else
    %func    = str2func(settings{1});
    dat     = eval(settings{1});
end

%  Create and then hide the GUI as it is being constructed.
sz = [360,500,500,500];
marg = 30;
f = figure('Visible','off','Position',sz);


% subject initials
stext = uicontrol('Style','text','String','Subject',...
    'Position',[marg,sz(2) - marg,60,15]);
sbox = uicontrol('Style','edit',...
    'String',dat.subj,...
    'Position',[marg + 60,sz(2) - marg,200,25],...
    'Callback',{@subj_Callback});

align([stext,sbox],'None','Top');


% display options
dtext = uicontrol('Style','text','String','Display',...
    'Position',[marg,sz(2) - marg*2,60,15]);
dpopup = uicontrol('Style','popupmenu',...
    'String',{dspl(:).name},...
    'Position',[marg + 60,sz(2) - marg*2,200,25],...
    'Callback',{@display_Callback},...
    'Value',find(strcmp({dspl(:).name},dat.display)));


align([dtext,dpopup],'None','Top');


% recording options
rradio = uicontrol('Style', 'radiobutton', ...
    'String',   'record', ...
    'Callback', @recording_Callback, ...
    'Position',[marg + 60,sz(2) - marg*3,200,25],...
    'Value',    dat.recording);

% feedback options
fradio = uicontrol('Style', 'radiobutton', ...
    'String',   'provide feedback', ...
    'Callback', @feedback_Callback, ...
    'Position',[marg + 60,sz(2) - marg*4,200,25],...
    'Value',    dat.training);

%       updatebutton = uicontrol('Style','pushbutton','String','UPDATE',...
%           'Position',[screen_resize(3)/2 - 25,screen_resize(2) + buffer,50,50],...
%           'Callback',{@updatebutton_Callback});


% save as experiment
ztext = uicontrol('Style','text','String','Store parameters',...
    'Position',[marg,marg,60,15]);
zbox = uicontrol('Style','edit',...
    'String','New Name',...
    'Position',[marg + 60,marg,200,25],...
    'Callback',{@store_Callback});

align([ztext,zbox],'None','Top');


% Initialize the GUI.

% Assign the GUI a name to appear in the window title.
set(f,'Name','Motion in Depth Experiment Settings')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');

waitfor(f)

%  Callbacks for simple_gui. These callbacks automatically
%  have access to component handles and initialized data
%  because they are nested at a lower level.

%  Pop-up menu callback. Read the pop-up menu Value property
%  to determine which item is currently displayed and make it
%  the current data.
    function display_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        
        dat.display = str{val};
    end

    function subj_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        
        dat.subj = str;
    end

function recording_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        val = get(source,'Value');
        
        dat.recording = val;
end

function feedback_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        val = get(source,'Value');
        
        dat.training = val;
end


function store_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        %val = get(source,'Value');
        
        %dat.training = val;
    end








% Push button callbacks. Each callback plots current_data in
% the specified plot type.

    function surfbutton_Callback(source,eventdata)
        % Display surf plot of the currently selected data.
        surf(current_data);
    end

    function meshbutton_Callback(source,eventdata)
        % Display mesh plot of the currently selected data.
        mesh(current_data);
    end

    function contourbutton_Callback(source,eventdata)
        % Display contour plot of the currently selected data.
        contour(current_data);
    end

end