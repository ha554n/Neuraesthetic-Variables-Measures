% 04/07/17 the purpose of this script to to allow for batch-level analysis
% of images using the various functions (excluding complexity). 
% The format asks the user to select the files they want to work on.
% The results of the various functions are saved in either cell or excel files
% (mac does not allow to write directly to excel). The images from the
% functions are saved at specified files automatically. 
% 

clear ALL
fprintf('please select the files you want to run the analysis on') %ask the user to pick files from their file explorer
[fileNames] = uigetfile('*.*','MultiSelect','on');%reads and saves all extensions of filenames, must pick at least 2!
size_fNames=size(fileNames,2);
fprintf('You selected %d files which are stored in the "fileNames" cell. \n',size_fNames)
 
asymmetry=cellfun(@sym_file,fileNames,'UniformOutput', false);
findcenter=cellfun(@ufindcenter,fileNames,'UniformOutput', false);
findpoints=cellfun(@findpointsfile,fileNames,'UniformOutput', false);
imb_mean=cellfun(@imbalance_mean,fileNames,'UniformOutput', false);
imb_integr=cellfun(@imbalance_integr,fileNames,'UniformOutput', false);
format shortE
results=[fileNames;asymmetry;imb_mean;imb_integr];
fileNames=num2str(cell2mat(fileNames));
save(strcat('/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/DataDump/',fileNames,'_','results.mat'),'results')
 