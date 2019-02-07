%% Add needed folders to the Matlab path and start AMToolbox
%%  Author:     Jaroslav Bouse, bousejar@gmail.com
F = mfilename;
pathstr = which(F);
pathstr = pathstr(1:end - length(F)-2);
addpath(genpath(pathstr)); 
disp('Model path loaded')
amt_start();
