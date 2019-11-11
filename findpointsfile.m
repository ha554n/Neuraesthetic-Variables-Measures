
%performs the same concept as the 'findcenter' but on a row-by-row basis,
%it is searching for the point at which the two sides have the least
%imbalance in the sense of the 'integration' method.

function ratioj=findpointsfile(filename)
j=im2double(rgb2gray(imread(filename)));
% j=imread(filename);
if rem(size(j,2),2)~=0,j(:,1)=[];
end
if rem(size(j,1),2)~=0,j(1,:)=[];
end

jr=fliplr(j);
i=0;
k=0;
for y=1:size(j,1)
    for x=-(size(j,2)/2):(size(j,2)/2)
        if x<0
            left = (j(y,1:size(j,2)/2+x));
            right =(jr(y,1:size(j,2)/2+abs(x)));
        else
            left = (j(y,1:size(j,2)/2+x));
            right =(jr(y,1:size(j,2)/2-x));
        end
        
        t=sum(left,2);
        u=sum(right,2);
        total=[sum(t)-sum(u)]./[sum(t)+sum(u)]; 
        i=i+1;
        totalkeeper(i)=abs(total);
        xkeeper(i)=x;
    end
  k=k+1;
  therow=y;
  row_y_coordinates(k)=therow;
  minim=min(totalkeeper);%the minimum imbalance value
  location_of_min=find(totalkeeper==minim);
  xthatcausedit=xkeeper(location_of_min);

if length(xthatcausedit)>1
    xthatcausedit=min(xthatcausedit);
end
  x_collection(k)=xthatcausedit;
  what_column_put_zero=(size(j,2)/2)+xthatcausedit;
  column_x_coordinate(k)=what_column_put_zero;
  j(therow,what_column_put_zero)=255; %placing a pixel at the point of least imbalance
  i=0;
  totalkeeper(:)=[];
  xkeeper(:)=[];
  minim(:)=[];
  location_of_min(:)=[];
  xthatcausedit(:)=[];
  what_column_put_zero(:)=[];
   %resetting the values so that the next row values can be stored
end

m_a_d=mad(column_x_coordinate);%gets the mean absolute deviation of all of the points
len=size(j,2);
ratioj=m_a_d/len; %ratio to quantify the points distribution in respect to the image


figure(1)
imshow(j)
% figure(2)
% subplot(2,1,1)
% imshow(j)
% impixelinfo
hold on;
% subplot(2,1,2)
plot(column_x_coordinate,row_y_coordinates);
% lsline
% plot(row_y_coordinates,column_x_coordinate, '*');
filename = filename(1:end-4);
identifier='Findpoints';
savename=sprintf('%s_%s_',filename,identifier);
hold off;
fpath = '/Users/Norberto/Documents/Norberto/Science/Neuroesthetics/NMGArtMeasurements/findpointsfigures';
savefig(fullfile(fpath, savename));
end
      
        