%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ɱ�ǩ
%%
%ֱ����ֲ��9��29
clc;clear;close all
path_l=pwd;
savepath=path_l;
loadpath=[path_l,'\atr'];
load seg_names
ls_label=[];%ȫ����ǩ���
ls_peak=[];%ȫ����ֵ������
wj=[];%ȫ�������ļ����
ls_js=1;%��ʱ���������ڱ�ǩ�ŵ��ۼӣ���ls_strû�иñ�ǩʱ ����һ���µı�ǩ�ţ�
ls_str={[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] []};%��i��Ԫ�ش洢�˱�ǩ��Ϊi��ע�ͷ���
sc1=size(fileNames_seg,1);
for i=1:sc1
    ls_path=[loadpath '\' fileNames_seg{i,1}];
    [~,b,c,~,~,f,~]=textread(ls_path,'%s%d%s%d%d%d%s');%�ֱ����atr
    ls_pb=zeros(length(b),1);%��ǰ�ļ��µı�ǩ
    for j=1:length(b)
        ls_bs=1;%Ϊ0��ls_str���иñ�ǩ��Ϊ1���޸ñ�ǩ���ᱻk�ڵ��б����㣩
        for k=1:ls_js%�б��ǩ��
            if strcmp(c{j,1},ls_str{1,k})
                ls_pb(j)=k;
                ls_bs=0;
            end
        end
        if ls_bs==1%���û�����㣬������һ��������
            ls_js=ls_js+1;%������
            ls_pb(j)=ls_js;%�����Ÿ�ֵ
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
ls_peak=ls_peak-1;%��ȥһ����־λ��Ư��
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
%���ɱ�ǩ
%%
%ֱ����ֲ��9��29
clc;clear;close all
path_l='D:\Program Files\MATLAB64\��ͨ�ڶ�ƪ';
savepath=path_l;
load atr_label.mat
load str.mat
load data_names.mat
sc1=47;
tou=60;
wei=30;

for i=1:sc1
    ls_atr=atr_label;
    ls_atr(:,find(ls_atr(3,:)~=i))=[];%��ȡ���ж�Ӧ�ĵ��źţ�����ʱ����Ҫ���ĵ��ź���Ϊ[]
    load([path_l '\debased\' fileNames_data{i,1}])%loadȥ���ߺ���ĵ��ź�
    seg_h=size(ls_atr,2);%�õ���Ϊ�յ�����
    rsmp1=zeros(seg_h,303);%����һ���վ�����Ϊ303
    rsmp2=rsmp1;%ͬ��
    for j=4:seg_h-1
        ls_smp1=ECG1((ls_atr(2,j-1)-tou):(ls_atr(2,j)+wei));%���ĵ��źŽ��зָj=4Ϊ������ָ��Ϊ�������ָ���60�͵��ĸ��ָ���30��
        ls_smp2=ECG2((ls_atr(2,j-1)-tou):(ls_atr(2,j)+wei));%ͬ��
        ls_rsmp1=resample(ls_smp1,300,size(ls_smp1,2));  %ÿ���������ز�����
        ls_rsmp2=resample(ls_smp2,300,size(ls_smp2,2));
        rsmp1(j-3,1:300)=ls_rsmp1;
        rsmp2(j-3,1:300)=ls_rsmp2;
        rsmp1(j-3,301)=ls_atr(2,j)-ls_atr(2,j-1);%�������������Ϊrr����
        rsmp1(j-3,302)=ls_atr(1,j-1);%ǰһ��r���Ӧ�����ı��
        rsmp1(j-3,303)=ls_atr(1,j);%��ǰr���Ӧ�����ı��

      
       
    end
        if i<10
        save([savepath,'\rsmp\0',num2str(i),'rsmp.mat'],'rsmp1','rsmp2');
    else
        save([savepath,'\rsmp\',num2str(i),'rsmp.mat'],'rsmp1','rsmp2');%�洢�ָ��ľ���
    end
         disp(['����˵�' num2str(i) '���ĵ�ͼ'])
        
        
        
    
    
    
    
    
end
jishu=0;
fileFolder=fullfile([path_l '\rsmp']);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames_rsmp={dirOutput.name}';%�ļ���cell

for i=1:sc1
    load([path_l '\rsmp\' fileNames_rsmp{i,1}])
    jishu=jishu+size(rsmp1,1);
end
features=zeros(jishu,303);
save features.mat features
%%


%clc;clear;close all
%path_l='D:\Program Files\MATLAB64\��ͨ�ڶ�ƪ';

%load features.mat  %ȫ0�ߴ��൱��features�����ڴ洢�������ĵ�����
%fileFolder=fullfile([path_l '\rsmp']);
%dirOutput=dir(fullfile(fileFolder,'*.mat'));
%fileNames_rsmp={dirOutput.name}';%�ļ���cell
%jishu=0;
%for i=1:47
%    load([path_l '\rsmp\' fileNames_rsmp{i,1}])
%    ls1=size(rsmp1,1);
%    features(jishu+1:jishu+ls1,:)=rsmp1;
%    jishu=jishu+ls1
%end

% %ƥ��atr��seg
% clc;clear;close all
% load atr_label
% path_l='D:\Program Files\MATLAB64\��ͨ�ź�';
% savepath=path_l;
% loadpath=[path_l,'\seg_h'];
% 
% fileFolder=fullfile(loadpath);
% dirOutput=dir(fullfile(fileFolder,'*.mat'));
% fileNames_seg={dirOutput.name}';%�ļ���cell
% label=[];
% for i=1:size(fileNames_seg,1)%���ļ�ѭ������Ϊseg����Ϊÿ��ecg��mat�ļ�
%     load([loadpath '\' fileNames_seg{i,1}]);
%     load atr_label
%     atr_label(:,all(atr_label(3,:)~=i,1))=[];%ժ����ǰseg�µ�atr
%  
%     ls_label_data=zeros(size(seg_h,1),1);%Ԥ����ÿ��ecg������ǩ
%     ls_mot1=zeros(size(seg_h,1),6);        %Ԥ����ÿ��ecg��mot����
%     ls_mot2=zeros(size(seg_h,1),6);        %Ԥ����ÿ��ecg��mot����
%     for j=1:size(seg_h,1)                 %������ѭ��
%         
%         ls_label=atr_label;                  %atrת��һ��
%         ls_label(2,:)=abs(ls_label(2,:)-seg_h(j,5));
%         [~,b]=min(ls_label(2,:));                       %�������ж�atr��seg����ƥ��
%         ls_label_data(j,1)=ls_label(1,b);               %����Ǵ��浱��������label
%         ls_pt_dur=seg_h(j,4)-seg_h(j,3);               %pt����ʱ��
%         ls_qrs_dur=seg_h(j,6)-seg_h(j,4);                 %qrs����ʱ��
%         ls_st_dur=seg_h(j,6)-seg_h(j,4);                   %st����ʱ��
%         %%
%         
%         
%         
%         
%         
%         ls_rr_pro=0;                                   %��ǰһ��rr����
%         ls_rr_pos=0;                                   %����һ��rr����
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
% % for i=1:size(fileNames_seg,1)%��segѭ������Ϊseg����Ϊÿ��ecg��mat�ļ�
% %     load([loadpath '\' fileNames_seg{i,1}]);
% %     load atr_label
% %     atr_label(:,all(atr_label(3,:)~=i,1))=[];%ժ����ǰseg�µ�atr
% %     ls_label_data=zeros(size(seg_h,2),1);%Ԥ����ÿ��ecg������ǩ
% %     for j=1:size(seg_h,2)
% %
% %         ls_label=atr_label;                  %atrת��һ��
% %         ls_label(2,:)=abs(ls_label(2,:)-seg_h(7,j));
% %         [~,b]=min(ls_label(2,:));                       %�������ж�atr��seg����ƥ��
% %         ls_label_data(j,1)=ls_label(1,b);
% %     end
% %     label=[label;ls_label_data];
% % end
% % save('label.mat','label')
% %
