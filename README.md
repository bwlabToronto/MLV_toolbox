<img src='images/Logo_Banner.png' width=40%> 
<hr>

The MLV toolbox provides a set of mid-level vision 

In this section, we are going to explain what MLV_toolbox is.

We are working on the python version and we have a plan to release the python version soon.<br> 
*_Please stay tuned for updates!_* 

## Table of Contents
- [Requirements](#Requirements)
- [Usage](#Usage)
- [Datasets](#Datasets)
- [FAQs](#FAQs)
- [References](#References)



## Requirements

* [Matlab](https://www.mathworks.com/products/matlab.html)
* [Matlab Computer Vision Toolbox ](https://www.mathworks.com/products/computer-vision.html)
* [Matlab Image Processing Toolbox](https://www.mathworks.com/products/image.html)
* [Matlab Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) 

## Usage

**Setup Path**

The first step to use the MLV toolbox is to add the required folders to the Matlab path. You can do this on Matlab's Graphical User Interface or by running the following line of code in the command window:

```matlab
setup
```



**Extracting Line Drawings**

The main function for extracting line drawings is "lineDrawingTracing.m". 

*_Please note that the line drawing extraction process can take a while to finish, depending on the image size._*

Example usage:

```
fileName= 'example.jpg';
vecLD = lineDrawingTracing(fileName);
figure;
subplot(1,2,1);
imshow(imread('example.jpg'));
subplot(1,2,2);
drawLinedrawing(vecLD,3,'b');
```

Output:

<img src='images/example_output.png' width=70%> 

Note that the drawLineDrawing takes a LineDrawing (LD) data structure (represented as vecLD in the example above), and draws the outcome with specific line width (3 in the example above) and a chosen color ('b' -> which is for blue in Matlab). 

For a runnable matlab live code (.mlx), please refer to the [script](https://github.com/bwlabToronto/MLV_toolbox/blob/main/Demos/getLineDrawing.mlx). 

**Computing Medial Axis Properties**

<img src='images/medial_axis_transform.png' width=70%> 

Using MLV, one can compute accurate AOF-based medial axis transform (MAT) from binary images. These images can either be rendered from LineDrawing (LD) datastructures (check out renderLinedrawing.m function) or be binary images from other sources. Like the example (bunny) above shows, there are some intermediate steps in the process of extracting MAT, including the extraction of the distance map as well as the extraction of the average outward flux map (AOF). This information along with the skeleton is stored in the MAT computed from a binary image. Please see the following example of a mountain scene where the MAT is computed from the binary image. 

```
img = imread('images/mountain.png');
MAT = computeMAT(img,28);
figure;
subplot(1,2,1);
imshow(img);
subplot(1,2,2);
imshow(imoverlay(rgb2gray(img),MAT.skeleton,'b'))
```

Output:

<img src='images/mountain_example.png' width=70%>

In this example, 28 represents the object angle degree that the medial axis is thresholded at. For further information, please refer to the book: [Medial Representations](https://link.springer.com/book/10.1007/978-1-4020-8658-8). The higher the threshold, the less of medial axis branches are retained in the final representation.

The final MAT includes the following attributes in its data structure: 
- distance_map (step b)
- AOF (step c)
- skeleton (step d)

For a runnable Matlab live code (.mlx) with more examples to run, please refer to the [script](https://github.com/bwlabToronto/MLV_toolbox/blob/main/Demos/getMedialAxis.mlx).



**Computing Contour Properties**

Using the MLV toolbox, there are two major types of contour properties that one can compute:
- Medial-axis based properties
- Contour based properties


To compute medial-axis based properties, the user should first compute MAT representation first and then use the proper needed functions. Take a look at the following block of code as an example. 

```
load('dataSets/TorontoScenes/mountains_vecLD.mat');
cute = vecLD(11);
imgLD = renderLinedrawing(cute);
MAT = computeMAT(imgLD,28);
[MATcontourImages,MATskeletonImages,skeletalBranches]=computeAllMATproperties(MAT,imgLD);
figure;
subplot(1,2,1);
drawMATproperty(MATskeletonImages.mirror);
title('Mirror Symmetry','FontSize',24);
subplot(1,2,2);
drawMATproperty(MATcontourImages.mirror);
title('Mirror Symmetry','FontSize',24);
```

Output:

<img src='images/mountain_mirror_example.png' width=80%> 

As shown above, we see the local mirror symmetry scores on an example LineDrawing (LD) structure, where colors show low to high scores from blue to red respectively. 



**Manipulating Line Drawings**

**Batch Processing**

Will be available in future releases ...

## Datasets


## FAQs

We are working on this section, please make sure to check back here in the future. As of now, please ask your questions on the discussion page of the MLV toolbox available [here](https://github.com/bwlabToronto/MLV_toolbox/discussions). 

## References
