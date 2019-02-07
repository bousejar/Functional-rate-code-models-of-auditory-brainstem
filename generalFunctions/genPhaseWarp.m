function out = genPhaseWarp(par)
% par.length = 10000e-3;
% par.fs = 48e3;
% par.ramp = 8e-3;
% par.type = 'DP+';
% par.pitchF= 400;
% par.boundary = 10;
% par.SPL = 60;
% par.nLow= 100;
% par.nHigh = 550;
% par.modulationF = 4;



if ~isfield(par,'uncorelated')
    par.uncorelated = 0;
    
end;

fs = par.fs;
p0 = par.p0;
len = par.length*fs;
fstep = fs/len;

lNoise = floor(par.nLow/fstep);
hNoise = ceil(par.nHigh/fstep);
bandN = hNoise-lNoise + 1;

modulationF = round(par.modulationF/fstep);



% lBoun = floor((par.pitchF - par.boundary/2)/fstep);
% pitch =  floor(par.pitchF/fstep);
% hBoun = ceil((par.pitchF + par.boundary/2)/fstep);
% bandB = hBoun -lBoun;
%% generation of noise
if ~mod(len,2)
    N = len/2 + 1;
else
    N = (len+1)/2-1;
end;

%generation of magnitude spectra
mag =  zeros(N,1);

if ~par.uncorelated
    
    mag(lNoise:hNoise) = ones(bandN,1);
    mag = [mag; flipud(mag(2:N-1))];
    
    %generation of phase spectra
    leftPhs = zeros(N,1);
    rightPhs = zeros(N,1);
    leftPhs(lNoise:hNoise) = randn(bandN,1);
    
else
    mag = ones(N,1);
    mag = [mag; flipud(mag(2:N-1))];   
    
    %generation of phase spectra
    leftPhs = zeros(N,1);
    rightPhs = zeros(N,1);
    leftPhs = randn(N,1);   
    rightPhs = randn(N,1);
       
end




% size([ leftPhs(end-modulationF+1:end);      leftPhs(1:end-modulationF)])
%
%
% size(rightPhs(lNoise:hNoise))

rightPhs(lNoise:hNoise) = [leftPhs(hNoise-modulationF+1:hNoise) ;leftPhs(lNoise:hNoise-modulationF)];
% rightPhs = [ leftPhs(end-modulationF+1:end);      leftPhs(1:end-modulationF)];


% size(leftPhs)
% size(leftPhs(end-modulationF+1:end))
% size(leftPhs(1+modulationF:end-modulationF))

% size(rightPhs)
% modulationF

leftPhs = [leftPhs; flipud(-1*leftPhs(2:N-1)) ];
rightPhs = [rightPhs; flipud(-1*rightPhs(2:N-1)) ];

% size(mag)
% size(rightPhs)

leftSpec = mag.*exp(j*leftPhs);
rightSpec = mag.*exp(j*rightPhs);

out(:,1) = real(ifft(leftSpec));
out(:,2) = real(ifft(rightSpec));

% ramping and level settings
rampDur = par.ramp;
x = [0:1/fs:rampDur-1/fs]';
x = pi*x/rampDur;
rampUp = 0.5*(1 - cos(x));
rampDown = flipud(rampUp);
whole_ramp = [rampUp; ones(length(out(:,1))-2*length(x),1); rampDown];
out(:,1) = whole_ramp.*out(:,1);
out(:,2) = whole_ramp.*out(:,2);


p1 = p0*10^(par.SPL/20);
out(:,1) = out(:,1)/rms(out(:,1))*p1;
out(:,2) = out(:,2)/rms(out(:,2))*p1;










