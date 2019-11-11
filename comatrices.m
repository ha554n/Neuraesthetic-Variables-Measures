function glcm = comatrices(matrix1,matrix2,ntones)

glcm = zeros(ntones,ntones);

numlim = ntones-1;

for i=0:numlim
    for j=0:numlim
        glcm(i+1,j+1) = sum(sum((matrix1 == i).*(matrix2 == j)));
    end
end