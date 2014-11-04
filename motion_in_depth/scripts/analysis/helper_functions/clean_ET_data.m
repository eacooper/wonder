function Eall = clean_ET_data(Eall,Sall)


if(0)
    hasSacc = Eall.foundSaccade > 0;
    Eall.LExAng(:,hasSacc) = NaN;
    Eall.RExAng(:,hasSacc) = NaN;
    Eall.vergenceH(:,hasSacc) = NaN;
    Eall.vergenceV(:,hasSacc) = NaN;
    Eall.versionH(:,hasSacc) = NaN;
    Eall.versionV(:,hasSacc) = NaN;
end

if(1)
    hasBlink = Eall.blinking > 0;
    Eall.LExAng(hasBlink) = NaN;
    Eall.RExAng(hasBlink) = NaN;
    Eall.vergenceH(hasBlink) = NaN;
    Eall.vergenceV(hasBlink) = NaN;
    Eall.versionH(hasBlink) = NaN;
    Eall.versionV(hasBlink) = NaN;
end

if(0)
    Eall.LExAng = nandetrend(Eall.LExAng);
    Eall.RExAng = nandetrend(Eall.RExAng);
    Eall.vergenceH = nandetrend(Eall.vergenceH);
    Eall.vergenceV = nandetrend(Eall.vergenceV);
    Eall.versionH = nandetrend(Eall.versionH);
    Eall.versionV = nandetrend(Eall.versionV);
end

if(0)
    Eall.LExAng = detrend(Eall.LExAng);
    Eall.RExAng = detrend(Eall.RExAng);
    Eall.vergenceH = detrend(Eall.vergenceH);
    Eall.vergenceV = detrend(Eall.vergenceV);
    Eall.versionH = detrend(Eall.versionH);
    Eall.versionV = detrend(Eall.versionV);
end



if(0)
    %h=fdesign.lowpass('N,F3dB',12,0.1);
    %d1 = design(h,'butter');
    
    Fc    = 0.1;
    N = 100;   % FIR filter order
    Hf = fdesign.lowpass('N,Fc',N,Fc);
    Hd1 = design(Hf,'window','window',@hamming,'SystemObject',true);
    
    %tmp = filtfilt(Hd1.Numerator,1,Eall.vergenceH);
    Eall.vergenceH = filtfilt(Hd1.Numerator,1,Eall.vergenceH);
    Eall.versionH = filtfilt(Hd1.Numerator,1,Eall.versionH);
    Eall.LExAng = filtfilt(Hd1.Numerator,1,Eall.LExAng);
    Eall.RExAng = filtfilt(Hd1.Numerator,1,Eall.RExAng);
    
    %y = filtfilt(d1.sosMatrix,d1.ScaleValues,Eall.vergenceH(:,2));
    %Eall.vergenceH = filtfilt(d1.sosMatrix,d1.ScaleValues,Eall.vergenceH);
    %Eall.versionH = filtfilt(d1.sosMatrix,d1.ScaleValues,Eall.versionH);
    %Eall.LExAng = filtfilt(d1.sosMatrix,d1.ScaleValues,Eall.LExAng);
    %Eall.RExAng = filtfilt(d1.sosMatrix,d1.ScaleValues,Eall.RExAng);
    
end

if(0)
    %fields with nans
    hasNans = sum(isnan(Eall.vergenceH),1) > 0;
    
    if hasNans > 0
        keyboard
    end
    
    Eall.LExAng(:,hasNans) = NaN;
    Eall.RExAng(:,hasNans) = NaN;
    Eall.vergenceH(:,hasNans) = NaN;
    Eall.vergenceV(:,hasNans) = NaN;
    Eall.versionH(:,hasNans) = NaN;
    Eall.versionV(:,hasNans) = NaN;
end


%baseline data

if(1)
prelude_samples = 1:Sall.preludeSec*Sall.sampleRate;


Eall.vergenceH = baseline_ET_data(Eall.vergenceH,Sall,prelude_samples);
Eall.versionH = baseline_ET_data(Eall.versionH,Sall,prelude_samples);
Eall.RExAng = baseline_ET_data(Eall.RExAng,Sall,prelude_samples);
Eall.REyAng = baseline_ET_data(Eall.REyAng,Sall,prelude_samples);
Eall.LExAng = baseline_ET_data(Eall.LExAng,Sall,prelude_samples);
Eall.LEyAng = baseline_ET_data(Eall.LEyAng,Sall,prelude_samples);
end

if(1)
    largeError = (sum(abs(Eall.LExAng) > 3,1) + sum(abs(Eall.RExAng) > 3,1)) > 0;
    Eall.LExAng(:,largeError) = NaN;
    Eall.RExAng(:,largeError) = NaN;
    Eall.vergenceH(:,largeError) = NaN;
    Eall.vergenceV(:,largeError) = NaN;
    Eall.versionH(:,largeError) = NaN;
    Eall.versionV(:,largeError) = NaN;
end

