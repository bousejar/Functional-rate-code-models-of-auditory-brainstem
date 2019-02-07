function [phaseWarpModThreshold,modFreq] = phaseWarpDiscriminationExp2(inPar,doMso,doLso)
%% SIMULATION: Discrimination of phase warp modulation depth (MSO cent. stage and LSO cent. stage )
%%  input:      inPar
%                   inPar.fs = 96e3;
%                   inPar.fLow =100;
%                   inPar.fHigh = 14000;
%                   inPar.baseF = 1000;
%                   inPar.erbBw = 0.5;
%                   inPar.optimize = 1;
%                   inPar.erbFc
%%              doMso  - calculate the discrimination of phase warp beat frequency using MSO model with cent. stage
%%              doLso  - calculate the discrimination of phase warp beat frequency using LSO model with cent. stage
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
rampLen = 20e-3;
duration = 1000e-3;
level = 65;
nHigh = 550;
modFreq  = [10, 50, 75,10, 50, 75];

fs  = inPar.fs;

% feed the parameters to the simulation struct
stimPar = struct;
stimPar.fs = inPar.fs;
stimPar.length = duration;
stimPar.ramp = rampLen;
stimPar.p0 = 1e-5;  %% because of the DRNL filter bank
stimPar.SPL = level;
stimPar.nLow = 10;  % possible case 1
stimPar.nHigh = nHigh;
stimPar.modulationF = 50;
stimPar.uncorelated = 1;
% additional parameters for NBN generator
stimPar.prior_sil = 0;
stimPar.post_sil =0;
stimPar.sig_dur = duration;
stimPar.ramp_dur = rampLen;
stimPar.Fmin = 10;
% stimPar.Fmax = nHigh;
stimPar.Fmax = fs/2;
% stimPar.noNorm = 0;

%starting modulation frequency and adjustment stepsize
startMod = 0;  %% modulation start
modStep = [4, 2, 1];



% nubmer of rehearsals
nRehearsals = 30;   




% DRNL parameters
fLow = inPar.fLow;
fHigh = inPar.fHigh;
baseF = inPar.baseF;
erbBw = inPar.erbBw;
erbFc = inPar.erbFc;

%change the testing frequency to the nearest central frequency of the ERB
%filter

erbFc = repmat(erbFc',1,length(nHigh));

[~,ind] = min(abs(erbFc-nHigh),[],1);   %??

if doMso && doLso
    iStart = 1;
    iStop = length(modFreq);
elseif doMso &&~doLso
    iStart= 1;
    iStop = 3;
elseif ~doMso &&doLso
    iStart=4;
    iStop = length(modFreq);
end
%% Progress bar render
disp('Phase warp experiment 2 ')
parfor_progress(length(iStart:iStop)*nRehearsals);

parfor ii=iStart:iStop
    %update pure tone parameters
    parforStimPar = stimPar;
    parforStimPar.modulationF = modFreq(ii);
    % starting parameters
    curMod = startMod;
    curModStep = modStep(1);
    curRehearsal = 1;
    detected = 0;
    decrease = 0;   % direction of the last step was towards lower threshold
    increase =0;  %  direction of the last step was towards higher threshold
    phaseWarpThresholdTemp = zeros(nRehearsals,1);
    while curRehearsal<=nRehearsals
        % stimulus A   - contains phase warp
        signalA = genPhaseWarp(parforStimPar);
        m = 1*10^(curMod/20);
        r = 1 / ( 1+ sqrt(1/m -1) );
        inAL = r*signalA(:,1) + (1-r)*genBBN(parforStimPar);
        inAR = r*signalA(:,2) + (1-r)*genBBN(parforStimPar);
        
        % stimulus B - binaurally uncorellated noise
        inBL = genBBN(parforStimPar);
        inBR = genBBN(parforStimPar);
        
        % stimulus C - binaurally uncorellated noise
        inCL = genBBN(parforStimPar);
        inCR = genBBN(parforStimPar);
        
        
        % set the level of the signals
        inAL = setdbspl(inAL,level);
        inAR = setdbspl(inAR,level);
        
        inBL = setdbspl(inBL,level);
        inBR = setdbspl(inBR,level);
        
        inCL = setdbspl(inCL,level);
        inCR = setdbspl(inCR,level);
        
        %outer&middle ear filtering + DRNL
        if inPar.ihc ==3
            [inAL,fc] = auditoryfilterbank(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            [inAR,fc] = auditoryfilterbank(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            
            [inBL,fc] = auditoryfilterbank(inBL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            [inBR,fc] = auditoryfilterbank(inBR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            
            [inCL,fc] = auditoryfilterbank(inCL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            [inCR,fc] = auditoryfilterbank(inCR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
        else
            [inAL,fc] = lopezpoveda2001(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            [inAR,fc] = lopezpoveda2001(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            
            [inBL,fc] = lopezpoveda2001(inBL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            [inBR,fc] = lopezpoveda2001(inBR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            
            [inCL,fc] = lopezpoveda2001(inCL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            [inCR,fc] = lopezpoveda2001(inCR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
        end
        
        % do the calculations only in passband frequencies of phase warp
        inAL = inAL(:,1:ind);
        inAR = inAR(:,1:ind);
        
        inBL = inBL(:,1:ind);
        inBR = inBR(:,1:ind);
        
        inCL = inCL(:,1:ind);
        inCR = inCR(:,1:ind);
        
        
        %ihc filtering
        if inPar.ihc == 1
            inAL = ihcenvelope(inAL, fs, 'ihc_breebaart');
            inAR = ihcenvelope(inAR, fs, 'ihc_breebaart');
            
            inBL = ihcenvelope(inBL, fs, 'ihc_breebaart');
            inBR = ihcenvelope(inBR, fs, 'ihc_breebaart');
            
            inCL = ihcenvelope(inCL, fs, 'ihc_breebaart');
            inCR = ihcenvelope(inCR, fs, 'ihc_breebaart');
        elseif inPar.ihc ==2
            w = (440) / (fs/2);
            [bPer,aPer] = butter(3, w , 'low');
            
            inAL = filter(bPer,aPer,inAL);
            inAR = filter(bPer,aPer,inAR);
            inAL = inAL.*(inAL>0);
            inAR = inAR.*(inAR>0);
            
            inBL = filter(bPer,aPer,inBL);
            inBR = filter(bPer,aPer,inBR);
            inBL = inBL.*(inBL>0);
            inBR = inBR.*(inBR>0);
            
            inCL = filter(bPer,aPer,inCL);
            inCR = filter(bPer,aPer,inCR);
            inCL = inCL.*(inCL>0);
            inCR = inCR.*(inCR>0);
        elseif inPar.ihc ==3
            inAL = ihcenvelope(inAL, fs, 'ihc_bernstein');
            inAR = ihcenvelope(inAR, fs, 'ihc_bernstein');
            
            inBL = ihcenvelope(inBL, fs, 'ihc_bernstein');
            inBR = ihcenvelope(inBR, fs, 'ihc_bernstein');
            
            inCL = ihcenvelope(inCL, fs, 'ihc_bernstein');
            inCR = ihcenvelope(inCR, fs, 'ihc_bernstein');
        end
        
        
        %             rms(inAL(:))
        
        %             rms(inBL(:))
        
        if ii<=3
            %                 if ~doItd
            %                     phaseWarpThreshold(ii) = NaN;
            %                     %return;
            %                 end
            % MSO model
            stimA = msoModel(inAL,inAR,fs,inPar.ihc);
            
            stimB = msoModel(inBL,inBR,fs,inPar.ihc);
            
            stimC = msoModel(inCL,inCR,fs,inPar.ihc);  % tady chyba
        else
            %                 if ~doIld
            %                     phaseWarpThreshold(ii) = NaN;
            %                   %  return;
            %                 end
            % LSO model
            stimA = lsoModel(inAL,inAR,fs,inPar.ihc);
            
            stimB = lsoModel(inBL,inBR,fs,inPar.ihc);
            
            stimC = lsoModel(inCL,inCR,fs,inPar.ihc);
        end
        
        
            stimA = abs(fft(stimA(1e3:end,:),fs));
 
            stimB = abs(fft(stimB(1e3:end,:),fs));
            
            stimC = abs(fft(stimC(1e3:end,:),fs));
        %             modFreq(ii)
        
        %             f = round(modFreq(ii)/(fs/length(stimA)))+1
        
        f= modFreq(ii)+1;   
        
        
        stimA = median(stimA(f,:));
        
        stimB = median(stimB(f,:));
        
        stimC = median(stimC(f,:));
        
        
        % adjust the stepsize
        if curRehearsal>2 && curRehearsal<4
            curModStep = modStep(2);
        elseif curRehearsal>4
            curModStep = modStep(3);
        end
        
        if stimA>stimB && stimA>stimC
            detected = detected +1;
            if detected == 2
                increase = 1;
                % detect whether there was change of step direction
                if decrease&&increase
                    phaseWarpThresholdTemp(curRehearsal) = curMod;
                    curRehearsal = curRehearsal + 1;
                    parfor_progress();
                end
                % increase the phasewarp frequency
                curMod = curMod - curModStep;
                % clear the variables
                detected = 0;
                decrease = 0;
            end
        else
            decrease = 1;
            % detect whether there was change of step direction
            if decrease&&increase
                phaseWarpThresholdTemp(curRehearsal) = curMod;
                curRehearsal = curRehearsal + 1;
                parfor_progress();
            end
            %
            curMod = curMod + curModStep;
            % clear the variables
            increase = 0;
            detected = 0;
        end
%         disp(['Current rehearsal: ', num2str(curMod)])
    end
    phaseWarpModThreshold(:,ii) = phaseWarpThresholdTemp;
end
parfor_progress(0)
end





