function  result = CLTP_basi(I)
[m,n,h] = size(I);
if h==3
    I =  rgb2gray(I);
end
I=double(I);
lbpIu = double(zeros([m-2 n-2]));
lbpId = double(zeros([m-2 n-2]));
t=2;
for i = 2:m-1
    for j = 2:n-1
        neighbor01 = ([I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1) I(i-1,j-1)] - [I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)])>=t;
        neighbor02 = ([I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1) I(i-1,j-1)] - [I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)])<=-t;
        neighbor11 = ([I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)] - I(i,j))>=t;
        neighbor12 = ([I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)] - I(i,j))<=-t;
        neighbor0 = neighbor01 - neighbor02;
        neighbor1 = neighbor11 - neighbor12;
        neighbor_u = (neighbor0 + neighbor1) > 0;
        neighbor_d = (neighbor0 + neighbor1) < 0;
        pixel_u = 0;pixel_d = 0;
        for k = 1:8
            pixel_u = pixel_u + neighbor_u(1,k) * bitshift(1,8-k);
            pixel_d = pixel_d + neighbor_d(1,k) * bitshift(1,8-k);
        end
        lbpIu(i-1,j-1) = double(pixel_u);
        lbpId(i-1,j-1) = double(pixel_d);
    end
end

% Return histogram
bins= 256;%8*(8-1) + 3;  
result(1,:)=hist(lbpIu(:),0:(bins-1));%/ numel(lbpIu);
result(2,:)=hist(lbpId(:),0:(bins-1));%/ numel(lbpIu);
result(1,:)=result(1,:)/sum(result(1,:));
result(2,:)=result(2,:)/sum(result(2,:));