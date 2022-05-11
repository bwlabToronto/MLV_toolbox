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

Using MLV, one can compute accurate AOF-based medial axis transform (MAT) from binary images. These images can either be rendered from LineDrawing (LD) datastructures (check out renderLinedrawing.m function) or be binary images from other sources. As the example (bunny) above shows, there are some intermediate steps in the process of extracting MAT, including the extraction of distance map as well as extraction of the average outward flux map (AOF). These information along with skeleton are stored in the MAT computed from a binary image. Please see the following example of a mountain scene where the MAT is computed from the binary image. 

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
- skeleton 
- distance_map
- AOF

For a runnable matlab live code (.mlx) with more examples to run, please refer to the [script](https://github.com/bwlabToronto/MLV_toolbox/blob/main/Demos/getMedialAxis.mlx).



**Computing Contour Properties**

**Manipulating Line Drawings**

**Batch Processing**

## Datasets


## FAQs

We are working on this section, please make sure to check back here in the future. As of now, please ask your questions in the discussion page of the MLV toolbox available [here](https://github.com/bwlabToronto/MLV_toolbox/discussions). 

## References
