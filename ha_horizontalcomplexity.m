function [hcompresults] = ha_horizontalcomplexity(filename)

global ntones
% prompt1='please give me the crop value ';
% crop= str2double(input(prompt1,'s'));%embed this as 147 no longer necessary 
crop = 147;
% ntones = 2;
% prompt2='please indicate number of tones, aka ntones  ';
% ntones= str2double(input(prompt2,'s'));


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

% The following are the data collected for the posed controls
%         j = j(80:sj(1),240:870,:); % Ivan45, c1=.781 -23.8%, c2 = .679+-.0012 -12.3%, c_short = .595+-.0037, d = 13.2%
%         j = j(40:sj(1),30:910,:); % Ivan0, c1=.766 -31.3%, c2 = .675+-.000998 -22.0%, c_short = .526+-.0055, d = 14.1%
%         j = j(50:sj(1),340:850,:); % Ivan90, c1=.910 -27.9%, c2 = .756+-.0017 -13.2%, c_short = .656+-.0047, d = 15.3%
%         j = j(70:sj(1),330:800,:); % Breanna45, c1=.925 -9.55%, c2 = .874+-.0016 -4.31%, c_short = .837+-.0066, d = 11.7%
%         j = j(50:sj(1),170:720,:); % Breanna0, c1=.901 -25.6%, c2 = .850+-.0017 -21.2%, c_short = .670+-.0099, d = 14.0%
%         j = j(70:sj(1),370:770,:); % Breanna90, c1=.889 -13.7%, c2 = .814+-.0033 -5.69%, c_short = .767+-.0063, d = 11.5%
%         j = j(80:sj(1),180:790,:); % Consuelo45, c1=.973 -9.12%, c2 = .928+-.00085 -4.71%, c_short = .884+-.0043, d = 13.9%
%         j = j(50:sj(1),120:900,:); % Consuelo0, c1=.898 -27.4%, c2 = .858+-.0020 -24.0%, c_short = .652+-.0105, d = 19.3%
%         j = j(60:sj(1),220:770,:); % Consuelo90, c1=.810 -14.5%, c2 = .765+-.0039 -9.57%, c_short = .692+-.0111, d = 11.4%
%         j = j(30:sj(1),110:740,:); % Norberto45, c1=.807 -17.7%, c2 = .771+-.0014 -13.9%, c_short = .664+-.0061, d = 14.6%
%         j = j(30:sj(1),100:850,:); % Norberto0, c1=.856 -25.6%, c2 = .796+-.0011 -20.9%, c_short = .637+-.0068, d = 17.3%
%         j = j(60:sj(1),220:660,:); % Norberto90, c1=.854 -20.5%, c2 = .762+-.0029 -10.9%, c_short = .679+-.0131, d = 13.4%
%         j = j(90:sj(1),310:850,:); % Hassan45, c1=.785 -15.8%, c2 = .749+-.0030 -11.8%, c_short = .661+-.0045, d = 14.2%
%         j = j(50:sj(1),130:890,:); % Hassan0, c1=.739 -19.4%, c2 = .708+-.0033 -16.0%, c_short = .595+-.0060, d = 9.33%
%         j = j(90:sj(1),390:780,:); % Hassan90, c1=.950 -22.7%, c2 = .806+-.0035 -8.83%, c_short = .734+-.0097, d = 15.9%
%         j = j(130:sj(1),300:820,:); % Shauntell45, c1=.961 -24.8%, c2 = .827+-.0014 -12.6%, c_short = .723+-.0078, d = 15.9%
%         j = j(160:sj(1),210:880,:); % Shauntell0, c1=.794 -31.0%, c2 = .717+-.0020 -23.6%, c_short = .548+-.0062, d = 20.1%
%         j = j(90:sj(1),380:750,:); % Shauntell90, c1=.889 -23.9%, c2 = .815+-.0012 -16.9%, c_short = .677+-.0087, d = 14.8%
%         j = j(40:sj(1),380:840,:); % Sylvia45, c1=.788 -7.29%, c2 = .772+-.0017 -5.28%, c_short = .731+-.0018, d = 11.9%
%         j = j(30:sj(1),150:670,:); % Sylvia0, c1=.786 -14.6%, c2 = .768+-.0025 -12.6%, c_short = .672+-.0054, d = 13.2%
%         j = j(40:sj(1),280:670,:); % Sylvia90, c1=.757 -9.06%, c2 = .691+-.0012 -0.38%, c_short = .689+-.0068, d = 11.0%
%         j = j(110:sj(1),270:860,:); % Cam45, c1=.744 -3.26%, c2 = .737+-.0017 -2.38%, c_short = .719+-.0025, d = 8.29%
%         j = j(90:sj(1),190:850,:); % Cam0, c1=.679 -4.51%, c2 = .673+-.0023 -3.74%, c_short = .648+-.0023, d = 6.05%
%         j = j(100:sj(1),370:820,:); % Cam90, c1=.758 -5.65%, c2 = .742+-.0016 -3.70%, c_short = .715+-.0051, d = 10.6%
%         j = j(80:sj(1),290:870,:); % Adam45, c1=.737 -3.54%, c2 = .722+-.0022 -1.57%, c_short = .711+-.0016, d = 9.47%
%         j = j(20:sj(1),180:900,:); % Adam0, c1=.710 -7.04%, c2 = .696+-.0021 -5.19%, c_short = .660+-.0011, d = 12.5%
%         j = j(10:sj(1),380:840,:); % Adam90, c1=.818 -4.78%, c2 = .805+-.0014 -3.27%, c_short = .779+-.0033 d = 8.89^%
% Conclusions:
% 1. The characteristic spatial scale in terms of percentage of the picture is independent of angle.
% 2. cshort is minimal at angle = 0.  (9-0 when comparing to 90 and 45). However, cshort is equivalent for 45 and 90 degrees.
% 3. c1 is independent of angle.
% 5. The fall from c1 to cshort is weakest for angle 45. (9-0 for angle 0 and 8-1 for angle 90).
% 6. The fall from c2 to cshort is strongest for angle 0 (9-0 for both comparisons). But no effect exists from 45 to 90.
% 7. No systematic dependence on angle was observed from c1 to c2.
% 8. There is a systematic fall from c1 to c2.
% 9. There is a systematic fall from c2 to cshort.
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


