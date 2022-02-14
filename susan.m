function [posX,posY]=susan(I,radius)
%SUSAN角点检测
%I:输入图像
%radius:圆形模板的半径
%(posX,posY):角点坐标
[r,c]=size(I);
mask=generatemask(radius);
th1=40;%灰度差值阈值越小，提取的角点越多18
th2=sum(mask(:))/2;%比率阈值越大，提取的角点越多
R=zeros(r,c);%角点响应值
res=zeros(r,c);%是否是角点
for i=radius+1:r-radius
    for j=radius+1:c-radius
        B=I(i-radius:i+radius,j-radius:j+radius);
        usan=(abs(B-I(i,j))<th1).*mask;%USAN区域
        N=sum(usan(:));
        if(N<th2)
            R(i,j)=th2-N;
        end
    end
end

%非极大值抑制
tr=radius+2;
for i=tr+1:r-tr
    for j=tr+1:c-tr
        tmp=R(i-tr:i+tr,j-tr:j+tr);
        tmp(tr+1,tr+1)=0;
        if(R(i,j)>max(tmp(:)))
            res(i,j)=1;
        end
    end
end
[posY,posX]=find(res);

function mask=generatemask(radius)
%生成半径为radius的掩模
mask=zeros(2*radius+1,2*radius+1);
[row,col]=size(mask);
cenr=(row+1)/2;
cenc=(col+1)/2;
for i=1:row
    for j=1:col
        if((i-cenr)^2+(j-cenc)^2<=radius^2)
            mask(i,j)=1;
        end
    end
end