function [out]=shift_phase(in,par)
%shift phase spectrum by a desired phase shift
% in ... input signal
% par... input paramaters
%EXAMPLE
%par = struct;
%par.fs= 96e3;  ... sample frequency
%par.phaseShift = 90; ... desired phase shift in degrees
%par.timeShift = 1;  ... desired time shift in uS
%Jaroslav Bouse, FEE, CTU in Prague
%bousejar@fel.cvut.cz

fs = par.fs;
nCH = size(in,2);
len = length(in(:,1)); 

if isfield(par, 'phaseShift')
phaseShift = (par.phaseShift/360)*2*pi;
end;

if isfield(par, 'timeShift')
    if ~mod(len,2)
       N = len/2+1;
    else
        N = (len+1)/2;   
     end;
    phaseShift = zeros(N-1,1)+par.timeShift;
    freqAx = (fs/2)*(1:N-1)/N;
    period = 1./freqAx;
    phaseShift(1:end) =phaseShift./period'*2*pi;
%     N = round(length(in)/2);
%     phaseShift = zeros(N,1)+par.timeShift;
%     size(phaseShift)
%     freqAx = (fs/2)*(0:N-1)/N;
%     
%     size(freqAx)
 %     phaseShift
%     phaseShift(2:N) = par.timeShift./period.*2*pi;
% phaseShift(1:end) =phaseShift./period'*2*pi;

end;

for ii=1:nCH   
 cSpectrum = fft(in(:,ii));  %original complex spectrum
 mSpectrum = abs(cSpectrum); %magnitude spectrum
 pSpectrum = angle(cSpectrum); %phase spectrum
 
 if ~mod(len,2)
  N = len/2+1;
 pSpectrum(2:N)=pSpectrum(2:N)+phaseShift;
 pSpectrum =[ pSpectrum(1:N) ;flipud( -1*pSpectrum(2:N-1))];
 %  pSpectrum = [pSpectrum(2:N); flipud(-1*pSpectrum(2:N-1))
 

 else
  N = (len+1)/2-1; 

 pSpectrum(2:N)=pSpectrum(2:N)+phaseShift;
 pSpectrum =[ pSpectrum(1:N) ;flipud( -1*pSpectrum(2:N-1))];
 end;
 
 
 cSpec = mSpectrum.*exp(j*pSpectrum);
 out(:,ii) = real(ifft(cSpec));
%  out(:,ii) = ifft(cSpec);
 
%  r = mSpectrum.*cos(pSpectrum);
%  i = j*mSpectrum.*sin(pSpectrum);
%  out(:,ii) = ifft(r+i);
 if isfield(par, 'ramp')
     % use default length ramp 20e-3
     rampDur = 20e-3;
     x = [0:1/fs:rampDur-1/fs]';
     x = pi*x/rampDur;
     rampUp = 0.5*(1 - cos(x));
     rampDown = flipud(rampUp);
     whole_ramp = [rampUp; ones(length(out(:,ii))-2*length(x),1); rampDown];
     out(:,ii) = whole_ramp.*out(:,ii);    
 
 end;


end;


     
% % cration of cosine ramps
% x = [0:1/par.fs:par.ramp_dur]';
% x = pi*x/par.ramp_dur;
% rampUp = 0.5*(1 - cos(x));
% rampDown = flipud(rampUp);
% whole_ramp = [rampUp; ones(eN-2*length(x),1); rampDown];
%      
%  end;
 
%     figure; plot(real(out))





