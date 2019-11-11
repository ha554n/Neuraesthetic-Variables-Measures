% 07/27/17 the purpose of this script to to allow for batch-level analysis
% of images using the complexity functions. 
% The format asks the user to select the files they want to work on.
% The results of the various functions are saved in either cell or excel files
% (mac does not allow to write directly to excel). The images from the
% functions are saved at specified files automatically. 
% 
 
clear ALL
global ntones
fprintf('please select the files you want to run the analysis on') %ask the user to pick files from their file explorer
[fileNames] = uigetfile('*.*','MultiSelect','on');%reads and saves all extensions of filenames, must pick at least 2!
size_fNames=size(fileNames,2);
fprintf('You selected %d files which are stored in the "fileNames" cell. \n',size_fNames)
 
ntones = 32;
 
% horizontalcomplexity=cellfun(@ha_horizontalcomplexity_low_resolution,fileNames,'UniformOutput',false);
horizontalcomplexity=cellfun(@ha_horizontalcomplexity,fileNames,'UniformOutput',false);
format shortE
complexityresults=[fileNames;horizontalcomplexity];
fileNames=num2str(cell2mat(fileNames));
save(strcat('/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/DataDump/',fileNames,'_','complexityresults.mat'),'complexityresults')