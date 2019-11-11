function [hcompresults] = ha_horizontalcomplexity(filename)

global ntones
% prompt1='please give me the crop value ';
% crop= str2double(input(prompt1,'s'));%embed this as 147 no longer necessary 
crop = 147;

% This function replaces complexityimgf2 by computing complexity of order 2 as an
% mean over all distances with and without reflection.  We use the new
% function comatrices instead of graycomatrix.  The former compares two
% matrices (typically, the original and a isometric transformation).

% The parameter crop is the number columns removed from the calculation.
% If crop = 0, the first column is compared to the last column.  
% Thus, because the co-occureence matrix has 256^2 = 65,536 entries, we 
% would have at most only 100*1,024/65,536 = 1.56% of the pixels different
% from zero.  If instead crop = 1, the first column is compared to
% the penultimate column and the second column to the last column.  
% Hence, we basically double the number of pixels with non-zero entries.
% If assume that there is no correlation between the first columns and the
% last columns (e.g., because of long distance), then the probability of
% having a non-entry in the co-occurrence matrix obeys a Poisson
% distribution.  The mean of the that distribution is
% (crop+1)*1,024/65,536 = (crop+1)/64.  Thus, the fraction of zero
% entries is f0 = exp(-(crop+1)/64).  For crop = 63, f0 = 0.37.  
% For crop = 127, f0 = 0.14.  To have 10% of zero entries, we should crop 
% -ln(.1)*64-1 = 146.4.  We will then typically set crop = 147.  This 
% will often correspond 100*147/700 = 21% of the rows.

% The parameter ntones is the number of tones (a power of 2) into which we 
% want to simplify the image.  The maximum is 256, for which the analysis 
% is slow.  But, say, for 4 tones, the analysis is much faster. 

intres = 256/ntones; % The step size of the intensity
hm = log2(ntones); % maximal possible entropy

j=imread(filename); % Read image
sj = size(j); % Size of image
j=imresize(j,300/sj(2)); %%%Reducing Resolution

filename = filename(1:end-4);
identifier='horizontalcomplexity';

figure(1);imshow(j); % Show color image

j1=rgb2gray(j); % Make the image gray


figure(1);imshow(j1); % Show gray image
savename=sprintf('%s_%s_grayscale',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/horizontalcomplexityfigures';
savefig(fullfile(fpath, savename));

figure(1);histogram(j1,-.5:255.5); % Plot histogram of intensities of image
savename=sprintf('%s_%s_intensities',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/horizontalcomplexityfigures';
savefig(fullfile(fpath, savename));

j1 = floor(j1/intres); % Compute image of ntone n tones.
figure(1);imshow(intres*j1); % Show ntones image
savename=sprintf('%s_%s_ntones',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/horizontalcomplexityfigures';
savefig(fullfile(fpath, savename));

j2=fliplr(j1); % Reflection of image
figure(1);imshow(intres*j2); % Show reflection
savename=sprintf('%s_%s_reflection',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/horizontalcomplexityfigures';
savefig(fullfile(fpath, savename));

j1s = size(j1);
cols = j1s(2);
compar = cols-crop; % Number of comparisons in the calculation

figure(1);histogram(j1,.5:ntones+.5);
savename=sprintf('%s_%s_ntoneshisto',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/horizontalcomplexityfigures';
savefig(fullfile(fpath, savename));

[p1,entrop1] = probentrop1(j1,ntones); % the first-order probabilities and entropies
complexity1 = entrop1/hm;

onevec = ones(1,ntones);
complextrans = [];
complexrefl1 = [];
complexrefl2 = [];
% Compute complexity for all horizontal isometric transformations
for i = 0:(compar-1) % all possible translations
  
    % The next four lines compute the cropped images for comparisons to
    % obtain co-occurrences.
    transl1 = j1(:,1:(cols-i)); % Original image
    transl2 = j1(:,(i+1:cols)); % Image translated to the right
    reflec1 = j2(:,1:(cols-i)); % Image reflected and translated to the left
    reflec2 = j2(:,(i+1:cols)); % Image reflected and translated to the right
    
    % Next three lines are co-ocurrence matrices.
    % We only need one comparison for translation, because translating to
    % the right or to the left gives the same complexity.
    % However, we need to compare doubly with reflection, because if an
    % axis of symmetry is not centered, translation to the right or to the
    % left matter.
    cotrans = comatrices(transl1,transl2,ntones);
    corefl1 = comatrices(transl1,reflec2,ntones);
    corefl2 = comatrices(transl2,reflec1,ntones);
    
    % The second-order probabilities and entropies
    [~,entroptrans] = probentrop2(cotrans,onevec);
    [~,entroprefl1] = probentrop2(corefl1,onevec);
    [~,entroprefl2] = probentrop2(corefl2,onevec);

% The next four lines are to be used if we want compute absolute complexities of order 2 for the cropped images  
    % Taking the mean by the probabilities of the pixels of origin
    complextrans = [complextrans;entroptrans*p1];
    complexrefl1 = [complexrefl1;entroprefl1*p1];
    complexrefl2 = [complexrefl2;entroprefl2*p1];

% The next 14 lines are to be used if we want compute complexities of order 2 relative to complexity of order 1 for the cropped images  
%     % Calculating the first order probabilities for the cropped images
%     % The entropies are also the non-normalized first-order complexities for the cropped images
%     [p1trans,entrop1trans] = probentrop1(transl2,ntones);
%     [p1refl1,entrop1refl1] = probentrop1(reflec1,ntones);
%     [p1refl2,entrop1refl2] = probentrop1(reflec2,ntones);
%     % Non-normalized second-order complexities for the cropped images
%     % Taking the mean by the probabilities of the pixels of origin
%     complexity2trans = entroptrans*p1trans;
%     complexity2refl1 = entroprefl1*p1refl2;
%     complexity2refl2 = entroprefl2*p1refl1;
%     % Normalized complexities of order 2.
%     complextrans = [complextrans;complexity2trans*complexity1/entrop1trans];
%     complexrefl1 = [complexrefl1;complexity2refl1*complexity1/entrop1refl2];
%     complexrefl2 = [complexrefl2;complexity2refl2*complexity1/entrop1refl1];
    
    PercentageComplete = 100 * (i+1)/compar, % Display to know how far along the calculation we are.
end

% The next three lines are to be used if we want compute absolute complexities of order 2 for the cropped images
complextrans = complextrans/hm;
complexrefl1 = complexrefl1/hm;
complexrefl2 = complexrefl2/hm;

% We restrain the computation to 50% of the image to avoid
% background-background interactions and restrain complexity2 to be smaller
% than complexity1.
colss=round(cols/2);
[ct,nt,cbt] = RestrainingComplexity2(complextrans,complexity1,colss);
[c1,n1,cb1] = RestrainingComplexity2(complexrefl1,complexity1,colss);
[c2,n2,cb2] = RestrainingComplexity2(complexrefl2,complexity1,colss);

% Computing complexity of order 2 as a mean of medians
% Computing standard errors from medians
[complexity2,error2] = StimComplex2AndSTE(cbt,cb1,cb2,colss,nt,n1,n2,complexity1,ct,c1,c2);

derror = 2.33 * error2;% 1% one-sided error
% Figure illustrating some steps of the calculation, specially of spatial scale
figure(1);
plot(0:(compar-1),complextrans, '-r',[0;(compar-1)],[complexity1;complexity1],'--k');
hold on;
plot([0;(compar-1)],[complexity2;complexity2],'-k');
plot([0;(compar-1)],[complexity2-derror;complexity2-derror],':k');
plot([0:(compar-1)],complexrefl1, ' -b');
plot([0:(compar-1)],complexrefl2, ' -g');
hold off;
savename=sprintf('%s_%s_comp2',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/horizontalcomplexityfigures';
savefig(fullfile(fpath, savename));

% Spatial scale of short range information as fraction of picture
ii = find(complextrans > (complexity2-derror));
d = (ii(1)-1)/cols; % Percentage of picture of short scale information

% Computing short-range complexity of order 2 at 10% of picture and restrain complexity2 to be smaller
% than complexity1.
colss=round(cols/10);
[ct,nt,cbt] = RestrainingComplexity2(complextrans,complexity1,colss);
[c1,n1,cb1] = RestrainingComplexity2(complexrefl1,complexity1,colss);
[c2,n2,cb2] = RestrainingComplexity2(complexrefl2,complexity1,colss);

% Computing complexity of order 2 as a mean of medians
% Computing standard errors from medians
[complexityshort,errorshort] = StimComplex2AndSTE(cbt,cb1,cb2,colss,nt,n1,n2,complexity1,ct,c1,c2);

% How much the fall of complexity of order 2 was because of the spatial organization of the picture
fall1 = complexityshort/complexity1-1;
fall2 = complexityshort/complexity2-1;

 hcompresults={'ntones','compleixty1','complexity2','error2','complexityshort','errorshort','d','fall1','fall2';ntones,complexity1,complexity2,error2,complexityshort,errorshort,d,fall1,fall2};