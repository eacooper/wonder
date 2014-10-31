function dat = handle_varargin(args)
%
% handle variable input for IOVD experiment. Either take all args or prompt
% for them if empty

% initialize expected data fields
dat     = struct('subj',[],'display',[],'recording',[],'training',[]);
fields  = fieldnames(dat);

% fill in all supplied fields
for k = 1:2:length(args)                            % was it an argument?    
        dat.(args{k}) = args{k+1};       
end

% prompt for expected fields that were emptry
for f = 1:length(fields)                                % for each field
    
    if isempty(dat.(fields{f}))                         % if empty, prompt for it
        [prompt,truestr] = get_field_prompt(fields{f});
        if truestr
            dat.(fields{f}) = input(prompt,'s');
        else
            dat.(fields{f}) = input(prompt);
        end
    end
    
    if isempty(dat.(fields{f}))
        dat = fillin_defaults(dat,fields{f});           % if still empty, fill with default
    end
    
    dat = check_field_validity(dat,fields{f});          % make sure field values are valid
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [prompt,truestr] = get_field_prompt(field)
%
% grab text prompt and options for this field

switch field
    
    case 'subj'
        prompt = 'Enter subject first and last initials:   ';
        truestr = 1;
    case 'display'
        prompt = ['Enter display type\n (1) planar\n (2) LG3D\n (3) LG3D-LR\n (4) laptop\n '];
        truestr = 0;
    case 'recording'
        prompt = 'Are you recording with Eyelink? (1 yes, 0 no):   ';
        truestr = 0;
    case 'training'
        prompt = 'Are you using training auditory feedback (1 yes, 0 no):   ';
        truestr = 0;
    otherwise
        prompt = ['Please fill input field *** ' field ' ***:   '];
        truestr = 1;
        
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dat = check_field_validity(dat,field)
%
% make sure the input to each field is a valid value

switch field
    
    case 'subj'
        
%         if ~isempty(str2num(dat.subj))
%             error('Subject initials need to be a string');
%         end
        
    case 'display'
        
        display_list = {'planar','LG3D','LG3DLR','LG3DRB','laptop'};
        
        if ~isstr(dat.display)
            display_num = dat.display;
            dat.display = cell2mat(display_list(display_num));
        end

        if sum(ismember(display_list,dat.display)) ~= 1
            error(['Invalid display type: ' dat.display]);
        end
        
    case 'recording'
        
        if ~dat.recording == 1 && ~dat.recording == 0
            error('Recording flag should be 0 or 1');
        end
        
    case 'training'
        
        if ~dat.training == 1 && ~dat.training == 0
            error('Training flag should be 0 or 1');
        end
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dat = fillin_defaults(dat,field)
%
% fill empty fields with default values

switch field
    
    case 'subj'
        dat.subj = 'junk';
        display(['********************************************Subject initials defaulting to ' dat.subj]);
    case 'display'
        dat.display = 'laptop';
        display(['********************************************Display defaulting to ' dat.display]);
    case 'recording'
        dat.recording = 0;
        display('********************************************Recording defaulting to false');
    case 'training'
        dat.training = 1;
        display('********************************************Training defaulting to true');
        
end

