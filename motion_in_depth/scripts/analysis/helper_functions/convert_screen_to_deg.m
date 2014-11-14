function deg = convert_screen_to_deg(pos,el,ipd)

deg = atand(((ipd/2) + pos)./el.href_dist);