function [msoRespIpdPureTone, ipdList,msoRespItdNoise,itdList] = msoModelResponseToItdOrIpd(inPar,doIpd,doItd)
%% SIMULATION: Mean MSO response to the pure tones with IPD and response to broad band noises with ITD
%%  input:      inPar
%                   inPar.fs = 96e3;
%                   inPar.fLow =100;
%                   inPar.fHigh = 14000;
%                   inPar.baseF = 1000;
%                   inPar.erbBw = 0.5;
%                   inPar.optimize = 1;
%                   inPar.erbFc
%%              doIpd  - calculate the response to pure tones with IPD
%%              doItd  - calculate the response to broad-band noises with ITD
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
% doItd = 1;


msoRespIpdPureTone = [];
msoRespItdNoise = [];

%% simulation parameters  - according to Yost88
rampLen = 8e-3;
duration = 500e-3;
level = 60;

fs  = 96000;

% Pure tones parameters
stimPar = struct;
stimPar.fs = fs;
stimPar.SPL = level;
if inPar.ihc ==3
    stimPar.p0 = 2e-5;     %% reference for gammatone filterbank
else
    stimPar.p0 = 1e-5;     %% because of the DRNL filter bank
end
stimPar.fsig = 700;

stimPar.prior_sil = 0;
stimPar.post_sil = 0;
stimPar.ramp_dur = rampLen;
stimPar.sig_dur = duration;

%%  Broad band noise parameters
rampLen = 8e-3;
duration = 100e-3;
level = 50;
% fs  = inPar.fs;

% feed the parameters to the simulation struct
stimPar.fs = fs;
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
stimPar.Fmin = 1;
stimPar.Fmax = fs/2;


% DRNL parameters
fLow = inPar.fLow;
fHigh = inPar.fHigh;
baseF = inPar.baseF;
erbBw = inPar.erbBw;
erbFc = erbspacebw(inPar.fLow, inPar.fHigh, inPar.erbBw, inPar.baseF);


% itdList =-0.6e-3:0.01e-3:0.6e-3;
itdList =-1.5e-3:0.01e-3:1.5e-3;
fListItd = [250, 750];
ipdList = -180:5:180;
fListIpd = [300, 500, 800, 1300];


% do Pecka or mcalpine
doPecka = 0;
itdListPecka = [-5000:250:5000]*1e-6;
fPecka = 250;

if doItd
    if ~doPecka
        disp('MSO model response to broadband noise with ITD')
        parfor_progress(length(itdList)*length(fListItd));
        for ii = 1:length(fListItd)
            frozen = genBBN(stimPar);
            [~,indF] = min(abs(erbFc-fListItd(ii)));
            parfor jj=1:length(itdList)
                tempPar = stimPar;
                tempPar.phase = 0;
                inL = frozen;
                phaseShift = struct ;
                phaseShift.fs = fs;
                phaseShift.timeShift = itdList(jj);
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
                    inL = inL(:,indF);
                    inR = inR(:,indF);
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
                
                [~, leftMso, ~] = msoModel(inL,inR,fs,inPar.ihc);
                leftRespItd(jj) = mean(leftMso(200:end));
                %         rightResp(jj) = mean(rightMso);
                parfor_progress();
            end
            msoRespItdNoise(:,ii) = leftRespItd;
        end
        parfor_progress(0);
    else
        for ii = 1:length(fPecka)
            [~,indF] = min(abs(erbFc-fPecka(ii)));
            stimPar.fsig = erbFc(indF);
            parfor jj=1:length(itdListPecka)
                tempPar = stimPar;
                tempPar.phase = 0;
                inL = genPureTone(tempPar);
                tempPar.phase = 2*pi*stimPar.fsig*itdListPecka(jj);
                inR = genPureTone(tempPar);
                
                
                
                %outer&middle ear filtering + DRNL
                if inPar.ihc ==3
                    [inL,fc] = auditoryfilterbank(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                    [inR,fc] = auditoryfilterbank(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                else
                    [inL,fc] = lopezpoveda2001(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                    [inR,fc] = lopezpoveda2001(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                end
                if inPar.optimize        %% reduce the computional cost to compute on only one central frequency corresponding to the frequency of the pure tone
                    inL = inL(:,indF);
                    inR = inR(:,indF);
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
                
                [~, leftMso, ~] = msoModel(inL,inR,fs,inPar.ihc);
                leftRespItd(jj) = mean(leftMso(200:end));
                %         rightResp(jj) = mean(rightMso);
                
            end
            msoRespItdNoise(:,ii) = leftRespItd;
        end
        itdList = itdListPecka;
    end
    
end



if doIpd
    disp('MSO model response to pure tone with IPD')
    parfor_progress(length(ipdList)*length(fListIpd));
    for ii = 1:length(fListIpd)
        [~,indF] = min(abs(erbFc-fListIpd(ii)));
        stimPar.fsig = erbFc(indF);
        parfor jj=1:length(ipdList)
            tempPar = stimPar;
            tempPar.phase = 0;
            inL = genPureTone(tempPar);
            tempPar.phase = pi*(ipdList(jj))/180;
            inR = genPureTone(tempPar);
            
            
            
            %outer&middle ear filtering + DRNL
            if inPar.ihc ==3
                [inL,fc] = auditoryfilterbank(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inR,fc] = auditoryfilterbank(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            else
                [inL,fc] = lopezpoveda2001(inL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inR,fc] = lopezpoveda2001(inR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            end
            if inPar.optimize        %% reduce the computional cost to compute on only one central frequency corresponding to the frequency of the pure tone
                inL = inL(:,indF);
                inR = inR(:,indF);
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
            
            [~, leftMso, ~] = msoModel(inL,inR,fs,inPar.ihc);
            leftRespIpd(jj) = mean(leftMso(200:end));
            %         rightResp(jj) = mean(rightMso);
            
            parfor_progress();
        end
        msoRespIpdPureTone(:,ii) = leftRespIpd;
    end
    parfor_progress(0);
end




