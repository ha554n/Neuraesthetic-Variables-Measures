%gives a measure of vertical bilateral asymmetry as well as imbalance by
%MEAN method. Figures show asymmetry and imbalance plots.

function asymmetry= sym_file(filename)
j=im2double(rgb2gray(imread(filename)));
if rem(size(j,2),2)~=0,j(:,1)=[];
    if rem(size(j,1),2)~=0,j(1,:)=[];
    end
end
jr=fliplr(j);
left=(j(:,1:size(j,2)/2));
right=(jr(:,1:size(j,2)/2));
t=sum(left,2);
u=sum(right,2);
symmetry= (left-right)./255;
symmetry2=reshape(symmetry,1,(numel(symmetry)));
% imbalance=mean(symmetry2);
asymmetry=255*sqrt(mean(symmetry2.^2));

figure(1)
% ('Name',num2str(filename),'NumberTitle','off');
histogram(symmetry2,200)
title(['symmetry:' num2str(asymmetry)])
filename = filename(1:end-4);
identifier='Asymmetry';
savename=sprintf('%s_%s_histogram',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/asymmetryfigures';
savefig(fullfile(fpath, savename));
% figure(1)
% imshow(j)
% % title(['imbalance:' num2str(imbalance)])
% figure(1)
% imshow(left) 
% title('left')
% figure(1)
% imshow(fliplr(right)) 
% title('right')
% impixelinfo;
% subplot(3,2,5)
% plot(1:length(t),t,'-r',1:length(u),u,'-b')
% title('results,red=left/blue=right')
% set(gcf,'Visible','off')              % turns current figure "off"
% filename = filename(1:end-4);
% identifier='Asymmetry';
% savename=sprintf('%s_%s',filename,identifier);
% fpath = 'C:\Users\hassan\Pictures\Saved Pictures';
% savefig(fullfile(fpath, savename));

end