function [complexity2,error2] = StimComplex2AndSTE(cbt,cb1,cb2,colss,nt,n1,n2,complexity1,ct,c1,c2)

% Computing complexity of order 2 as a mean of medians
% Computing standard errors from medians 
complexvec = [cbt;cbt;cb1;cb2]; % cbt is repeated, because translations to right and left give rise to the same complexity
n4 = 4*colss; % Total amount of data
ntest = 2*nt+n1+n2; % Number of points with complexity2 = complexity1
complexity2 = ((n4-ntest)*median(complexvec,'omitnan')+ntest*complexity1)/n4; % Complexity 2 as the mean of medians.
% Computing standard error 
et = ct-complexity2;
e1 = c1-complexity2;
e2 = c2-complexity2;
error2 = 1.4826*median(abs([et;et;e1;e2]))/sqrt(8*colss/3); % This denominator was calculated by taking into account the repetition of et.

