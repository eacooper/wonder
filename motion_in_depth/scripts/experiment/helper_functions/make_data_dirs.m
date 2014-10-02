function dat = make_data_dirs(dat)

%make data dirs
dat.data_track_dir  = ['../../data/tracking/' dat.subj '/'];
dat.data_stim_dir   = ['../../data/stimulus/' dat.subj '/'];

if ~exist(dat.data_track_dir, 'dir')
    mkdir(dat.data_track_dir);
end

if ~exist(dat.data_stim_dir, 'dir')
    mkdir(dat.data_stim_dir);
end