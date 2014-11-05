function deg = convert_screen_to_deg(ipd,href_dist,pos)

deg = atand(((ipd/2) + pos)./href_dist);