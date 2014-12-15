function dat = eyelink_fake_calibration_info(dat)
%
% hack to enable loading of data pre-calibration rescaling:

if ~isfield(dat.display_info,'caliRadiusDeg');
    dat.display_info.caliRadiusDeg = 2;
    dat.display_info.caliRadiusPixX = 0;
    dat.display_info.caliRadiusPixY = 0;
end
if f > 1
    dat.display_info = orderfields(dat.display_info,res.display_info(1));
end