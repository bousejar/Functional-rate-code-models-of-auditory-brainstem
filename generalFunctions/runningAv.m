
function [out] = runningAv(signal, weight, tau, fs)
% wn = (1/tau)/ (fs/2);
% 
% [B,A]=butter(1,wn,'low');

B = 1-exp(-1/(fs*tau));
A = [1 -exp(-1/(fs*tau))];

den = weight.^2;
num = signal.*den;

den = filter(B,A,den);

num= filter(B,A,num);



out = num./(den+realmin('single'));
% figure; plot(num./max(num)); hold on; plot(den./max(den)); hold on; plot(out./max(out))





