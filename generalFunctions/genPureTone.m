function [stim_out tx] = genPureTone(par)
% generator of pure tone signal
% designed by Vaclav Vencovsky, vencovac@fel.cvut.cz
% CTU in Prague, Faculty of Electrical Engineering,
% department of radioelectronics

% edited by Jaroslav Bouse FEE CTU / added phase and dBrms parameter

% fs        sample freq
% fsig      signal frequency
% SPL       sound pressure level of noise
% p0        reference value (usully 2e-5 Pa)
% sig_dur   duration of signal
% prior_sil duration of silence prior to signal onset
% post_sil  duration of silence after signal offset
% ramp_dur  duration of ramp shaping signal onset and offset
% phase     initial phase of the signal, leave this field empty if you want
%           zero phase shift
%dBrms      choose '1'if you want RMS value of the signal equal to SPL
if ~isfield(par,'noRamp')
    par.noRamp = 0;
    
end;

pre_sig = zeros(round(par.prior_sil * par.fs),1);
post_sig = zeros(round(par.post_sil * par.fs),1);


t = [0:1/par.fs:par.sig_dur-1/par.fs]';   % time axis for signal
eN = length(t); % number of signal samples


% size(whole_ramp)
% size(rampUp)
p = par.p0*10^(par.SPL/20);   %acoustic pressure (RMS value)
if isfield(par, 'phase')
    stim1 = sin(2*pi*par.fsig*t+par.phase);   % generation of random numbers
else
    stim1 = sin(2*pi*par.fsig*t);
end;
% size(stim1)

if par.noRamp
    
else
    % cration of cosine ramps
    x = [0:1/par.fs:par.ramp_dur]';
    x = pi*x/par.ramp_dur;
    rampUp = 0.5*(1 - cos(x));
    rampDown = flipud(rampUp);
    whole_ramp = [rampUp; ones(eN-2*length(x),1); rampDown(1:end)];
    % ramping
    stim1 = stim1.*whole_ramp;

end;
    

stim1 = stim1 * p; % setting desired SPL value

stim_out = [pre_sig; stim1; post_sig];

if isfield(par, 'dBrms')
    if par.dBrms == 1
    stim_out = sqrt(2)*stim_out;
    end;
end;


tx = [0:1/par.fs:(length(stim_out)-1)/par.fs]';   % time axis for signal

