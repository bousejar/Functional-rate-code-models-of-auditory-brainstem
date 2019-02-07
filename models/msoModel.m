function [latMso, leftMso, rightMso,exMultiple,right,leftEx]  = msoModel(leftPer, rightPer,fs, ihcPar)
%% model of medial superior olive + coresponding central stage
%%  input:      leftPer     signal from left ear periphery model
%%              rightPer    signal from right ear periphery model
%%              fs          sampling frequency
%%              ihcPar      parameter containing information about periphery model being in use
%%  Author:     Jaroslav Bouse, bousejar@gmail.com
if nargin<4
    ihcPar =1;
    warning('ihcPar in the MSO model not assigned!')
end

[rows,cols] = size(leftPer);

if ihcPar ==1
    % third order low pass filter to reduce model performance on high
    % frequencies
    w = (1100) / (fs/2);
    [b,a] = butter(3, w , 'low');
    left = filter (b,a, leftPer);
    right = filter (b,a, rightPer);
else
    left = leftPer;
    right = rightPer;
end







exDelay = floor(300e-6*fs);


leftEx = [zeros(exDelay,cols); left(1:end-exDelay,:) ];
rightEx = [zeros(exDelay,cols); right(1:end-exDelay,:)];


% calculation block
exMultiple = leftEx.*rightEx;

leftMso = exMultiple - right.*leftEx;
rightMso = exMultiple - left.*rightEx;

% half wave rectification
leftMso = leftMso.*(leftMso>0);
rightMso = rightMso.*(rightMso>0);

% zeroing the contralateral MSO if ipsilateral is zero (stability)
leftMso = leftMso.*(rightMso~=0);
rightMso = rightMso.*(leftMso~=0);

% calculation of mso envelope
tau = 2486.795985486e-6;

leftMso = runningAv(leftMso,leftMso,tau,fs) ;
rightMso = runningAv(rightMso,rightMso,tau,fs);


%% MSO central stage + adding Gaussian noise



rR = leftMso./rightMso;
rL = rightMso./leftMso;

leftLead = abs(rR)<abs(rL);
rightLead = ~leftLead;

latMso = (rR-1).*leftLead +(-rL+1).*rightLead;
latMso(isnan(latMso)) = 0;
latMso = latMso + 0.08*randn(rows,cols);













