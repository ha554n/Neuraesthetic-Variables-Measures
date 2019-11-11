function [p2,entrop2] = probentrop2(comatrix,onevec)

% Getting probabilities, including zeros
% Attention, the first index is the pixel of origin (i.e., the 
% condition in the conditional probability, whereas the second pixel is
% the target (the independent variable)

den = ((sum(comatrix'))'*onevec);
fixden = (den == 0);
den = den + fixden;
p2 = comatrix./den;
p2 = p2 .* (1-fixden);
p2fix = p2+(comatrix==0); % Fixing zeros for log calculations in complexities
entrop2 = -sum(p2'.*(log2(p2fix)'));% Calculating entropies for every intensity of pixel of origin
