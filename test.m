clear all;
close all;
clc
im = imread(uigetfile('.bmp'));
k = 2;

%定义统计图像直方图信息变量
img_hist = zeros(256,1);
hist_value = zeros(256,1);

%统计直方图不同灰度对应的像素个数
for i=1:256
	img_hist(i)=sum(sum(im==(i-1)));
end;
for i=1:256
	hist_value(i)=i-1;
end;

%聚类类别初始化
cluster = zeros(k,1);%聚类的质心
cluster_count = zeros(k,1);%聚类类别个数统计
for i=1:k
	cluster(i)=uint8(rand*255);
end;

old = zeros(k,1);%old存放迭代前的质心
%迭代终止条件
while (sum(sum(abs(old-cluster))) >1e-6)
	old = cluster;
	closest_cluster = zeros(256,1);
    %初始化mindistance，存放所有灰度级到质心1的距离
	min_distance = uint8(zeros(256,1));
	min_distance = abs(hist_value-cluster(1));

	%记录每个灰度级到自己所属类的最小距离
	for i=2:k
		min_distance =min(min_distance,  abs(hist_value-cluster(i)));
	end;

	%确定每个灰度级所属类别序号
	for i=1:k
		closest_cluster(min_distance==(abs(hist_value-cluster(i)))) = i;
	end;

	%计算该类别的数量
	for i=1:k
		cluster_count(i) = sum(img_hist .*(closest_cluster==i));
	end;

    %更新质心
	for i=1:k
		if (cluster_count(i) == 0)
			cluster(i) = uint8(rand*255);
		else
			cluster(i) = uint8(sum(img_hist(closest_cluster==i).*hist_value(closest_cluster==i))/cluster_count(i));
        end;
	end;
    
    %为图像分配每个灰度级所处坐标的最终质心
	imresult=uint8(zeros(size(im)));
    for i=1:256
        imresult(im==(i-1))=cluster(closest_cluster(i));
    end;
    
    %对每个灰度级对应坐标分配标签
    clustersresult=uint8(zeros(size(im)));
    for i=1:256
        clustersresult(im==(i-1))=closest_cluster(i);
    end;
    
    %对每次迭代结果进行展示
    result_image=uint8(zeros(size(im)));
    for i = 1:128
        for j = 1:128
            if clustersresult(i,j)==1
                result_image(i,j)=0;
            else
                result_image(i,j)=255;
            end
        end
    end
    
    result_image = uint8(result_image);
    figure
    subplot(1,2,1);
    imshow(im);
    subplot(1,2,2);
    imshow(result_image);
end


