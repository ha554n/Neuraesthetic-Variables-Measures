% 12/28/17 the purpose of this script to to allow for batch-level analysis
% of line thicknesses and ChiaroOscuro. 
% The format asks the user to select the files they want to work on.
% The results are saved in either cell or excel files
% (mac does not allow to write directly to excel).  
% 

clear ALL
fprintf('please select the files you want to run the analysis on') %ask the user to pick files from their file explorer
[fileNames] = uigetfile('*.*','MultiSelect','on');%reads and saves all extensions of filenames, must pick at least 2!
size_fNames=size(fileNames,2);
fprintf('You selected %d files which are stored in the "fileNames" cell. \n',size_fNames)
 
thickness=cellfun(@findpointsfile,fileNames,'UniformOutput', false);
[chiaroscuroindex,kurt,COind1,COind2,COind5,COind10,COind20,COind50] = cellfun(@nmg_chiaroscuro,fileNames,'UniformOutput', false);
format shortE
resultsThicknessesChiaroscuro=[fileNames;thickness;chiaroscuroindex;kurt;COind1;COind2;COind5;COind10;COind20;COind50];
fileNames=num2str(cell2mat(fileNames));
save(strcat('/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/DataDump/',fileNames,'_','thicknesseschiaroscuro.mat'),'resultsThicknessesChiaroscuro')