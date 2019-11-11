function [p1,entrop1] = probentrop1(j,ntones)

% The parameter ntones is the number of tones (a power of 2) into which we 
% want to simplify the image.  The maximum is 256, for which the analysis 
% is slow.  But, say, for 4 tones, the analysis is much faster. 

p = histcounts(j,-.5:(ntones-.5));%stores histogram values of the matrix in variable 'p' 

p1 = p/sum(p); %computation of probabilities
p1fix = p1+(p==0);% Fixing zeros for log calculations in complexities
entrop1 = -p1*(log2(p1fix))';% Calculating entropies
p1=p1';

