clear all; close all;
clear;clc;

addpath('../../matlab/');

model_root_dir = './GNLB/';
definition_file = [model_root_dir 'deploy.prototxt'];
binary_file = [model_root_dir 'snapshot/' 'GNLB_iter_10000.caffemodel'];

assert(exist(binary_file, 'file') ~= 0);
assert(exist(definition_file, 'file') ~= 0);

caffe.reset_all();

caffe.set_mode_gpu();
caffe.set_device(0);

% Initialize a network
net = caffe.Net(definition_file, binary_file, 'test');

%net.layers('gprnn5-1a').params(2).get_data()

image_list1 = textread('/home/xwhu/saliency/RADF-master/RADF/data/ECSSD/test.txt', '%s');

image_list2 = textread('/home/xwhu/saliency/RADF-master/RADF/data/DUTS/test.txt', '%s');

image_list3 = textread('/home/xwhu/saliency/RADF-master/RADF/data/DUT-OMRON/test.txt', '%s');

image_list4 = textread('/home/xwhu/saliency/RADF-master/RADF/data/HKU-IS/test.txt', '%s');

image_list5 = textread('/home/xwhu/saliency/RADF-master/RADF/data/PASCAL-S/test.txt', '%s');

image_list6 = textread('/home/xwhu/saliency/RADF-master/RADF/data/SOD/test.txt', '%s');

root_dir = {'/home/xwhu/dataset/ECSSD/images_ECSSD/', ...
    '/home/xwhu/dataset/DUTS/duts/', ...
    '/home/xwhu/dataset/DUT-OMRON/DUT-OMRON-image/', ...
    '/home/xwhu/dataset/HKU-IS/imgs/', ...
    '/home/xwhu/dataset/PASCAL-S/input/', ...
    '/home/xwhu/dataset/SOD/image/'};

whole_list = {image_list1, image_list2, image_list3, image_list4, image_list5, image_list6};

save_root = './result/';

dataset = {'ECSSD','DUTS','DUTO','HKUIS','PASCAL','SOD'};
test_list = {'test_list_ecssd.txt', 'test_list_duts.txt', 'test_list_duto.txt', 'test_list_hkuis.txt', 'test_list_pascal.txt', 'test_list_sod.txt'};

imgW = 400; imgH = 400;

for set = 1:6
    
    save_root_datset = [save_root, dataset{set} , '/'];
    if exist(save_root_datset, 'dir') == 0
        mkdir(save_root_datset);
    end
    
    image_list = whole_list{set};
    nImg=length(image_list);
    fprintf('Dataset: %s, nImg: %i\n', dataset{set}, nImg);
    
    avgtime = 0;
    usedtime = 0;
    show = 0;
    
    %net.layers('gprnn5-1a').params(2).get_data();
    
    for k = 1 : nImg
        
        test_image = imread([root_dir{set} image_list{k}]);
        
        if size(test_image,3)==1
            img_tt = uint8(zeros(size(test_image,1), size(test_image,2), 3));
            img_tt(:,:,1) = test_image;
            img_tt(:,:,2) = test_image;
            img_tt(:,:,3) = test_image;
            test_image = img_tt;
        end
        
        
        if (show)
            imshow(test_image);
        end
        
        mu = ones(1,1,3); mu(:,:,1:3) = [104.00698793,116.66876762,122.67891434];
        mu = repmat(mu,[imgH,imgW,1]);
        
        
        ori_size = [size(test_image,1), size(test_image,2)];
        test_image = imresize(test_image,[imgH imgW]);
        test_image = single(test_image(:,:,[3 2 1]));
        test_image = bsxfun(@minus,test_image,mu);
        test_image = permute(test_image, [2 1 3]);
        
        % network forward
        tic; outputs = net.forward({test_image}); pertime=toc;
        usedtime=usedtime+pertime; avgtime=usedtime/k;
        
        
        final = net.blobs('sigmoid2').get_data();
        
        final = permute(final, [2 1 3]);
        final = imresize(final, ori_size);
        
        file_name = image_list{k};

        imwrite(final,[save_root_datset file_name]);
        
    end
  
end