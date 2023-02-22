close all;
clear all;

file_path =  '.\fig-test\1\';% Image folder path
cc=colormap(lines(100));
img_path_list = dir(strcat(file_path,'*.bmp'));%Get all jpg images in this folder
img_num = length(img_path_list);%Total number of images acquired
NUMD=zeros(img_num,10);
for ii = 1:10 %Read images one by one   
    I=imread(strcat('fig-test\',strcat(num2str(ii),'.bmp')));
        image_size=size(I);
        dimension=numel(image_size);
        if dimension~=2
           IT1 = rgb2gray(I);
        else
           IT1 = (I);             
        end
    [H W]=size(IT1);    
    [posX,posY]=susan(IT1,3);
    R=4;
    boundary=zeros(size(posX,1),4);
    for i = 1 : size(posX, 1)
      boundary(i,1)=max(1,posX(i)-R);
      boundary(i,2)=max(1,posY(i)-R);
      boundary(i,3)=min(2*(W-posX(i)),2*R);
      boundary(i,4)=min(2*(H-posY(i)),2*R);
    end

    file_path =  strcat(strcat('.\fig-test\',num2str(ii)),'\');
    %SVDis=zeros(size(STATS0,1),img_num);
    if img_num > 0 %There are images that meet the conditions
        Dis=zeros(size(posX,1),img_num);
        for jj = 1:img_num %Read images one by one
            image_name = img_path_list(jj).name;% image name
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
                 if  Dis(i,jj)>0.30 
                    Dnum=Dnum+1;
                 end  
            end   
            %Judgment difference
            NUMD(jj,ii)=Dnum/size(posX, 1);%(2*size(posX, 1));
        end
    end
end

TT=0.6;  
AA=NUMD;
AA(NUMD<TT)=1;%true
AA(NUMD>=TT)=0;%false
AA
