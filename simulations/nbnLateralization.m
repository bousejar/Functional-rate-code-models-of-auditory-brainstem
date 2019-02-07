function [allLatMso,freqList,allLatLso] = nbnLateralization(inPar,doIpd,doIld)
%% SIMULATION: lateralization of narrow band noises with IPD (MSO cent. stage) or ILD (LSO cent. stage)
%%  input:      inPar
%                   inPar.fs = 96e3;
%                   inPar.fLow =100;
%                   inPar.fHigh = 14000;
%                   inPar.baseF = 1000;
%                   inPar.erbBw = 0.5;
%                   inPar.optimize = 1;
%                   inPar.erbFc
%%              doIpd  - calculate the response to narrow band noises with IPD (MSO cent. stage)
%%              doIld  - calculate the response to narrow band noises with ILD (LSO cent. stage)
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

%% simulation parameters to be in accordance with subjective experiment
rampLen = 8e-3;
duration = 100e-3;
level = 50;
freqList = [350, 760];
ipdList = -150:30:180;
ildList = [-20,-18:3:18,20];
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

erbFc = repmat(erbFc',1,length(freqList));

[~,indLso] = min(abs(erbFc-freqList),[],1);
freqList = erbFc(indLso);

indMso = indLso;
% [~,indMso] = min(abs(erbFc-freqListMso),[],1);
% freqListMso = erbFc(indMso);


if doIpd
    if inPar.optimize
        allLatMso = zeros(floor(fs*duration),length(ipdList), length(freqList));
    else
        allLatMso = zeros(floor(fs*duration),length(erbFc),length(ipdList), length(freqList));
    end
    %% Progress bar render
    disp('Lateralization of NBN with IPD')
    parfor_progress(length(freqList)*length(ipdList));
    
    
    for ii=1:length(freqList)
        stimPar.SPL = HLtoDB(level,freqList(ii));
        % calculate band width of the noise
        erb = 24.7*(0.00437*freqList(ii)+1);
        stimPar.Fmin = freqList(ii)-erb;
        stimPar.Fmax = freqList(ii)+erb;
        %generate frozen noise (experimental)
        frozen = genBBN(stimPar);
        
        parfor jj=1:length(ipdList)
            % shiftPhase routine parameters (for IPD case)
            phaseShift = struct ;
            phaseShift.fs = inPar.fs;
            phaseShift.phaseShift = ipdList(jj);
            inL = frozen;
            inR = shift_phase(frozen,phaseShift);
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
                [bPer,aPer] = butter(3, w , 'low');
                inL = filter(bPer,aPer,inL);
                inR = filter(bPer,aPer,inR);
                inL = inL.*(inL>0);
                inR = inR.*(inR>0);
            elseif inPar.ihc ==3
                inL = ihcenvelope(inL, fs, 'ihc_bernstein');
                inR = ihcenvelope(inR, fs, 'ihc_bernstein');
            end
            
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
    % no normalization at the end of the BBN generation
    stimPar.noNorm = 1;
    
    if inPar.optimize
        allLatLso = zeros(floor(fs*duration),length(ildList), length(freqList));
    else
        allLatLso = zeros(floor(fs*duration),length(erbFc),length(ildList), length(freqList));
    end
    %% Progress bar render
    disp('Lateralization of NBN with ILD')
    parfor_progress(length(freqList)*length(ildList));
    for ii=1:length(freqList)
        stimPar.SPL = HLtoDB(level,freqList(ii));
        % calculate band width of the noise
        erb = 24.7*(0.00437*freqList(ii)+1);
        stimPar.Fmin = freqList(ii)-erb;
        stimPar.Fmax = freqList(ii)+erb;
        %generate frozen noise (experimental)
        frozen = genBBN(stimPar);
        parfor jj=1:length(ildList)
            inL = setdbspl(frozen, stimPar.SPL - ildList(jj)/2);
            inR = setdbspl(frozen, stimPar.SPL + ildList(jj)/2);
            %             %% edit for Bernstein
            %             [inL,fc] = auditoryfilterbank(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            %             [inR,fc] = auditoryfilterbank(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
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

% allLatMso = frozen;







