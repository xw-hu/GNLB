# Saliency-aware Texture Smoothing

by Lei Zhu*, Xiaowei Hu*, Chi-Wing Fu, Jing Qin and Pheng-Ann Heng (* joint first authors)

## Guided Non-local Block for Saliency Detection
This implementation is written by Xiaowei Hu at the Chinese University of Hong Kong.

***

## Citation
@article{hu2018direction,   
&nbsp;&nbsp;&nbsp;&nbsp;  author = {Zhu, Lei and Hu, Xiaowei and Fu, Chi-Wing and Qin, Jing and Heng, Pheng-Ann},    
&nbsp;&nbsp;&nbsp;&nbsp;  title = {Saliency-aware Texture Smoothing},    
&nbsp;&nbsp;&nbsp;&nbsp;  journal={IEEE Transactions on Visualization and Computer Graphics},    
&nbsp;&nbsp;&nbsp;&nbsp;  year  = {2018}    
}

## Dataset

Saliency Dataset for Texture Smoothing (SDTS) can be downloaded from [Google Drive](https://drive.google.com/file/d/1vo7kYFyaPRYQtj8b196sXy2FoN8oPnNZ/view?usp=sharing).

## Installation

1. Please download and compile our [CF-Caffe](https://github.com/xw-hu/CF-Caffe).

2. Clone the GNLB repository, and we'll call the directory that you cloned as `GNLB-master`.

    ```shell
    git clone https://github.com/xw-hu/GNLB.git
    ```

3. Replace `CF-Caffe/examples/` by `GNLB-master/examples/`.
   Replace `CF-Caffe/data/` by `GNLB-master/data/`.


## Test   

1. Enter the `examples/GNLB/` and run `test_saliency.m` in Matlab. 

2. Apply CRF to do the post-processing for each image.   
   The code for CRF can be found in [https://github.com/Andrew-Qibin/dss_crf](https://github.com/Andrew-Qibin/dss_crf)   
   *Note that please provide a link to the original code as a footnote or a citation if you plan to use it.

  
## Train

1. Download the pre-trained ResNet-101 caffemodel on ImageNet.               
   Put this model in `CF-Caffe/models/`.
   
2. Enter the `examples/GNLB/GNLB/`   
   Modify the image path in `train_val.prototxt`.          
   Modify the weight path in `train.sh` for different training sets (MSRA10K or SDTS) following our paper.

3. Run   
   ```shell
   sh train.sh

