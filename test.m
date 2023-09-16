clear all;
close all;
clc
im = imread(uigetfile('.bmp'));
k = 2;

%����ͳ��ͼ��ֱ��ͼ��Ϣ����
img_hist = zeros(256,1);
hist_value = zeros(256,1);

%ͳ��ֱ��ͼ��ͬ�Ҷȶ�Ӧ�����ظ���
for i=1:256
	img_hist(i)=sum(sum(im==(i-1)));
end;
for i=1:256
	hist_value(i)=i-1;
end;

%��������ʼ��
cluster = zeros(k,1);%���������
cluster_count = zeros(k,1);%����������ͳ��
for i=1:k
	cluster(i)=uint8(rand*255);
end;

old = zeros(k,1);%old��ŵ���ǰ������
%������ֹ����
while (sum(sum(abs(old-cluster))) >1e-6)
	old = cluster;
	closest_cluster = zeros(256,1);
    %��ʼ��mindistance��������лҶȼ�������1�ľ���
	min_distance = uint8(zeros(256,1));
	min_distance = abs(hist_value-cluster(1));

	%��¼ÿ���Ҷȼ����Լ����������С����
	for i=2:k
		min_distance =min(min_distance,  abs(hist_value-cluster(i)));
	end;

	%ȷ��ÿ���Ҷȼ�����������
	for i=1:k
		closest_cluster(min_distance==(abs(hist_value-cluster(i)))) = i;
	end;

	%�������������
	for i=1:k
		cluster_count(i) = sum(img_hist .*(closest_cluster==i));
	end;

    %��������
	for i=1:k
		if (cluster_count(i) == 0)
			cluster(i) = uint8(rand*255);
		else
			cluster(i) = uint8(sum(img_hist(closest_cluster==i).*hist_value(closest_cluster==i))/cluster_count(i));
        end;
	end;
    
    %Ϊͼ�����ÿ���Ҷȼ������������������
	imresult=uint8(zeros(size(im)));
    for i=1:256
        imresult(im==(i-1))=cluster(closest_cluster(i));
    end;
    
    %��ÿ���Ҷȼ���Ӧ��������ǩ
    clustersresult=uint8(zeros(size(im)));
    for i=1:256
        clustersresult(im==(i-1))=closest_cluster(i);
    end;
    
    %��ÿ�ε����������չʾ
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


