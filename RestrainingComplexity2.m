function [cv,ntest,cbv] = RestrainingComplexity2(complexityvec,complexity1,colss)

cv = complexityvec(1:colss);
testv = (cv>=complexity1);% Not allowing complexity of order 2 to be larger than complexity of order 1
ntest = sum(testv); % Number of points with complexity2 = complexity1.
cbv = complexityvec(find(1-testv)); % Get the data below complexity1

