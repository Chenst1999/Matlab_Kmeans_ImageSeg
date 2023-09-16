clear all
clc
img = imread(uigetfile('.bmp'));
k = 3;
[clusters, result_image, clusterized_image] = kmeansclustering(img,k);

imshow(result_image);
imshow(label2rgb(clusterized_image));












