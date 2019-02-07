function [allLatMso,freqListMso,allLatLso,freqListLso] = pureToneLateralization(inPar,doIpd,doIld)
%% SIMULATION: lateralization of pure tones with IPD (MSO cent. stage) or ILD (LSO cent. stage)
%%  input:      inPar
%                   inPar.fs = 96e3;
%                   inPar.fLow =100;
%                   inPar.fHigh = 14000;
%                   inPar.baseF = 1000;
%                   inPar.erbBw = 0.5;
%                   inPar.optimize = 1;
%                   inPar.erbFc
%%              doIpd  - calculate the response to pure tones with IPD (MSO cent. stage)
%%              doIld  - calculate the response to pure tones with ILD (LSO cent. stage)
%%  Author:     Jaroslav Bouse, bousejar@gmail.com

% inPar.fs = 96e3;
% inPar.fLow =100;
% inPar.fHigh = 14000;
% inPar.baseF = 1000;
% inPar.erbBw = 0.5;
% inPar.optimize = 1;
%
% [x,inPar.erbFc] = lopezpoveda2001(zeros(10,1)', inPar.fs, 'flow', inPar.fLow, 'fhigh', inPar.fHigh, 'basef',inPar.baseF, 'bwmul', inPar.erbBw);
% doIpd = 0;
% doIld = 1;


%% simulation parameters  - according to Yost88
rampLen = 8e-3;
duration = 150e-3;
level = 50;
freqListMso = [0.2 0.5 0.75 1 1.5].*1e3;
ipdList = [-150:30:180]/180*pi;
freqListLso = [0.2 0.5 1 2 5].*1e3;
ildList = -18:3:18;
fs  = inPar.fs;

% feed the parameters to the simulation struct
stimPar = struct;
stimPar.fs = inPar.fs;
stimPar.SPL = level;
if inPar.ihc ==3
    stimPar.p0 = 2e-5;     %% reference for gammatone filterbank
else
    stimPar.p0 = 1e-5;     %% because of the DRNL filter bank
end
stimPar.prior_sil = 0;
stimPar.post_sil = 0;
stimPar.ramp_dur = rampLen;
stimPar.sig_dur = duration;


% DRNL parameters
fLow = inPar.fLow;
fHigh = inPar.fHigh;
baseF = inPar.baseF;
erbBw = inPar.erbBw;
erbFc = inPar.erbFc;







%change the testing frequency to the nearest central frequency of the ERB
%filter

erbFc = repmat(erbFc',1,length(freqListLso));

[~,indLso] = min(abs(erbFc-freqListLso),[],1);
freqListLso = erbFc(indLso);

[~,indMso] = min(abs(erbFc-freqListMso),[],1);
freqListMso = erbFc(indMso);

%% MSO lateralization first

if doIpd
    
    if inPar.optimize
        allLatMso = zeros(floor(fs*duration),length(ipdList), length(freqListMso));
    else
        allLatMso = zeros(floor(fs*duration),length(erbFc),length(ipdList), length(freqListMso));
    end
        %% Progress bar render
        disp('Lateralization of pure tones with IPD')
        parfor_progress(length(ipdList)*length(freqListMso));
        
    for ii=1:length(freqListMso)
        stimPar.fsig =freqListMso(ii);
        %% convert the level to the dbHL
        stimPar.SPL = HLtoDB(level,freqListMso(ii));
       
        parfor jj=1:length(ipdList)
            parforStimPar = stimPar;
            % generation of input pure tones
            parforStimPar.phase = 0;
            inL = genPureTone(parforStimPar);
            parforStimPar.phase = ipdList(jj);
            inR = genPureTone(parforStimPar);
           
            %outer&middle ear filtering + DRNL
            if inPar.ihc ==3
                [inL,fc] = auditoryfilterbank(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inR,fc] = auditoryfilterbank(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            else
                [inL,fc] = lopezpoveda2001(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inR,fc] = lopezpoveda2001(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            end
            if inPar.optimize        %% reduce the computional cost to compute on only one central frequency corresponding to the frequency of the pure tone
                inL = inL(:,indMso(ii));
                inR = inR(:,indMso(ii));
            end
            %ihc filtering
            if inPar.ihc == 1
                inL = ihcenvelope(inL, fs, 'ihc_breebaart');
                inR = ihcenvelope(inR, fs, 'ihc_breebaart');
            elseif inPar.ihc ==2
                w = (440) / (fs/2);
                [bPer,aPer] = butter(2, w , 'low');
                inL = filter(bPer,aPer,inL);
                inR = filter(bPer,aPer,inR);
                inL = inL.*(inL>0); 
                inR = inR.*(inR>0); 
            elseif inPar.ihc ==3
                inL = ihcenvelope(inL, fs, 'ihc_bernstein');
                inR = ihcenvelope(inR, fs, 'ihc_bernstein');
            end
          
            %MSO model
            if inPar.optimize
                allLatMso(:,jj,ii)= msoModel(inL,inR,fs,inPar.ihc);
            else
                latFetch(:,:,jj)= msoModel(inL,inR,fs,inPar.ihc);
            end
            parfor_progress();
        end
        if ~inPar.optimize
            allLatMso(:,:,:,ii) = latFetch;
        end
    end
    parfor_progress(0);
else
    allLatMso = NaN;
end



if doIld
    
    if inPar.optimize
        allLatLso = zeros(floor(fs*duration),length(ildList), length(freqListLso));
    else
        allLatLso = zeros(floor(fs*duration),length(erbFc),length(ildList), length(freqListLso));
    end
       %% Progress bar render
        disp('Lateralization of pure tones with ILD')
        parfor_progress(length(ildList)*length(freqListLso));
    
    for ii=1:length(freqListLso)
        stimPar.fsig =freqListLso(ii);
        %% convert the level to the dbHL
        stimPar.SPL = HLtoDB(level,freqListLso(ii));
        
        parfor jj=1:length(ildList)
            %             parforStimPar = stimPar;
            % generation of input pure tones
            inL = genPureTone(stimPar);
            inR = genPureTone(stimPar);
            if ildList(jj)<0
                inL = setdbspl(inL,50-ildList(jj));
                inR = setdbspl(inR,50);
            else
                inR = setdbspl(inR,50+ildList(jj));
                inL = setdbspl(inL,50);
            end
            %outer&middle ear filtering + DRNL
            if inPar.ihc ==3
                [inL,fc] = auditoryfilterbank(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inR,fc] = auditoryfilterbank(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            else
                [inL,fc] = lopezpoveda2001(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inR,fc] = lopezpoveda2001(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            end
            if inPar.optimize        %% reduce the computional cost to compute on only one central frequency corresponding to the frequency of the pure tone
                inL = inL(:,indLso(ii));
                inR = inR(:,indLso(ii));
            end
            %ihc filtering
            if inPar.ihc == 1
                inL = ihcenvelope(inL, fs, 'ihc_breebaart');
                inR = ihcenvelope(inR, fs, 'ihc_breebaart');
            elseif inPar.ihc ==2
                w = (440) / (fs/2);
                [bPer,aPer] = butter(3, w , 'low');
                inL = filter(bPer,aPer,inL);
                inR = filter(bPer,aPer,inR);
                inL = inL.*(inL>0);
                inR = inR.*(inR>0);
            elseif inPar.ihc ==3
                inL = ihcenvelope(inL, fs, 'ihc_bernstein');
                inR = ihcenvelope(inR, fs, 'ihc_bernstein');
            end         
            %LSO model
            if inPar.optimize
                allLatLso(:,jj,ii)= lsoModel(inL,inR,fs,inPar.ihc);
            else
                latFetch(:,:,jj)= lsoModel(inL,inR,fs,inPar.ihc);
            end
        parfor_progress();    
        end
        if ~inPar.optimize
            allLatLso(:,:,:,ii) = latFetch;
        end
    end
     parfor_progress(0);
else
    allLatLso = NaN;
end








