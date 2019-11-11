function ucenter= ufindcenter(filename)
j=im2double(rgb2gray(imread(filename)));
if rem(size(j,2),2)~=0,j(:,1)=[];
end
if rem(size(j,1),2)~=0,j(1,:)=[];
end

jr=fliplr(j);
for y=-29
if y<0
uleft= (j(:,1:(size(j,2)/2)+y));
uright =(jr(:,1:size(j,2)/2+abs(y)));
else
uleft = (j(:,1:size(j,2)/2+y));
uright =(jr(:,1:size(j,2)/2-y));
end
tc=sum(uleft,2);
uc=sum(uright,2);
utotal=[sum(tc)-sum(uc)]./[sum(tc)+sum(uc)]; 
ucenter=utotal;

% figure(1)
% imshow(j)
% title(['Imbalance' num2str(utotal)])

figure(1)
imshow(uleft) 
title('left')
filename = filename(1:end-4);
identifier='Findcenter';
savename=sprintf('%s_%s_left',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/findcenterfigures';
savefig(fullfile(fpath, savename));

figure(1)
imshow(fliplr(uright)) 
title('right')
impixelinfo;
filename = filename(1:end-4);
identifier='Findcenter';
savename=sprintf('%s_%s_right',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/findcenterfigures';
savefig(fullfile(fpath, savename));


figure(1)
plot(1:length(tc),tc,'-r',1:length(uc),uc,'-b')
title('Find Center Integration Method')
ylabel('pixel number')
xlabel('pixel intensity')
legend('blue=right, red=left')

filename = filename(1:end-4);
identifier='Findcenter';
savename=sprintf('%s_%s_graph',filename,identifier);
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/findcenterfigures';
savefig(fullfile(fpath, savename));


end
end