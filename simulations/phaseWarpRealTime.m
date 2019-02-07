function [phaseWarpTime] = phaseWarpRealTime(inPar)
%% SIMULATION: Transient output of the MSO  and LSO cent. stage to the phase warp stimulus with 8 Hz beat frequency
%%  input:      inPar
%                   inPar.fs = 96e3;
%                   inPar.fLow =100;
%                   inPar.fHigh = 14000;
%                   inPar.baseF = 1000;
%                   inPar.erbBw = 0.5;
%                   inPar.optimize = 1;
%                   inPar.erbFc
%%              doMso  - calculate the transient output to phase warp stimulus using MSO model with cent. stage
%%              doLso  - calculate the transient output to phase warp stimulus using LSO model with cent. stage
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
nHigh = [1100];

fs  = inPar.fs;

% feed the parameters to the simulation struct
stimPar = struct;
stimPar.fs = inPar.fs;
stimPar.length = duration;
stimPar.ramp = rampLen;
if inPar.ihc ==3
    stimPar.p0 = 2e-5;     %% reference for gammatone filterbank
else
    stimPar.p0 = 1e-5;     %% because of the DRNL filter bank
end
stimPar.SPL = level;
stimPar.nLow = 10; 
stimPar.nHigh = nHigh(1);
stimPar.modulationF = 8;
stimPar.uncorelated = 0;
% additional parameters for NBN generator
stimPar.prior_sil = 0;
stimPar.post_sil =0;
stimPar.sig_dur = duration;
stimPar.ramp_dur = rampLen;
stimPar.Fmin = 10;
stimPar.Fmax = nHigh(1);
stimPar.noNorm = 1;

%starting modulation frequency and adjustment stepsize
modF= 8;







% DRNL parameters
fLow = inPar.fLow;
fHigh = inPar.fHigh;
baseF = inPar.baseF;
erbBw = inPar.erbBw;
erbFc = inPar.erbFc;

%change the testing frequency to the nearest central frequency of the ERB
%filter

erbFc = repmat(erbFc',1,length(nHigh));

[~,ind] = min(abs(erbFc-nHigh),[],1);






%update pure tone parameters
parforStimPar = stimPar;
parforStimPar.nHigh = nHigh;
parforStimPar.Fmax = nHigh;
% starting parameters

% stimulus A   - contains phase warp
parforStimPar.modulationF = modF;
stimA = genPhaseWarp(parforStimPar);
inAL = stimA(:,1);
inAR = stimA(:,2);



% set the level of the signals
inAL = setdbspl(inAL,level);
inAR = setdbspl(inAR,level);


%outer&middle ear filtering + DRNL
if inPar.ihc ==3
    [inAL,fc] = auditoryfilterbank(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
    [inAR,fc] = auditoryfilterbank(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
else
    [inAL,fc] = lopezpoveda2001(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
    [inAR,fc] = lopezpoveda2001(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
    
end

% do the calculations only in passband frequencies of phase warp
inAL = inAL(:,1:ind(1));
inAR = inAR(:,1:ind(1));



%ihc filtering
if inPar.ihc == 1
    inAL = ihcenvelope(inAL, fs, 'ihc_breebaart');
    inAR = ihcenvelope(inAR, fs, 'ihc_breebaart');
    
elseif inPar.ihc ==2
    w = (440) / (fs/2);
    [bPer,aPer] = butter(3, w , 'low');
    
    inAL = filter(bPer,aPer,inAL);
    inAR = filter(bPer,aPer,inAR);
    inAL = inAL.*(inAL>0);
    inAR = inAR.*(inAR>0);
    
elseif inPar.ihc ==3
    inAL = ihcenvelope(inAL, fs, 'ihc_bernstein');
    inAR = ihcenvelope(inAR, fs, 'ihc_bernstein');
end




% MSO model
stimM = msoModel(inAL,inAR,fs,inPar.ihc);


% LSO model
stimL = lsoModel(inAL,inAR,fs,inPar.ihc);


phaseWarpTime(:,1) = stimM(:,round(20));
phaseWarpTime(:,2) = stimL(:,round(20));

% phaseWarpTime = stimL;


