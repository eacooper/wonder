function Eall  = add_line_to_ET_data_struct(Eall,trialCnt,lineCnt,Line,href2cm,href_dist,ipd)

% flip U/D HREF coords to get into proper coordinate system (pos/neg: up/down, right/left)
Eall.rawData{trialCnt}(lineCnt,:)   = Line;
Eall.LEx(lineCnt,trialCnt)          = Line(2).*href2cm;
Eall.LEy(lineCnt,trialCnt)          = -Line(3).*href2cm;
Eall.REx(lineCnt,trialCnt)          = Line(5).*href2cm;
Eall.REy(lineCnt,trialCnt)          = -Line(6).*href2cm;

Eall.LExAng(lineCnt,trialCnt)       = convert_screen_to_deg(ipd,href_dist,Eall.LEx(lineCnt,trialCnt));
Eall.LEyAng(lineCnt,trialCnt)       = convert_screen_to_deg(ipd,href_dist,Eall.LEy(lineCnt,trialCnt));
Eall.RExAng(lineCnt,trialCnt)       = convert_screen_to_deg(-ipd,href_dist,Eall.REx(lineCnt,trialCnt));
Eall.REyAng(lineCnt,trialCnt)       = convert_screen_to_deg(ipd,href_dist,Eall.REy(lineCnt,trialCnt));

Eall.vergenceH(lineCnt,trialCnt)    = Eall.LExAng(lineCnt,trialCnt) - Eall.RExAng(lineCnt,trialCnt);
Eall.vergenceV(lineCnt,trialCnt)    = Eall.LEyAng(lineCnt,trialCnt) - Eall.REyAng(lineCnt,trialCnt);

Eall.versionH(lineCnt,trialCnt)     = mean([Eall.LExAng(lineCnt,trialCnt) Eall.RExAng(lineCnt,trialCnt)]);
Eall.versionV(lineCnt,trialCnt)     = mean([Eall.LEyAng(lineCnt,trialCnt) Eall.REyAng(lineCnt,trialCnt)]);

Eall.saccadeStart(lineCnt,trialCnt) = 0;