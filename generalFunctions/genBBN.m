function stim_out = genBBN(par)
% generator of broad band noise
% designed by Vaclav Vencovsky, vencovac@fel.cvut.cz
% CTU in Prague, Faculty of Electrical Engineering,
% department of radioelectronics
% inspired by m.files downloaded at web pages of the University of
% Rochester, Carney lab


% fs        sample freq
% Fmin      minimal frequency
% Fmax      maximal frequency
% SPL       sound pressure level of noise
% p0        reference value (usully 2e-5 Pa)
% sig_dur   duration of signal
% prior_sil duration of silence prior to signal onset
% post_sil  duration of silence after signal offset
% ramp_dur  duration of ramp shaping signal onset and offset
% noNorm    signal goes through without normalization

% par = struct;
% par.fs = 44100;
% par.Fmin = 20;
% par.Fmax = 5e3;
% par.SPL = 50;
% par.p0 = 2e-5;
% par.sig_dur = 1;
% par.prior_sil = 10e-3;
% par.post_sil = 10e-3;
% par.ramp_dur = 10e-3;
if ~isfield(par,'noRamp')
    par.noRamp = 0;
    
end;


if ~isfield(par,'seed')
    par.seed = 0;
    
end;


pre_sig = zeros(round(par.prior_sil * par.fs),1);
post_sig = zeros(round(par.post_sil * par.fs),1);


t = [0:1/par.fs:par.sig_dur-1/par.fs]';   % time axis for signal
eN = length(t); % number of signal samples



p = par.p0*10^(par.SPL/20);   %acoustic pressure (RMS value)

% randn('state',sum(100*clock)); % seed the random # generator with the clock
% rand('state',sum(100*clock)); % seed the random # generator with the clock

if par.seed
   load('rngSeed.mat'); 
   rng(s);
end

stim1 = randn(eN,1);   % generation of random numbers
fres = 1./(eN * 1/par.fs);
        
% Now filter the noise 
stimspectrum = fft(stim1);
nptslofreq = floor(par.Fmin/fres);
nptshifreq = ceil(par.Fmax/fres);
stimspectrum(1:nptslofreq) = 0.;  % zero out all bands that apply 
stimspectrum(nptshifreq:(eN - nptshifreq+2)) = 0.;
stimspectrum((eN - nptslofreq+2):eN) = 0.;
% So, values in the fft of stim1 (both real & imag parts) have been zeroed
stim1 = real(ifft(stimspectrum)); % inverse FFT to create noise waveform


if ~par.noRamp
% cration of cosine ramps
x = [0:1/par.fs:par.ramp_dur]';
x = pi*x/par.ramp_dur;
rampUp = 0.5*(1 - cos(x));
rampDown = flipud(rampUp);
whole_ramp = [rampUp; ones(eN-2*length(x),1); rampDown];
% ramping
stim1 = stim1.*whole_ramp;
end;
if isfield(par, 'noNorm')
	p= 1;
end;
                                 
stim1 = stim1/sqrt(mean(stim1 .^ 2)) * p;

stim_out = [pre_sig; stim1; post_sig];

