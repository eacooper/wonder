function res = combine_data_structures(res_new)
%
% combine processed sessions with existing processed data

load('../../data/all_data.mat');
res_old = res;
clear res;

fields = fieldnames(res_old);

for f = 1:length(fields)
       
    
    % trials combine subfields:
    if strcmp(fields{f},'trials')
        
        tr_fields = fieldnames(res_old.trials);
        
        for g = 1:length(tr_fields)
            
            res.trials.(tr_fields{g}) = [res_old.trials.(tr_fields{g}) res_new.trials.(tr_fields{g})];
            
        end
        
        
    % eyelink info just use for error checking
    elseif strcmp(fields{f},'el')
        
        if res_new.el.sampleRate ~= res_old.el.sampleRate || ...
                res_new.el.href_dist ~= res_old.el.href_dist || ...
                res_new.el.href2cm ~= res_old.el.href2cm
            
            error('eye tracker settings were changed, cannot combine data');
        else
            
            res.el = res_old.el;
            
        end
        
        
    % predictions fill in empty subfields
    elseif strcmp(fields{f},'predictions')
        
        pr_fields = fieldnames(res_old.predictions);
        
        for h = 1:length(pr_fields)
            
            for x = 1:length(res_new.predictions)
                
                if isfield(res_new.predictions(x),pr_fields{h})
                    
                    tmp.predictions(x).(pr_fields{h}) = [res_new.predictions(x).(pr_fields{h})];
                    
                else
                    
                    tmp.predictions(x).(pr_fields{h}) = [];
                    
                end
                
            end
 
        end
        
        res.predictions = [res_old.predictions tmp.predictions];
    
        
    % otherwise just combine fields    
    else
        
        res.(fields{f}) = [res_old.(fields{f}) res_new.(fields{f})];
        
    end
    
end

save('../../data/all_data.mat','res');