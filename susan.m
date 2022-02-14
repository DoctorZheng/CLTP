function [posX,posY]=susan(I,radius)
%SUSAN�ǵ���
%I:����ͼ��
%radius:Բ��ģ��İ뾶
%(posX,posY):�ǵ�����
[r,c]=size(I);
mask=generatemask(radius);
th1=40;%�ҶȲ�ֵ��ֵԽС����ȡ�Ľǵ�Խ��18
th2=sum(mask(:))/2;%������ֵԽ����ȡ�Ľǵ�Խ��
R=zeros(r,c);%�ǵ���Ӧֵ
res=zeros(r,c);%�Ƿ��ǽǵ�
for i=radius+1:r-radius
    for j=radius+1:c-radius
        B=I(i-radius:i+radius,j-radius:j+radius);
        usan=(abs(B-I(i,j))<th1).*mask;%USAN����
        N=sum(usan(:));
        if(N<th2)
            R(i,j)=th2-N;
        end
    end
end

%�Ǽ���ֵ����
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
%���ɰ뾶Ϊradius����ģ
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