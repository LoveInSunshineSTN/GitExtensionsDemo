%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%生成标签
%%
%直接移植自9月29
clc;clear;close all
path_l=pwd;
savepath=path_l;
loadpath=[path_l,'\atr'];
load seg_names
ls_label=[];%全集标签编号
ls_peak=[];%全集峰值坐标编号
wj=[];%全集所属文件编号
ls_js=1;%临时计数，用于标签号的累加（当ls_str没有该标签时 生成一个新的标签号）
ls_str={[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] []};%第i个元素存储了标签号为i的注释符号
sc1=size(fileNames_seg,1);
for i=1:sc1
    ls_path=[loadpath '\' fileNames_seg{i,1}];
    [~,b,c,~,~,f,~]=textread(ls_path,'%s%d%s%d%d%d%s');%分别读入atr
    ls_pb=zeros(length(b),1);%当前文件下的标签
    for j=1:length(b)
        ls_bs=1;%为0：ls_str里有该标签，为1：无该标签（会被k内的判别置零）
        for k=1:ls_js%判别标签号
            if strcmp(c{j,1},ls_str{1,k})
                ls_pb(j)=k;
                ls_bs=0;
            end
        end
        if ls_bs==1%如果没被置零，则生成一个新类别号
            ls_js=ls_js+1;%新类别号
            ls_pb(j)=ls_js;%新类别号赋值
            ls_str{1,ls_js}=c{j,1};
        end
        
    end
    
    b=b(5:end-3,1);
    ls_pb=ls_pb(5:end-3,1);
    ls_label=[ls_label ls_pb'];
    
    ls_peak=[ls_peak b'];
    ls_wj(1:length(b),1)=i;
    wj=[wj ls_wj'];
    ls_wj=[];
    clear ls_pb;
    
    
    
end
ls_peak=ls_peak-1;%减去一个标志位的漂移
atr_label=[ls_label;ls_peak;wj];
save('atr_label.mat','atr_label')
save('str.mat','ls_str')
load atr_label.mat
rsmp_label = [];
for i = 1:48
    index = find(atr_label(3,:)==i);
    label = atr_label(:,index);
    new_label = label(:,3:end-1);
    rsmp_label = [rsmp_label,new_label];
end
label1 = rsmp_label([1,3],:);
save('label','label1')

%%
%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%生成标签
%%
%直接移植自9月29
clc;clear;close all
path_l='D:\Program Files\MATLAB64\刘通第二篇';
savepath=path_l;
load atr_label.mat
load str.mat
load data_names.mat
sc1=47;
tou=60;
wei=30;

for i=1:sc1
    ls_atr=atr_label;
    ls_atr(:,find(ls_atr(3,:)~=i))=[];%提取序列对应心电信号，将暂时不需要的心电信号置为[]
    load([path_l '\debased\' fileNames_data{i,1}])%load去基线后的心电信号
    seg_h=size(ls_atr,2);%得到不为空的列数
    rsmp1=zeros(seg_h,303);%创建一个空矩阵，行为303
    rsmp2=rsmp1;%同上
    for j=4:seg_h-1
        ls_smp1=ECG1((ls_atr(2,j-1)-tou):(ls_atr(2,j)+wei));%对心电信号进行分割，j=4为例，其分割点为第三个分割点减60和第四个分割点加30，
        ls_smp2=ECG2((ls_atr(2,j-1)-tou):(ls_atr(2,j)+wei));%同上
        ls_rsmp1=resample(ls_smp1,300,size(ls_smp1,2));  %每个心跳的重采样点
        ls_rsmp2=resample(ls_smp2,300,size(ls_smp2,2));
        rsmp1(j-3,1:300)=ls_rsmp1;
        rsmp2(j-3,1:300)=ls_rsmp2;
        rsmp1(j-3,301)=ls_atr(2,j)-ls_atr(2,j-1);%采样点差，可以理解为rr间期
        rsmp1(j-3,302)=ls_atr(1,j-1);%前一个r峰对应的心拍标号
        rsmp1(j-3,303)=ls_atr(1,j);%当前r峰对应的心拍标号

      
       
    end
        if i<10
        save([savepath,'\rsmp\0',num2str(i),'rsmp.mat'],'rsmp1','rsmp2');
    else
        save([savepath,'\rsmp\',num2str(i),'rsmp.mat'],'rsmp1','rsmp2');%存储分割后的矩阵
    end
         disp(['完成了第' num2str(i) '组心电图'])
        
        
        
    
    
    
    
    
end
jishu=0;
fileFolder=fullfile([path_l '\rsmp']);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames_rsmp={dirOutput.name}';%文件名cell

for i=1:sc1
    load([path_l '\rsmp\' fileNames_rsmp{i,1}])
    jishu=jishu+size(rsmp1,1);
end
features=zeros(jishu,303);
save features.mat features
%%


%clc;clear;close all
%path_l='D:\Program Files\MATLAB64\刘通第二篇';

%load features.mat  %全0尺寸相当的features，用于存储所有心拍的特征
%fileFolder=fullfile([path_l '\rsmp']);
%dirOutput=dir(fullfile(fileFolder,'*.mat'));
%fileNames_rsmp={dirOutput.name}';%文件名cell
%jishu=0;
%for i=1:47
%    load([path_l '\rsmp\' fileNames_rsmp{i,1}])
%    ls1=size(rsmp1,1);
%    features(jishu+1:jishu+ls1,:)=rsmp1;
%    jishu=jishu+ls1
%end

% %匹配atr和seg
% clc;clear;close all
% load atr_label
% path_l='D:\Program Files\MATLAB64\刘通信号';
% savepath=path_l;
% loadpath=[path_l,'\seg_h'];
% 
% fileFolder=fullfile(loadpath);
% dirOutput=dir(fullfile(fileFolder,'*.mat'));
% fileNames_seg={dirOutput.name}';%文件名cell
% label=[];
% for i=1:size(fileNames_seg,1)%对文件循环，因为seg保存为每个ecg的mat文件
%     load([loadpath '\' fileNames_seg{i,1}]);
%     load atr_label
%     atr_label(:,all(atr_label(3,:)~=i,1))=[];%摘出当前seg下的atr
%  
%     ls_label_data=zeros(size(seg_h,1),1);%预生成每个ecg的类别标签
%     ls_mot1=zeros(size(seg_h,1),6);        %预生成每个ecg的mot特征
%     ls_mot2=zeros(size(seg_h,1),6);        %预生成每个ecg的mot特征
%     for j=1:size(seg_h,1)                 %对心跳循环
%         
%         ls_label=atr_label;                  %atr转存一下
%         ls_label(2,:)=abs(ls_label(2,:)-seg_h(j,5));
%         [~,b]=min(ls_label(2,:));                       %以上两行对atr和seg进行匹配
%         ls_label_data(j,1)=ls_label(1,b);               %这个是储存当个心跳的label
%         ls_pt_dur=seg_h(j,4)-seg_h(j,3);               %pt持续时间
%         ls_qrs_dur=seg_h(j,6)-seg_h(j,4);                 %qrs持续时间
%         ls_st_dur=seg_h(j,6)-seg_h(j,4);                   %st持续时间
%         %%
%         
%         
%         
%         
%         
%         ls_rr_pro=0;                                   %往前一个rr间期
%         ls_rr_pos=0;                                   %往后一个rr间期
%         if b>1&&b<size(atr_label,2)-1
%             ls_rr_pro=atr_label(2,b+1)-atr_label(2,b);
%             ls_rr_pos=atr_label(2,b)-atr_label(2,b-1);
%         end
%         %%
%         ls_mot1(j,1)=ls_qrs_dur;                          
%         ls_mot1(j,2)=ls_rr_pro;
%         ls_mot1(j,3)=ls_rr_pos;
%         ls_mot1(j,4)=ls_pt_dur;
%         ls_mot1(j,5)=ls_st_dur;
%         if j>10
%             ls_mot1(j,6)=mean(ls_mot1(j-9:j,2));
%         else
%             ls_mot1(j,6)=mean(ls_mot1(1:j,2));
%         end
%     end
%     label=ls_label_data;
%     mot=ls_mot1;
% %     mot(1:10,:)=[];
%     if i<10
%         save([savepath,'\mot_l\0',num2str(i),'mot.mat'],'mot')
%         save([savepath,'\label_l\0',num2str(i),'label.mat'],'label')
%     else
%         save([savepath,'\mot_l\',num2str(i),'mot.mat'],'mot')
%         save([savepath,'\label_l\',num2str(i),'label.mat'],'label')
%     end
%     
%     
% end
% %%
% % for i=1:size(fileNames_seg,1)%对seg循环，因为seg保存为每个ecg的mat文件
% %     load([loadpath '\' fileNames_seg{i,1}]);
% %     load atr_label
% %     atr_label(:,all(atr_label(3,:)~=i,1))=[];%摘出当前seg下的atr
% %     ls_label_data=zeros(size(seg_h,2),1);%预生成每个ecg的类别标签
% %     for j=1:size(seg_h,2)
% %
% %         ls_label=atr_label;                  %atr转存一下
% %         ls_label(2,:)=abs(ls_label(2,:)-seg_h(7,j));
% %         [~,b]=min(ls_label(2,:));                       %以上两行对atr和seg进行匹配
% %         ls_label_data(j,1)=ls_label(1,b);
% %     end
% %     label=[label;ls_label_data];
% % end
% % save('label.mat','label')
% %
