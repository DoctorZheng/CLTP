close all;
clear all;

file_path =  '.\fig-test\1\';% 鍥惧儚鏂囦欢澶硅矾寰勶紝
cc=colormap(lines(100));
img_path_list = dir(strcat(file_path,'*.bmp'));%鑾峰彇璇ユ枃浠跺す涓墍鏈塲pg鏍煎紡鐨勫浘鍍忋?
img_num = length(img_path_list);%鑾峰彇鍥惧儚鎬绘暟閲忥紝
NUMD=zeros(img_num,10);
for ii = 1:10 %閫愪竴璇诲彇鍥惧儚锛?   
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
    if img_num > 0 %鏈夋弧瓒虫潯浠剁殑鍥惧儚锛?
        Dis=zeros(size(posX,1),img_num);
        for jj = 1:img_num %閫愪竴璇诲彇鍥惧儚锛?
            image_name = img_path_list(jj).name;% 鍥惧儚鍚嶏紝
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
            %鍒ゆ柇宸紓
            NUMD(jj,ii)=Dnum/size(posX, 1);%(2*size(posX, 1));
        end
    end
end

TT=0.6;  
AA=NUMD;
AA(NUMD<TT)=1;%true
AA(NUMD>=TT)=0;%false
AA
