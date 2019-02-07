function d=calcD(A,B)
%% Calculate d prime
%%  input: A stimA    
%          B StimB
%%  Author:     Jaroslav Bouse, bousejar@gmail.com

d = abs(mean(A)-mean(B))./sqrt(std(A)*std(B)) ;  