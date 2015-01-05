function [subj_trial_inds, subj_session_inds] = get_subject_indices(subjs,s,res)
%
% get data indices (use all indices if 'All' subject selected)


if strcmp(subjs(s),'All')
    subj_trial_inds = ones(1,length(res.trials.subj));
    subj_session_inds = ones(1,length(res.subj));
else
    subj_trial_inds = strcmp(res.trials.subj,subjs{s});
    subj_session_inds = strcmp(res.subj,subjs{s});
end