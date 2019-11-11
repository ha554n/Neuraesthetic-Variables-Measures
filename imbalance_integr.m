%looking at vertical bilateral imbalance via the integration method

function integrsum=imbalance_integr(filename)
j=im2double(rgb2gray(imread(filename)));
if rem(size(j,2),2)~=0,j(:,1)=[];
end
if rem(size(j,1),2)~=0,j(1,:)=[];
end


left = (j(:,1:size(j,2)/2));
right =(j(:,size(j,2)/2+1:end));
figure(1)
t=sum(left,2);
u=sum(right,2);
integrsum= [sum(t(:))-sum(u(:))]./[sum(t(:))+sum(u(:))];
% figure(1)
% subplot(2,2,1)
% imshow(j)
% title('full')
% subplot(2,2,2)
% imshow(left) 
% title('left')
% subplot(2,2,3)
% imshow(right) 
% title('right')
% impixelinfo;
figure(1)
plot(1:length(t),t,'-r',1:length(u),u,'-b')
title('Integration Method')
xlabel('pixel number')
ylabel('pixel intensity')
legend('blue=right, red=left')
filename = filename(1:end-4);
identifier='Imb_integr';
savename=sprintf('%s_%s_plot',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/imb_integr_figures';

savefig(fullfile(fpath, savename));
