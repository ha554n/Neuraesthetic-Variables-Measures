function [chiaroscuroindex,kurt,COind1,COind2,COind5,COind10,COind20,COind50] = nmg_chiaroscuro(filename)
j=rgb2gray(imread(filename));

figure(1);
p = histogram(j,(0:256)-.5);%stores histogram values of the matrix in variable 'p'
pv=p.Values;%the variable 'pv' calls the histogram values from 'p', by values 
%it is meant the number of times the numbers in 'j' appear. for example if 'j' is [1,1,1,2,2], then
% the 'pv' values would be [3,2]
filename = filename(1:end-4);
identifier='Chiaroscuro1';
savename=sprintf('%s_%s',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/ThicknessChiaroscuro';
% savefig(fullfile(fpath, savename));
p1 = pv./sum(pv); % Calculate histogram probabilities 
chiaroscuroindex = ((0:127)*p1(1:128)'+(127:-1:0)*p1(129:256)')/127;% The mean distance to the extremes normalized by the largest mean possible 
chiaroscuroindex = 1 - chiaroscuroindex; % A painting is very chiaroscuero (index = 1) if all instensities are extremes and zero otherwise.
[jx jy] = size(j);
j = reshape(j,1,jx*jy);
j = double(j);
kurt = kurtosis(j);
early = j <  prctile(j,99); sum(early);
indearly = find(early);
indlate = find(1-early);
COind1 = (median(j(indlate))-median(j(indearly)))/255;
early = j <  prctile(j,98); sum(early);
indearly = find(early);
indlate = find(1-early);
COind2 = (median(j(indlate))-median(j(indearly)))/255;
early = j <  prctile(j,95); sum(early);
indearly = find(early);
indlate = find(1-early);
COind5 = (median(j(indlate))-median(j(indearly)))/255;
early = j <  prctile(j,90); sum(early);
indearly = find(early);
indlate = find(1-early);
COind10 = (median(j(indlate))-median(j(indearly)))/255;
early = j <  prctile(j,80); sum(early);
indearly = find(early);
indlate = find(1-early);
COind20 = (median(j(indlate))-median(j(indearly)))/255;
early = j <  prctile(j,50); sum(early);
indearly = find(early);
indlate = find(1-early);
COind50 = (median(j(indlate))-median(j(indearly)))/255;

