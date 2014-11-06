function res = get_data_file_names
%
%

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
