%% run all of the simulations as in the article
%   no additional parameters needed just select which simulations to run
%   Simulations correspond to the ones in the article:
%           Bouse, J.; Vencovský, V.; Rund, F.; Marsalek, P.
%           Functional Rate-Code Models of the Auditory Brainstem for Predicting Lateralization and Discrimination Data of Human Binaural Perception
%           J. Acoust. Soc. Am. 2019, 145(1), 1-15. 
%%  Author: Jaroslav Bouse, FEE, CTU in Prague
%%  Email: bousejar@gmail.com


% clear
close all

%% check whether the AMToolbox was added to the working path
if ~contains(path,'AMToolbox')
    startModel();
end


% parameters for the simulations DRNL and so on
inPar.fs = 96e3;
inPar.fLow =100;
inPar.fHigh = 14000;
inPar.baseF = 1000;
inPar.erbBw = 0.5;
inPar.optimize = 1;
inPar.erbFc = erbspacebw(inPar.fLow, inPar.fHigh, inPar.erbBw, inPar.baseF);

%% IHC fitlering setup  1 = DRNL filter-bank and 770 Hz low pass in IHC stage, 2 = DRNL with  440 low pass in IHC stage,  3 = Gammatone filter bank and IHC stage from Bernstein (1999)
inPar.ihc =1;  % default value 1 (used in the article Bouse et. al. (2019))




%% switches which simulations to run

% mso model response to IPD or ITD (Figure 3 in article)
msoSimulations.run =1;
msoSimulations.doIpd = 1;  %(Fig. 3 A)
msoSimulations.doItd = 1;  %(Fig. 3 B)

% pure tone lateralization (Figure 6 and Figure 7 in article)
pureToneSimulations.run =1;
pureToneSimulations.doIpd = 1;   %(Fig. 6)
pureToneSimulations.doIld = 1;   %(Fig. 7)

% narrow band noise lateralization (Figure 8 in article)
nbnSimulations.run = 1;
nbnSimulations.doIpd = 1;
nbnSimulations.doIld = 1;

% discrimination of ITD and ILD (Figure 9 in article)
discriminationSimulations.run = 1;
discriminationSimulations.doItd =1; %(Fig. 9 A)
discriminationSimulations.doIld = 1; %(Fig. 9 B)

% phase warp realtime show      (Figure 10 panel A in article)
phaseWarpSimTime.run = 1;

% discrimination of phase warp   (Table 1 in article)
phaseWarpSimulations.run =1;
phaseWarpSimulations.doMso = 1;
phaseWarpSimulations.doLso = 1;


% discrimination of phase warp exp 2 (Figure 10 panel B in article)
phaseWarpSimulations2.run = 1;
phaseWarpSimulations2.doMso = 1;
phaseWarpSimulations2.doLso = 1;


%% run simulations
doSimulations = 1;  % run simulations or us precalculated data

if doSimulations
    %%  Mso model simulations
    if msoSimulations.run
        tic
        % run lateralization of pure tone simulation
        [msoRespIpdPureTone, ipdList,msoRespItdNoise,itdList]=msoModelResponseToItdOrIpd(inPar,msoSimulations.doIpd, msoSimulations.doItd);
        msoSimTime = toc;
        disp(['mso simulation took: ',num2str(msoSimTime),' s'])
    end
    %%  Pure tone simulations
    if pureToneSimulations.run
        tic
        % run lateralization of pure tone simulation
        [latMsoPureTone,freqListMsoPureTone,latLsoPureTone,freqListLsoPureTone] = pureToneLateralization(inPar, pureToneSimulations.doIpd, pureToneSimulations.doIld);
        pureToneTime = toc;
        disp(['Pure tone simulation took: ',num2str(pureToneTime),' s'])
    end
    %% Narrow band noise simulations
    if nbnSimulations.run
        tic
        %% run lateralization of narrow band noises
        [latMsoNbn, freq, latLsoNbn] = nbnLateralization(inPar, nbnSimulations.doIpd, nbnSimulations.doIld);
        nbnTime = toc;
        disp(['NBN simulation took: ',num2str(nbnTime),' s'])
    end
    %% discrimination of ITD and ILD
    if discriminationSimulations.run
        tic
        [itdThreshold,freqListMso,ildThreshold, freqListLso] = itdIldDiscrimination(inPar,discriminationSimulations.doItd,discriminationSimulations.doIld);
        discriminationTime =toc;
        disp(['ITD/ILD discrimination simulation took: ',num2str(discriminationTime),' s'])
    end
    %% Phase warp realtime (8hz beat frequency) experiment
    phaseWarpTime=[];
    if phaseWarpSimTime.run
        tic
        [phaseWarpTime] = phaseWarpRealTime(inPar);
        phaseWarpRealTimet = toc;
        disp(['Phase warp real time simulation took: ', num2str(phaseWarpRealTimet)])
    end
    %% Phase warp experiment1
    if phaseWarpSimulations.run
        tic
        [phaseWarpThreshold,modFreq] = phaseWarpDiscriminationExp1(inPar,phaseWarpSimulations.doMso,phaseWarpSimulations.doLso);
        phaseWarpExp1Time = toc;
        disp(['Phase warp exp1 simulation took: ',num2str(phaseWarpExp1Time),' s'])
    end
    %% Phase warp experiment 2
    phaseWarpModThreshold = [];
    modFreq = [];
    if phaseWarpSimulations2.run
        tic
        [phaseWarpModThreshold,modFreq] = phaseWarpDiscriminationExp2(inPar,phaseWarpSimulations2.doMso,phaseWarpSimulations2.doLso);
        phaseWarpExp1Time = toc;
        disp(['Phase warp exp2 simulation took: ',num2str(phaseWarpExp1Time),' s'])
    end
    
    
else
    % loads the precalculated values from the article
    load('precomputedArticle.mat');
    
    
    
end


%% Plot the results


%% Plot  Mso model simulations
if msoSimulations.run
    plotMsoResponse(msoRespIpdPureTone, ipdList,msoRespItdNoise,itdList, msoSimulations.doIpd, msoSimulations.doItd)
    pause(0.1)
end
%% Plot Pure tone simulations
if pureToneSimulations.run
    % calculate mean of simulated data
    meanMsoPureTone = squeeze(mean(latMsoPureTone));
    meanLsoPureTone = squeeze(mean(latLsoPureTone));
    plotPureTone(meanMsoPureTone, freqListMsoPureTone, meanLsoPureTone, freqListLsoPureTone, pureToneSimulations.doIpd, pureToneSimulations.doIld);
    pause(0.1)
end

%% Plot Narrow band noise simulations
if nbnSimulations.run
    % calculate mean of simulated data
    meanMsoNbn = squeeze( mean(latMsoNbn));
    meanLsoNbn = squeeze( mean(latLsoNbn));
    plotNbn(meanMsoNbn, freq, meanLsoNbn, nbnSimulations.doIpd, nbnSimulations.doIld)
    pause(0.1)
end

%% Plot discrimination of ITD and ILD
if discriminationSimulations.run
    plotItdIldThreshold(itdThreshold(4:end,:),freqListMso,ildThreshold(4:end,:), freqListLso,discriminationSimulations.doItd,discriminationSimulations.doIld)
    pause(0.1)
end

%% Plot discrimination of phase warp exp1
if phaseWarpSimulations.run
    meanPhaseWarpThres = mean(phaseWarpThreshold(11:end,:));
    stdPhaseWarpThres = std(phaseWarpThreshold(11:end,:));
    phaseWarpBandwidth = {'550 Hz'; '1100 Hz'};
    subjectiveData_Dietz2008 = {'96+-15 Hz';'219+-30 Hz'};
    msoModelData = {[num2str(meanPhaseWarpThres(1)),'+-',num2str(stdPhaseWarpThres(1))]; [num2str(meanPhaseWarpThres(2)),'+-',num2str(stdPhaseWarpThres(2))]};
    lsoModelData = {[num2str(meanPhaseWarpThres(3)),'+-',num2str(stdPhaseWarpThres(3))]; [num2str(meanPhaseWarpThres(4)),'+-',num2str(stdPhaseWarpThres(4))]};
    phaseWarpThresholdTab = table(phaseWarpBandwidth,subjectiveData_Dietz2008,msoModelData,lsoModelData);
    figure('Name','Tab. 1 Phase-warp beat frequency threshold','NumberTitle', 'off')
    uitable('Data',phaseWarpThresholdTab{:,:},'ColumnName',phaseWarpThresholdTab.Properties.VariableNames,'RowName',phaseWarpThresholdTab.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
    
end

%% Plot discrimination of phase warp exp2 + transient response of the models to the phase warp
if phaseWarpSimulations2.run || phaseWarpSimTime.run
    plotMod.run = phaseWarpSimulations2.run;
    plotMod.doMso = phaseWarpSimulations2.doMso;
    plotMod.doLso = phaseWarpSimulations2.doLso;
    plotPhaseWarp( phaseWarpTime,inPar, phaseWarpModThreshold(11:end,:),modFreq,phaseWarpSimTime.run,plotMod)
    
end








