%general vertical bilateral imbalance via the mean based method

function Imbalance=imbalance_mean(filename)
j=im2double(rgb2gray(imread(filename)));
if rem(size(j,2),2)~=0,j(:,1)=[];
   
end
if rem(size(j,1),2)~=0,j(1,:)=[];
    
end

jr=fliplr(j);

left = (j(:,1:size(j,2)/2));
right =(jr(:,1:size(j,2)/2));

t=sum(left,2);
u=sum(right,2);
    tt=sum(t(:));
    uu=sum(u(:));
        mean_t=tt/numel(left);
        mean_u=uu/numel(right);
Imbalance=(mean_t-mean_u)./255;
% figure(1)
% % figure('Name',num2str(filename),'NumberTitle','off')
% subplot(2,2,1)
% imshow(j)
% title(['imbalance:' sprintf('%0.5f',Imbalance)])
% subplot(2,2,2)
% imshow(left) 
% title('left')
% subplot(2,2,3)
% imshow(fliplr(right)) 
% title('right')
% impixelinfo;
figure(1)
plot(1:length(t),t,'-r',1:length(u),u,'-b')
title('Mean Based Method')
legend('red=left blue=right')
xlabel('pixel number')
ylabel('pixel value')
filename = filename(1:end-4);
identifier='Imb_mean';
savename=sprintf('%s_%s_plot',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/imb_mean_figures';
savefig(fullfile(fpath, savename));
