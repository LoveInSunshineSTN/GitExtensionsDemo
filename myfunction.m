function y = myfunction(input_number)
% 编码对应
number = input_number;%input_number;   
loadpath = pwd;
C = {'100','101','102','103','104','105','106','107','108',...
    '109','111','112','113','114','115','116','117',...
    '118','119','121','122','123','124','200','201',...
    '202','203','205','207','208','209','210','212',...
    '213','214','215','217','219','220','221','222',...
    '223','228','230','231','232','233','234'};
D = [25,25,0,25,0,25,25,0,25,25,30,30,30,30,30,30,30,30,30,25,25,25,25,25,25,25,25,25,25,25,...
    8,34,40,26,15,35,0,20,10,20,0,0,0,26,25,25,25,25];
if (number > 1054)||(number<1)
    disp('编号超出数据范围')
    return
else    
    acm = D(1);
    ini = 1;
    while (number>acm)
        acm = acm + D(ini+1);
        ini = ini + 1;
    end
    name_sig = cell2mat(C(ini));
    ord = number - acm + D(ini);
    strord = num2str(ord);
    path = [loadpath,'\样本','\',name_sig,'\',strord,'.mat'];
    load(path);
end
% 显示波段
plot(0:val(end)-val(end-1),val(1:end-2));
grid on;
hold on; 
pause;
% 检测并显示R波顶点
load('combine.mat')
temp_a = find(combine(:,3) == ini);
index_point = find(val(end-1)<=combine(temp_a,1) & combine(temp_a,1)<=val(end));
a = combine(temp_a,1);
rr_point = a(index_point);
plot(rr_point-val(end-1),val(rr_point-val(end-1)),'or')
title('R波检测结果')
txt_con = [num2str(number),'号信号中R波个数为',num2str(size(rr_point,1))];
xlabel(txt_con)
pause


% 类别判定
load('final_label')
load('atr_label')
load('combine_feature')
data = combine_feature(:,1:end-3);
[gy,ps]=mapminmax(data',0,1);
gy = gy';
feature1 = gy(temp_a,:);
test_feature = feature1(index_point,:);

index1 = find(atr_label(3,:)==ini);
str_cmid = atr_label(:,index1);
index2 = find(val(end-1)<=str_cmid(2,:) & str_cmid(2,:)<=val(end));
str_com1 = str_cmid(1,index2);
str_fmid = final_label(temp_a,2);
str_final1 = str_fmid(index_point);
%预测
load('model1.mat')
load('model3.mat')
load('model4.mat')
load('model5.mat')
%%
%第一次预测
label = ones(size(str_final1,1),1);
index_v1 = find(str_final1==4);
label(index_v1) = 4;
[pre_label1,accuracy1,dec_values1] = svmpredict(label,test_feature,model1);
disp('第一次预测结果：')
disp(pre_label1')
pause
%第二次预测
index_a1 = find(pre_label1==4);
test_feature(index_a1,:) = [];
ac_label = str_final1;
ac_label(index_a1) = [];
index_v2 = find(ac_label == 17);
label = ones(size(ac_label,1),1);
label(index_v2) = 17;
[pre_label2,accuracy2,dec_values2] = svmpredict(label,test_feature,model3);
disp('第二次预测结果：')
disp(pre_label2')
pause
%第三次预测
index_a2 = find(pre_label2==17);
test_feature(index_a2,:) = [];
ac_label(index_a2) = [];
index_v3 = find(ac_label == 3);
label = ones(size(ac_label,1),1);
label(index_v3) = 3;
[pre_label3,accuracy3,dec_values3] = svmpredict(label,test_feature,model4);
disp('第三次预测结果：')
disp(pre_label3')
pause
%第四次预测
index_a3 = find(pre_label3==3);
test_feature(index_a3,:) = [];
ac_label(index_a3) = [];
index_v3 = find(ac_label == 14);
label = ones(size(ac_label,1),1);
label(index_v3) = 14;
[pre_label4,accuracy4,dec_values4] = svmpredict(label,test_feature,model5);
disp('第四次预测结果：')
disp(pre_label4')
pause
%%
%显示结果
for i = 1:size(str_com1,2)
    if str_final1(i) == 14
        str_final1(i) = 8;
    elseif str_final1(i) == 17
        str_final1(i) = 9;
    end
    if str_com1(i) == 14
        str_com1(i) = 8;
    elseif str_com1(i) == 17
        str_com1(i) = 9;
    end
end
str_final = num2str(str_final1);
str_com = num2str(str_com1');
for i = 1:size(rr_point,1)
    if str_final(i) == '3'
        str_final(i) = 'N';
    elseif str_final(i) == '4'
        str_final(i) = 'A';
    elseif str_final(i) == '5'
        str_final(i) = 'V';
    elseif str_final(i) == '8'
        str_final(i) = 'L';
    elseif str_final(i) == '9'
        str_final(i) = 'R';
    end
    if str_com(i) == '3'
        str_com(i) = 'N';
    elseif str_com(i) == '4'
        str_com(i) = 'A';
    elseif str_com(i) == '5'
        str_com(i) = 'V';
    elseif str_com(i) == '8'
        str_com(i) = 'L';
    elseif str_com(i) == '9'
        str_com(i) = 'R';
    end
end
num_N = size(find(str_final=='N'),1);
num_A = size(find(str_final=='A'),1);
num_V = size(find(str_final=='V'),1);
num_L = size(find(str_final=='L'),1);
num_R = size(find(str_final=='R'),1);
title(['信号实际标签为：',str_com'])
text(rr_point-val(end-1),val(rr_point-val(end-1)),str_final)
txt_tent = {['信号检测结果:','其中有',num2str(num_N),'个正常心拍(N); ',...
    num2str(num_A),'个房性早搏心拍(A); ',num2str(num_V),'个室性早搏心拍(V);'];[ num2str(num_L),'个左束支传导阻滞心拍(L); ',...
    num2str(num_R),'个右束支传导阻滞心拍(R)']};
xlabel(txt_tent)


% load ('combine_feature.mat')
% load ('n.mat')
% data = combine_feature(:,1:end-3);
% [gy,ps]=mapminmax(data',0,1);
% gy = gy';
% train_data = gy(n,:);
% train_label = combine_feature(n,494);
% T_number = [1:size(gy,1)]';
% Test_data = [gy,T_number];
% 
% label = ones(size(train_label,1),1);
% n4 = find(train_label==4);
% label(n4) = 4;
% %[bestacc,bestc,bestg]=svmcgforclass(label,train_data,-10,10,-10,10,5,2,2);
% model1=svmtrain(label,train_data,'-c 4 -g 1');%此处参数应根据实际寻优结果来设置，不可根据我之前设置参数设置
% %save('model1','model1')
% 
% % label(n4)=[];
% % train_data(n4,:)=[];
% % train_label(n4,:)=[];
% % n9 = find(train_label==9);
% % label(n9) = 9;
% % %[bestacc,bestc,bestg]=svmcgforclass(label,train_data,-10,10,-10,10,5,2,2);
% % model2=svmtrain(label,train_data,'-c 64 -g 0.015625');
% % save('model2','model2')
% 
% label(n4)=[];
% train_data(n4,:)=[];
% train_label(n4,:)=[];
% n17 = find(train_label==17);
% label(n17) = 17;
% %[bestacc,bestc,bestg]=svmcgforclass(label,train_data,-10,10,-10,10,5,2,2);
% model3=svmtrain(label,train_data,'-c 4 -g 1');
% %save('model3','model3')
% 
% label(n17)=[];
% train_data(n17,:)=[];
% train_label(n17,:)=[];
% n3 = find(train_label==3);
% label(n3) = 3;
% %[bestacc,bestc,bestg]=svmcgforclass(label,train_data,-10,10,-10,10,5,2,2);
% model4=svmtrain(label,train_data,'-c 4 -g 1');
% %save('model4','model4')
% 
% label(n3)=[];
% train_data(n3,:)=[];
% train_label(n3,:)=[];
% n14 = find(train_label==14);
% label(n14) = 14;
% %[bestacc,bestc,bestg]=svmcgforclass(label,train_data,-10,10,-10,10,5,2,2);
% model5=svmtrain(label,train_data,'-c 1 -g 1');
% %save('model5','model5')
% 
% newlabel = ones(size(combine_feature,1),1);
% actual_label = combine_feature(:,494);
% m4 = find(actual_label==4);
% label(m4) = 4;
% [pre_label1,accuracy1,dec_values1] = svmpredict(newlabel,gy,model1); 
% disp(['第一个SVM预测准确率为',num2str(accuracy1(1)),'%'])
% 
% a4 = find(pre_label1==4);
% newlabel = ones((size(combine_feature,1)-size(a4,1)),1);
% P_number1 = T_number(a4,:);
% T_number(a4,:)=[];
% gy(a4,:)=[];%数据集合中除去分为4的数据
% actual_label(a4)=[];%标签集合中除去相应的标签
% m17 = find(actual_label == 17);
% newlabel(m17) = 17;
% [pre_label2,accuracy2,dec_values2] = svmpredict(newlabel,gy,model3);
% disp(['第二个SVM预测准确率为',num2str(accuracy2(1)),'%'])
% 
% a17 = find(pre_label2==17);
% newlabel = ones((size(combine_feature,1)-size(a4,1)-size(a17,1)),1);
% P_number2 = T_number(a17,:);
% T_number(a17,:)=[];
% gy(a17,:)=[];
% actual_label(a17)=[];
% m3 = find(actual_label == 3);
% newlabel(m3) = 3;
% [pre_label3,accuracy3,dec_values3] = svmpredict(newlabel,gy,model4);
% disp(['第三个SVM预测准确率为',num2str(accuracy3(1)),'%'])
% 
% a3 = find(pre_label3==3);
% newlabel = ones((size(combine_feature,1)-size(a4,1)-size(a17,1)-size(a3,1)),1);
% P_number3 = T_number(a3,:);
% T_number(a3,:)=[];
% gy(a3,:)=[];
% actual_label(a3)=[];
% m14 = find(actual_label == 14);
% newlabel(m14) = 14;
% [pre_label4,accuracy4,dec_values4] = svmpredict(newlabel,gy,model5);
% disp(['第四个SVM预测准确率为',num2str(accuracy4(1)),'%'])
% 
% a14 = find(pre_label4==14);
% P_number4 = T_number(a14,:);
% T_number(a14,:)=[];
% P_number5 = T_number;
% 
% label1 = [P_number1,ones(size(P_number1,1),1)*4];
% label2 = [P_number2,ones(size(P_number2,1),1)*17];
% label3 = [P_number3,ones(size(P_number3,1),1)*3];
% label4 = [P_number4,ones(size(P_number4,1),1)*14];
% label5 = [P_number5,ones(size(P_number5,1),1)*5];
% label = [label1;label2;label3;label4;label5];
% final_label = sortrows(label,1);
% com_label = combine_feature(:,494);
% a = sum(final_label(:,2)==com_label);
% final_acc = (a/99997)*100;
% disp(['统计后，总样本数目为99997,正确识别数目为95523'])
% disp(['心拍5分类最终预测准确率为',num2str(final_acc),'%'])
% 
% N = [1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,...
%     29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48];
% count = N(ini);
% temp_a = find(combine_feature(:,495)==count);
% label_matrix = [final_label(temp_a,2),com_label(temp_a),combine_feature(temp_a,493)];
% for i = 1:size(temp_a,1)
%     if label_matrix(i,2) == 14
%         label_matrix(i,2) = 8;
%     elseif label_matrix(i,2) == 17
%         label_matrix(i,2) = 9
%     end
%     if label_matrix(i,1) == 14
%         label_matrix(i,1) = 8;
%     elseif label_matrix(i,1) == 17
%         label_matrix(i,1) = 9;
%     end
% end
% str_final = num2str(label_matrix(:,1));
% str_com = num2str(label_matrix(:,2));
% 
% for i = 1:size(temp_a,1)
%     if str_final(i) == '3'
%         str_final(i) = 'N';
%     elseif str_final(i) == '4'
%         str_final(i) = 'A';
%     elseif str_final(i) == '5'
%         str_final(i) = 'V';
%     elseif str_final(i) == '8'
%         str_final(i) = 'L';
%     elseif str_final(i) == '9'
%         str_final(i) = 'R'
%     end
%     if str_com(i) == '3'
%         str_com(i) = 'N';
%     elseif str_com(i) == '4'
%         str_com(i) = 'A';
%     elseif str_com(i) == '5'
%         str_com(i) = 'V';
%     elseif str_com(i) == '8'
%         str_com(i) = 'L';
%     elseif str_com(i) == '9'
%         str_com(i) = 'R'
%     end
% end
% temp_b = find(arr_sec(1)<label_matrix(:,3) & label_matrix(:,3)<arr_sec(size(arr_sec,2)));
% num_N = size(find(str_final(temp_b)=='N'),1);
% num_A = size(find(str_final(temp_b)=='A'),1);
% num_V = size(find(str_final(temp_b)=='V'),1);
% num_L = size(find(str_final(temp_b)=='L'),1);
% num_R = size(find(str_final(temp_b)=='R'),1);
% figure
% plot([arr_sec(1):arr_sec(size(arr_sec,2))],ECG1(arr_sec(1):arr_sec(size(arr_sec,2))));
% hold on; grid on
% plot(label_matrix(temp_b,3),ECG1(label_matrix(temp_b,3)),'or')
% text(label_matrix(temp_b,3)+10,ECG1(label_matrix(temp_b,3)),str_final(temp_b))
% title(['第',num2str(number),'号信号实际标签为：',str_com(temp_b)'])
% txt_tent = ['第',num2str(number),'号信号检测结果:','其中有',num2str(num_N),'个正常心拍(N); ',...
%     num2str(num_A),'个房性早搏心拍(A); ',num2str(num_V),'个室性早搏心拍(V); ',num2str(num_L),'个左束支传导阻滞心拍(L); ',...
%     num2str(num_R),'个右束支传导阻滞心拍(R)'];
% xlabel(txt_tent)
% 
% % plot(1000:2500,ECG1(1000:2500));
% % hold on
% % title(['20号信号R波检测结果'])
% % txt_con = ['R波检测结果：R波个数为5'];
% xlabel(txt_con)
% figure
% plot(300:1000,ECG1(300:1000));
% hold on
% title(['70号信号R波检测结果'])
% txt_con = ['R波检测结果：R波个数为5'];
% xlabel(txt_con)
%%示例结果
% disp(['以100号信号为例'])
% temp_a1 = find(combine_feature(:,495)==1);
% label_matrix = [final_label(temp_a1,2),com_label(temp_a1),combine_feature(temp_a1,493)];
% load('100m.mat')
% str_com = num2str(label_matrix(:,2));
% for i = 1:2271
%     if str_com(i) == '3'
%     str_com(i) = 'N';
%     end
% end
% str_final = num2str(label_matrix(:,1));
% for i = 1:2271
%     if str_final(i) == '3'
%         str_final(i) = 'N';
%     end
% end
% temp_b1 = find(label_matrix(:,3)>5000 & label_matrix(:,3)<10000);
% 
% figure
% subplot(2,1,1)
% plot([5000:10000],ECG1(5000:10000));
% hold on; grid on
% plot(label_matrix(temp_b1,3),ECG1(label_matrix(temp_b1,3)),'or')
% text(label_matrix(temp_b1,3)+10,ECG1(label_matrix(temp_b1,3)),str_com(temp_b1))
% title('100号信号实际标签')
% subplot(2,1,2)
% plot([5000:10000],ECG1(5000:10000));
% hold on; grid on
% plot(label_matrix(temp_b1,3),ECG1(label_matrix(temp_b1,3)),'or')
% text(label_matrix(temp_b1,3)+10,ECG1(label_matrix(temp_b1,3)),str_final(temp_b1))
% title('100号信号检测结果')
% pause
% 
% disp(['以111号信号为例'])
% temp_a2 = find(combine_feature(:,495)==11);
% label_matrix = [final_label(temp_a2,2),com_label(temp_a2),combine_feature(temp_a2,493)];
% load('111m.mat')
% str_com1 = label_matrix(:,2);
% for i = 1:size(temp_a2,1)
%     if str_com1(i) == 14
%       str_com1(i) = 8;
%     end
% end
% str_com1 = num2str(str_com1);
% for i = 1:size(temp_a2,1)
%     if str_com1(i) == '8'
%       str_com1(i) = 'L';
%     end
% end
% str_final1 = label_matrix(:,1);
% for i = 1:size(temp_a2,1)
%     if str_final1(i) == 14
%         str_final1(i) = 8;
%     end
% end
% str_final1 = num2str(str_final1);
% for i = 1:size(temp_a2,1)
%     if str_final1(i) == '8'
%       str_final1(i) = 'L';
%     end
% end
% temp_b2 = find(label_matrix(:,3)>5000 & label_matrix(:,3)<10000);
% figure
% subplot(2,1,1)
% plot([5000:10000],ECG1(5000:10000));
% hold on; grid on
% plot(label_matrix(temp_b2,3),ECG1(label_matrix(temp_b2,3)),'or')
% text(label_matrix(temp_b2,3)+10,ECG1(label_matrix(temp_b2,3)),str_com1(temp_b2))
% title('111号信号实际标签')
% subplot(2,1,2)
% plot([5000:10000],ECG1(5000:10000));
% hold on; grid on
% plot(label_matrix(temp_b2,3),ECG1(label_matrix(temp_b2,3)),'or')
% text(label_matrix(temp_b2,3)+10,ECG1(label_matrix(temp_b2,3)),str_final1(temp_b2))
% title('111号信号检测结果')
% pause
% 
% disp(['以233号信号为例'])
% temp_a3 = find(combine_feature(:,495)==47);
% label_matrix = [final_label(temp_a3,2),com_label(temp_a3),combine_feature(temp_a3,493)];
% load('233m.mat')
% str_com3 = num2str(label_matrix(:,2));
% for i = 1:size(temp_a3,1)
%     if str_com3(i) == '3'
%     str_com3(i) = 'N';
%     elseif  str_com3(i) == '5'
%         str_com3(i) = 'V';
%     end
% end
% str_final3 = num2str(label_matrix(:,1));
% for i = 1:size(temp_a3,1)
%     if str_final3(i) == '3'
%         str_final3(i) = 'N';
%     elseif str_final3(i) == '5'
%         str_final3(i) = 'V';
%     end
% end
% temp_b3 = find(label_matrix(:,3)>1 & label_matrix(:,3)<5000);
% figure
% subplot(2,1,1)
% plot([1:5000],ECG1(1:5000));
% hold on; grid on
% plot(label_matrix(temp_b3,3),ECG1(label_matrix(temp_b3,3)),'or')
% text(label_matrix(temp_b3,3)+10,ECG1(label_matrix(temp_b3,3)),str_com3(temp_b3))
% title('233号信号实际标签')
% subplot(2,1,2)
% plot([1:5000],ECG1(1:5000));
% hold on; grid on
% plot(label_matrix(temp_b3,3),ECG1(label_matrix(temp_b3,3)),'or')
% text(label_matrix(temp_b3,3)+10,ECG1(label_matrix(temp_b3,3)),str_final3(temp_b3))
% title('233号信号检测结果')


   
%end
