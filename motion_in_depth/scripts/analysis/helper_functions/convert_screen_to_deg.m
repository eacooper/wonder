function deg = convert_screen_to_deg(pos,el,ipd)

if numel(ipd) > 1 
    
    ipd = repmat(ipd',1,size(pos,1));
    
end

deg = atand(((ipd/2) + pos)./el.href_dist);