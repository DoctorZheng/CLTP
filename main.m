close all;
clear all;

file_path =  '.\1\';% 图像文件夹路径，
cc=colormap(lines(100));
img_path_list = dir(strcat(file_path,'*.bmp'));%获取该文件夹中所有jpg格式的图像。
img_num = length(img_path_list);%获取图像总数量，
NUMD=zeros(img_num,10);
for ii = 1:10 %逐一读取图像，    
    I=imread(strcat(num2str(ii),'.bmp'));
        image_size=size(I);
        dimension=numel(image_size);
        if dimension~=2
           IT1 = rgb2gray(I);
        else
           IT1 = (I);             
        end
    [H W]=size(IT1);    
    [posX,posY]=susan(IT1,3);
    boundary=zeros(size(posX,1),4);
    for i = 1 : size(posX, 1)
      boundary(i,1)=max(1,posX(i)-4);
      boundary(i,2)=max(1,posY(i)-4);
      boundary(i,3)=min(2*(W-posX(i)),8);
      boundary(i,4)=min(2*(H-posY(i)),8);
    end

    file_path =  strcat(strcat('.\',num2str(ii)),'\');
    %SVDis=zeros(size(STATS0,1),img_num);
    if img_num > 0 %有满足条件的图像，
        Dis=zeros(size(posX,1),img_num);
        for jj = 1:img_num %逐一读取图像，
            image_name = img_path_list(jj).name;% 图像名，
            I1 =  imread(strcat(file_path,image_name));
            
            image_size=size(I1);
            dimension=numel(image_size);
            if dimension~=2
               IT2 = rgb2gray(I1);
            else
               IT2 = (I1);                
            end
            %GLCM, DWT, LBP, BGC1, LTP, LBPcoHDLBP, MRELBP and RALBGC                         
            Dnum=0;
            for i = 1 : size(posX, 1)
                IT1=I(floor(boundary(i,2)):floor(boundary(i,2)+boundary(i,4)), floor(boundary(i,1)):floor(boundary(i,1)+boundary(i,3)));
                IT2=I1(floor(boundary(i,2)):floor(boundary(i,2)+boundary(i,4)), floor(boundary(i,1)):floor(boundary(i,1)+boundary(i,3)));           
                 H1=CLTP_basi(IT1);  H1=H1(:)';  
                 H2=CLTP_basi(IT2);  H2=H2(:)';   
                 Dis(i,jj) = pdist2(H1,H2,'euclidean'); 
                 if  Dis(i,jj)>0.32  
                    Dnum=Dnum+1;
                 end  
            end   
            %判断差异
            NUMD(jj,ii)=Dnum/size(posX, 1);%(2*size(posX, 1));
        end
    end
end

TT=0.09;  
AA=NUMD;
AA(NUMD<TT)=1;%true
AA(NUMD>=TT)=0;%false




