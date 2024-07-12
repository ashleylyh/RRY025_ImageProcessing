function mask = filip_function(imname)

%extract the image
im_all=double(imread(imname));
im=im_all(:,:,1);
imageSize=size(im);
im=im(1:min(imageSize),1:min(imageSize));

%lowpass filter
im_l=zeros(size(im_all));
im_mask=zeros(size(im_all));
for i=1:3
    sigma=6; % order of the filter
    im_l(:,:,i)=imgaussfilt(im_all(:,:,i),sigma);
    im_mask(:,:,i)=im_all(:,:,i)-im_l(:,:,i);
end

A=2;
im_mask=mean(im_mask,3);
im_all=im_all+im_mask.*A; %A sharp factor

% filter2
im_all_new=zeros(size(im_all));
for i=1:3
    im_tmp=im_all(:,:,i);
    h=fspecial('log',60,7);
    im_filt_h=imfilter(im_tmp,h);
    im_filt_v=imfilter(im_tmp,h');
    im_filt=im_filt_h+im_filt_v;
    im_filt=uint8(im_filt);
    im_all_new(:,:,i)=im_filt;
end
im_edge=mean(im_all_new,3);

%make binary and imfill
im_edge(im_edge>0)=1;
im_edge((end-10):end,:)=1;
im_edge(:,1:2)=1;
im_edge(:,(end-1):end)=1;
im_fill=uint8(imfill(im_edge,26,'holes'));

%bonus
sigma=4;
im_fill_smot=imgaussfilt(im_fill,sigma);

im_fill2=imfill(im_fill_smot);

%finalize mask
se = strel('disk',100);
im_close=imclose(im_fill2,se);

im_fill3=imfill(im_close);

% mask 
mask=double(im_fill3);
%mask = double(im_close);

end