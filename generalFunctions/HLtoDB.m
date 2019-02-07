function db=HLtoDB(L,f)
%% ANSI S3.6-1996 standard to convert dB SPL to dB HL.

refF = [125 250 500 750 1000 1500 2000 3000 4000 6000 8000];
refDb = [45 27 13.5 9 7.5 7.5 9 11.5 12 16 15.5]; 



 db = L +  interp1(refF, refDb,f, 'linear');
 





