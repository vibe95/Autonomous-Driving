%% Code reference: 
% Training Classifier:
% https://www.mathworks.com/help/vision/examples/digit-classification-using-hog-features.html
% HOG: 
% https://www.mathworks.com/matlabcentral/fileexchange/28689-hog-descriptor-for-matlab?focused=5179304&tab=function


%TEMP CODE FOR TESTING. Using Matlabs test images
close all;
globals;
numOfTestImgs = 15; 
imset = 'train';
imgsList = getDataRoad([], imset, 'list'); 
imageNums = imgsList.ids(1:numOfTestImgs);  %get the images
disparityRange = [-6 10];   %parameter for matlab disparity function
patch_size = 15;    %parameter for matlab disparity function

X = []; 
Y = [];
%go through each image 
for i = drange(1:numOfTestImgs)        
    i
    %get left & gt of current imageid 
    left_imdata = getDataRoad(imageNums{i}, imset, 'left');
    left_img = rgb2gray(double(left_imdata.im)/255);
    %gt_imgdata = getDataRoad(imageNums{i}, imset, 'gt');
    %gt_img = gt_imgdata.gt;
    %imshow(gt_img);
    [image_sy, image_sx, image_sz] = size(left_imdata.im); 
    
    %find road and notroad for gt
   % road = zeros(size(gt_img));
   % road(find(gt_img >= 105)) = 1;
    %imshow(road);
    
    
    %get cloud for image 
    [cloud_img, cloud_rs]= findCloud(imageNums{i}, imset);
    [imidxx, imidxy] = meshgrid(1:image_sx,1:image_sy);
    cloud_img = cloud_img.Location;
    
    %% 2. Use HOG Features
    %left_img_bin = imbinarize(left_img);
    featureVector = HOGdescriptor(left_imdata.im);
    size(featureVector)
    
        
    %% generate training data x
    sprintf('here')
    xim = reshape(left_imdata.im, [image_sy * image_sx image_sz]);
    size(xim)
    size(left_imdata.im)
    xcloud = reshape(cloud_img, [image_sy * image_sx 3]);
    size(cloud_img)
    size(xcloud)
    xidx = reshape(imidxy, [image_sy * image_sx 1]);
    size(xidx)
    size(imidxy)
    
    xdesc = reshape(featureVector,[image_sy*image_sx 9]);
    xim = reshape(left_imdata.im, [image_sy * image_sx image_sz]);
    xcloud = reshape(cloud_img, [image_sy * image_sx 3]);
    xidx = reshape(imidxy, [image_sy * image_sx 1]);

    x = [xim xcloud xidx];
    
    
    
    
    %% concatenate to global X & Y
    idx = randperm(image_sy*image_sx,200);    
    x = x(idx,:);
    gt = min((255 - gt_img(:,:,1)) + gt_img(:,:,3),255)/255;
    y = reshape(gt, [image_sy * image_sx 1]);
    y = y(idx,:);
    X = [X; x];
    Y = [Y; y];
    
end


svmmodel = fitcsvm(double(X), double(Y));

fileLocation = sprintf('%s/%s/results/model.mat', DATA_DIR_ROAD,imset);
save(fileLocation,'svmmodel');