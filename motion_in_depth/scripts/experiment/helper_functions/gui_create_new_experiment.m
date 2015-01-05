function gui_create_new_experiment(dat)

copyfile('./settings/template.m',['./settings/' dat.exp_name '.m'])
%dat.exp_name = dat.exp_name_new;


replaceinfile('template',dat.exp_name,['./settings/' dat.exp_name '.m']);

% general settings
replaceinfile('X_d',['''' dat.display ''''],['./settings/' dat.exp_name '.m']);
replaceinfile('X_r',num2str(dat.recording),['./settings/' dat.exp_name '.m']);
replaceinfile('X_t',num2str(dat.training),['./settings/' dat.exp_name '.m']);

% dot properties
replaceinfile('N_r',num2str(dat.stimRadDeg),['./settings/' dat.exp_name '.m']);
replaceinfile('N_d',num2str(dat.dispArcmin),['./settings/' dat.exp_name '.m']);
replaceinfile('N_m',num2str(dat.rampSpeedDegSec),['./settings/' dat.exp_name '.m']);
replaceinfile('N_s',num2str(dat.dotSizeDeg),['./settings/' dat.exp_name '.m']);
replaceinfile('N_n',num2str(dat.dotDensity),['./settings/' dat.exp_name '.m']);

% timing
replaceinfile('T_p',num2str(dat.preludeSec),['./settings/' dat.exp_name '.m']);
replaceinfile('T_c',num2str(dat.cycleSec),['./settings/' dat.exp_name '.m']);

% conditions
replaceinfile('C_r',num2str(dat.cond_repeats),['./settings/' dat.exp_name '.m']);

cond_str = '{';
for c = 1:length(dat.conditions)
    if c < length(dat.conditions)
        cond_str = [cond_str '''' dat.conditions{c} ''','];
    else
        cond_str = [cond_str '''' dat.conditions{c} '''}'];
    end
end

replaceinfile('C_l',cond_str,['./settings/' dat.exp_name '.m']);



dyn_str = '{';
for d = 1:length(dat.dynamics)
    if d < length(dat.dynamics)
        dyn_str = [dyn_str '''' dat.dynamics{d} ''','];
    else
        dyn_str = [dyn_str '''' dat.dynamics{d} '''}'];
    end
end

replaceinfile('C_t',dyn_str,['./settings/' dat.exp_name '.m']);


dir_str = '{';
for r = 1:length(dat.directions)
    if r < length(dat.directions)
        dir_str = [dir_str '''' dat.directions{r} ''','];
    else
        dir_str = [dir_str '''' dat.directions{r} '''}'];
    end
end

replaceinfile('C_d',dir_str,['./settings/' dat.exp_name '.m']);




