function res = get_data_file_names(rerun)
%
% either reprocess all data (rerun = 1) or a specfic sessions (rerun
% = 2)

if rerun == 1
    
    all_subjs     = dir_clean('../../data/stimulus/');
    
    cnt = 1;
    for s = 1:length(all_subjs)
        
        all_exps            = dir_clean(['../../data/stimulus/' all_subjs(s).name]);
        
        for x = 1:length(all_exps)
            
            all_files       = dir_clean(['../../data/stimulus/' all_subjs(s).name '/' all_exps(x).name]);
            
            for f = 1:length(all_files)
                
                res.fullpath{cnt} = ['../../data/stimulus/' ...
                    all_subjs(s).name '/' all_exps(x).name '/' all_files(f).name];
                cnt = cnt + 1;
                
            end
        end
    end
    
elseif rerun == 2
    
    [filename,pathname] = uigetfile('../../data/stimulus/','Select one or more sessions (must be same Subj & Exp)','multiselect','on');
    
    if iscellstr(filename);          % put filenames in cell structure
        filenames       = filename;       
    else
        filenames{1}    = filename; 
    end

    for f = 1:length(filenames)

        res.fullpath{f} = [pathname filenames{f}];
        
    end

end
