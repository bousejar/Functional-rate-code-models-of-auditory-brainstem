function [latLso, leftLso, rightLso]  = lsoModel(leftPer, rightPer,fs,ihcPar)
%% model of lateral superior olive + coresponding central stage
%%  input:      leftPer     signal from left ear periphery model
%%              rightPer    signal from right ear periphery model
%%              fs          sampling frequency
%%              ihcPar      parameter containing information about periphery model being in use
%%  Author:     Jaroslav Bouse, bousejar@gmail.com

[rows,cols] = size(leftPer);
if nargin<6
    range = 1:cols;
end


% compression of the input signal
if ihcPar ==3
    left = leftPer;
    right = rightPer;
else
     weight = 0.24;   
     left = leftPer.^weight;
     right = rightPer.^weight;
end


% temporal smoothing by first order IIR
tau = 0.1e-3*fs;   
b = 1-exp(-1/tau);
a = [1, -exp(-1/(tau))]; 

left = filter(b,a,left);
right = filter(b,a,right);

%add conduction delay to the inhibitory inputs
inDelay  = floor(200e-6*fs);

leftIn = [zeros(inDelay,cols); left(1:end-inDelay,:) ];
rightIn = [zeros(inDelay,cols); right(1:end-inDelay,:) ];

% Subtraction block
gainA= 100;

leftLso = tanh(gainA*(left - rightIn));
rightLso = tanh(gainA*(right-leftIn));


%Half wave rectification 
leftLso = leftLso.*(leftLso>0);
rightLso = rightLso.*(rightLso>0);

% Running average to smooth the output 
tauL = 6e-3;


leftLso = runningAv(leftLso,left, tauL, fs);
rightLso = runningAv(rightLso,right, tauL, fs);




% LSO central stage + adding gaussian noise
latLso = rightLso - leftLso;
if ihcPar ==3
    noiseGain = 0.0630;
else
    noiseGain= 0.0126;  %1.6*
end
latLso =latLso + noiseGain.*randn(rows,cols);






