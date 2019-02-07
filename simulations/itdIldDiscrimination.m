function [itdThreshold,freqListMso,ildThreshold, freqListLso] = itdIldDiscrimination(inPar,doItd,doIld)
%% SIMULATION: ITD (MSO) and ILD (LSO) discrimination threshold for pure tones
%%  input:      inPar
%                   inPar.fs = 96e3;
%                   inPar.fLow =100;
%                   inPar.fHigh = 14000;
%                   inPar.baseF = 1000;
%                   inPar.erbBw = 0.5;
%                   inPar.optimize = 1;
%                   inPar.erbFc
%%              doItd  - calculate threshold for ITD (MSO)
%%              doILD  - calculate threshold for ILD (LSO)
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
rampLen = 100e-3;
duration = 500e-3;
levelMso = 70;
levelLso = 60;
freqListMso = [0.25, 0.7, 0.8, 0.9, 1, 1.2, 1.25, 1.3, 1.35,1.460].*1e3;
% freqListMso = [0.25, 0.7, 0.8, 0.9].*1e3;

freqListLso = [0.2 0.5 1 2 5].*1e3;
fs  = inPar.fs;

% feed the parameters to the simulation struct
stimPar = struct;
stimPar.fs = inPar.fs;
stimPar.SPL = levelMso;
if inPar.ihc ==3
    stimPar.p0 = 2e-5;     %% reference for gammatone filterbank
else
    stimPar.p0 = 1e-5;     %% because of the DRNL filter bank
end
stimPar.prior_sil = 0;
stimPar.post_sil = 0;
stimPar.ramp_dur = rampLen;
stimPar.sig_dur = duration;






%% itd procedure

% starting itd and step size in the up-down procedure
startItd = 100e-6;
itdStep  = [17, 5, 2]*1e-6;
dThresMso = 1.14;

% nubmer of rehearsals
nRehearsals = 14;

%% ild procedure
% starting itd and step size in the up-down procedure
startIld = 1.5;
% ildStep  = [0.25, 0.05];
ildStep  = [0.25, 0.1,  0.05];

dThresLso = 0.95;





% DRNL parameters
fLow = inPar.fLow;
fHigh = inPar.fHigh;
baseF = inPar.baseF;
erbBw = inPar.erbBw;
erbFc = inPar.erbFc;


%change the testing frequency to the nearest central frequency of the ERB
%filter
erbFcMso = repmat(erbFc',1,length(freqListMso));

[~,indMso] = min(abs(erbFcMso-freqListMso),[],1);
freqListMso = erbFcMso(indMso);

erbFcLso = repmat(erbFc',1,length(freqListLso));

[~,indLso] = min(abs(erbFcLso-freqListLso),[],1);
freqListLso = erbFcMso(indLso);



if doItd
        %% Progress bar render
        disp('ITD discrimination')
        parfor_progress(length(freqListMso)*nRehearsals);
    parfor ii=1:length(freqListMso)
        %update pure tone parameters
        parforStimPar = stimPar;
        parforStimPar.fsig = freqListMso(ii);
        % starting parameters
        curItd = startItd;
        curItdStep = itdStep(1);
        curRehearsal = 1;
        detected = 0;
        decrease = 0;   % direction of the last step was towards lower threshold
        increase =0;  %  direction of the last step was towards higher threshold
        itdThresholdCur = [];
        
        while curRehearsal<=nRehearsals
            % stimulus A
            parforStimPar.phase = curItd/2 * parforStimPar.fsig *2*pi;
            inAL =  genPureTone(parforStimPar) ;
            parforStimPar.phase = 0;
            inAR = genPureTone(parforStimPar);
            
            % stimulus B
            inBL = genPureTone(parforStimPar);
            parforStimPar.phase = curItd/2 * parforStimPar.fsig *2*pi;
            inBR = genPureTone(parforStimPar);
            
            % set the level of the signals
            inAL = setdbspl(inAL,levelMso);
            inAR = setdbspl(inAR,levelMso);
            
            inBL = setdbspl(inBL,levelMso);
            inBR = setdbspl(inBR,levelMso);
            
            %outer&middle ear filtering + DRNL
            if inPar.ihc ==3
                [inAL,fc] = auditoryfilterbank(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inAR,fc] = auditoryfilterbank(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                
                [inBL,fc] = auditoryfilterbank(inBL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inBR,fc] = auditoryfilterbank(inBR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            else
                [inAL,fc] = lopezpoveda2001(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inAR,fc] = lopezpoveda2001(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                
                [inBL,fc] = lopezpoveda2001(inBL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inBR,fc] = lopezpoveda2001(inBR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            end
            % calculate lateralization only for the frequency band where lies the pure tone
            inAL = inAL(:,indMso(ii));
            inAR = inAR(:,indMso(ii));
            
            inBL = inBL(:,indMso(ii));
            inBR = inBR(:,indMso(ii));
            %ihc filtering
            if inPar.ihc == 1
                inAL = ihcenvelope(inAL, fs, 'ihc_breebaart');
                inAR = ihcenvelope(inAR, fs, 'ihc_breebaart');
                
                inBL = ihcenvelope(inBL, fs, 'ihc_breebaart');
                inBR = ihcenvelope(inBR, fs, 'ihc_breebaart');
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
            elseif inPar.ihc ==3
                inAL = ihcenvelope(inAL, fs, 'ihc_bernstein');
                inAR = ihcenvelope(inAR, fs, 'ihc_bernstein');
                
                inBL = ihcenvelope(inBL, fs, 'ihc_bernstein');
                inBR = ihcenvelope(inBR, fs, 'ihc_bernstein');
            end
            
            
            % MSO model
            stimA = msoModel(inAL,inAR,fs,inPar.ihc);
            
            stimB = msoModel(inBL,inBR,fs,inPar.ihc);
            
            % reduce length of the stimuli to the desired one
            stimA = stimA(1e3:end,:);
            stimB = stimB(1e3:end,:);
            
            % calculate d
            d = calcD(stimA,stimB);
            
            % adjust the stepsize
            if curRehearsal>4 && curItd>11e-6
                curItdStep = itdStep(2)
            elseif curRehearsal>4 && curItd<11e-6
                curItdStep = itdStep(3);
            end
            
            if d>=dThresMso && (mean(stimA)<mean(stimB) )
                detected = detected +1;
                if detected == 1
                    decrease = 1;
                    % detect whether there was change of step direction
                    if decrease&&increase
                        itdThresholdCur(curRehearsal) = curItd;
                        curRehearsal = curRehearsal + 1;
                        parfor_progress();
                    end
                    % decrease the itd
                    curItd = curItd - curItdStep;
                    % clear the variables
                    detected = 0;
                    increase = 0;
                end
            else
                increase = 1;
                % detect whether there was change of step direction
                if decrease&&increase
                    itdThresholdCur(curRehearsal) = curItd;
                    curRehearsal = curRehearsal + 1;
                    parfor_progress();
                end
                % increase the itd
                curItd = curItd + curItdStep;
                % clear the variables
                decrease = 0;
                detected = 0;
            end
            
%             disp(['Frequency: ', num2str(parforStimPar.fsig),' Current rehearsal: ', num2str(curRehearsal), 'Current ITD/IPD: ', num2str(curItd),'/',num2str(2*pi*parforStimPar.fsig*curItd) ])
            
            if curItd* parforStimPar.fsig *2*pi>=pi
                warning(['ITD at frequency ',num2str(parforStimPar.fsig),' Exceeded PI limit']);
                itdThresholdCur = 400e-6*ones(nRehearsals,1);
                curRehearsal = nRehearsals;
            end
        end
        itdThreshold(:,ii)  = itdThresholdCur;
    end
    parfor_progress(0);
else
    itdThreshold = NaN;
end



if doIld
            %% Progress bar render
        disp('ILD discrimination')
        parfor_progress(length(freqListLso)*nRehearsals);
    parfor ii=1:length(freqListLso)
        %update pure tone parameters
        parforStimPar = stimPar;
        parforStimPar.fsig = freqListLso(ii);
        % starting parameters
        curIld = startIld;
        curIldStep = ildStep(1);
        curRehearsal = 1;
        detected = 0;
        decrease = 0;   % direction of the last step was towards lower threshold
        increase =0;  %  direction of the last step was towards higher threshold
        ildThresholdCur = zeros(nRehearsals,1);
        while curRehearsal<=nRehearsals
            % stimulus A
            inAL =  genPureTone(parforStimPar) ;
            inAR = genPureTone(parforStimPar);
            
            % stimulus B
            inBL = genPureTone(parforStimPar);
            inBR = genPureTone(parforStimPar);
            
            % set the level of the signals
            inAL = setdbspl(inAL,levelLso+curIld/4);
            inAR = setdbspl(inAR,levelLso+curIld/4);
            
            inBL = setdbspl(inBL,levelLso-curIld/4);
            inBR = setdbspl(inBR,levelLso+curIld/4);
            
            %outer&middle ear filtering + DRNL
            if inPar.ihc ==3
                [inAL,fc] = auditoryfilterbank(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inAR,fc] = auditoryfilterbank(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                
                [inBL,fc] = auditoryfilterbank(inBL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inBR,fc] = auditoryfilterbank(inBR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            else
                [inAL,fc] = lopezpoveda2001(inAL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inAR,fc] = lopezpoveda2001(inAR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                
                [inBL,fc] = lopezpoveda2001(inBL, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
                [inBR,fc] = lopezpoveda2001(inBR, fs, 'flow', fLow, 'fhigh', fHigh, 'basef',baseF, 'bwmul', erbBw);
            end
            
            % calculate lateralization only for the frequency band where lies the pure tone
            inAL = inAL(:,indLso(ii));
            inAR = inAR(:,indLso(ii));
            
            inBL = inBL(:,indLso(ii));
            inBR = inBR(:,indLso(ii));
            %ihc filtering
            if inPar.ihc == 1
                inAL = ihcenvelope(inAL, fs, 'ihc_breebaart');
                inAR = ihcenvelope(inAR, fs, 'ihc_breebaart');
                
                inBL = ihcenvelope(inBL, fs, 'ihc_breebaart');
                inBR = ihcenvelope(inBR, fs, 'ihc_breebaart');
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
            elseif inPar.ihc ==3
                inAL = ihcenvelope(inAL, fs, 'ihc_bernstein');
                inAR = ihcenvelope(inAR, fs, 'ihc_bernstein');
                
                inBL = ihcenvelope(inBL, fs, 'ihc_bernstein');
                inBR = ihcenvelope(inBR, fs, 'ihc_bernstein');
            end
            % LSO model
            stimA = lsoModel(inAL,inAR,fs,inPar.ihc);
            
            stimB = lsoModel(inBL,inBR,fs,inPar.ihc);
            
            
            % calculate d
            d = calcD(stimA,stimB);
            
%             % adjust the stepsize
%             if curIld<0.4
%                 curIldStep = ildStep(2)
%             end
            
                        % adjust the stepsize
            if curRehearsal>=2
                curIldStep = ildStep(2);
            elseif curRehearsal>=4
                curIldStep =ildStep(3);
            end

            
            if d>=dThresLso && (mean(stimA)<mean(stimB) )
                detected = detected +1;
                if detected == 2
                    decrease = 1;
                    % detect whether there was change of step direction
                    if decrease&&increase
                        ildThresholdCur(curRehearsal) = curIld;
                        curRehearsal = curRehearsal + 1;
%                         pause(0.01*randi(150))
                        parfor_progress();
                    end
                    % decrease the ild
                    curIld = curIld - curIldStep;
                    % clear the variables
                    detected = 0;
                    increase = 0;
                end
            else
                increase = 1;
                % detect whether there was change of step direction
                if decrease&&increase
                    ildThresholdCur(curRehearsal) = curIld;
                    curRehearsal = curRehearsal + 1;
%                     pause(0.01*randi(150))
                    parfor_progress();
                end
                % increase the ild
                curIld = curIld + curIldStep;
                % clear the variables
                decrease = 0;
                detected = 0;
            end
%             disp(['Current rehearsal: ', num2str(curIld)])
        end
        ildThreshold(:,ii) = ildThresholdCur;
    end
    parfor_progress(0);
else
    ildThreshold = NaN;
end









