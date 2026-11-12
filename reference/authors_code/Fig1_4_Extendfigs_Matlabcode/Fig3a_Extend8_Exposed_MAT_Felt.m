%% calculating Mean Annual Temprature felt by an average person, 
%% and population exposed to Mean Annual Temperature > 20 C (Matlab 2021b)

clear;
folder = fileparts(matlab.desktop.editor.getActiveFilename); 
addpath(genpath(folder));
load 'displacement_data.mat';

%% Section 1: MAT felt by an average person: current and future (SSPs)

%%%%% population 6.9 billion (2010) 
pop_use = popcount2010;
% 1.0C warming
xwarming = [];
y_temper = [];
y_mat29 = [];
for i = 1:1:size(MAT0020,2)
    mat_use = MAT0020(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;1.0];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 1.5C warming
for i = 1:1:size(MAT_S1_30,2)
    mat_use = MAT_S1_30(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;1.5];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 1.8C warming
for i = 1:1:size(MAT_S1_90,2)
    mat_use = MAT_S1_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;1.8];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.0C warming
for i = 1:1:size(MAT_S2_50,2)
    mat_use = MAT_S2_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;2.0];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.1C warming
for i = 1:1:size(MAT_S3_50,2)
    mat_use = MAT_S3_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;2.1];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.4C warming
for i = 1:1:size(MAT_S5_50,2)
    mat_use = MAT_S5_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;2.4];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.7C warming
for i = 1:1:size(MAT_S2_90,2)
    mat_use = MAT_S2_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;2.7];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 3.6C warming
for i = 1:1:size(MAT_S3_90,2)
    mat_use = MAT_S3_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;3.6];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 4.4C warming
for i = 1:1:size(MAT_S5_90,2)
    mat_use = MAT_S5_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    xwarming = [xwarming;4.4];
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end

y_temper_7billion = y_temper;
y_mat29_7billion = y_mat29;

%%%%%  population 9 billion 
pop_use = POP_S2_70;
y_temper = [];
y_mat29 = [];
% 1.0C warming
for i = 1:1:size(MAT0020,2)
    mat_use = MAT0020(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 1.5C warming
for i = 1:1:size(MAT_S1_30,2)
    mat_use = MAT_S1_30(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 1.8C warming
for i = 1:1:size(MAT_S1_90,2)
    mat_use = MAT_S1_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.0C warming
for i = 1:1:size(MAT_S2_50,2)
    mat_use = MAT_S2_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.1C warming
for i = 1:1:size(MAT_S3_50,2)
    mat_use = MAT_S3_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.4C warming
for i = 1:1:size(MAT_S5_50,2)
    mat_use = MAT_S5_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.7C warming
for i = 1:1:size(MAT_S2_90,2)
    mat_use = MAT_S2_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 3.6C warming
for i = 1:1:size(MAT_S3_90,2)
    mat_use = MAT_S3_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 4.4C warming
for i = 1:1:size(MAT_S5_90,2)
    mat_use = MAT_S5_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end

y_temper_9billion = y_temper;
y_mat29_9billion = y_mat29;

%%%%%  population 11 billion 
pop_use = POP_S3_70;
y_temper = [];
y_mat29 = [];
% 1.0C warming
for i = 1:1:size(MAT0020,2)
    mat_use = MAT0020(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 1.5C warming
for i = 1:1:size(MAT_S1_30,2)
    mat_use = MAT_S1_30(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 1.8C warming
for i = 1:1:size(MAT_S1_90,2)
    mat_use = MAT_S1_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.0C warming
for i = 1:1:size(MAT_S2_50,2)
    mat_use = MAT_S2_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.1C warming
for i = 1:1:size(MAT_S3_50,2)
    mat_use = MAT_S3_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.4C warming
for i = 1:1:size(MAT_S5_50,2)
    mat_use = MAT_S5_50(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 2.7C warming
for i = 1:1:size(MAT_S2_90,2)
    mat_use = MAT_S2_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 3.6C warming
for i = 1:1:size(MAT_S3_90,2)
    mat_use = MAT_S3_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end
% 4.4C warming
for i = 1:1:size(MAT_S5_90,2)
    mat_use = MAT_S5_90(:,i);
    mean_temper = nansum ((mat_use.* pop_use)/nansum(pop_use));
    y_temper = [y_temper;mean_temper];
    y_mat29 =  [y_mat29; nansum(pop_use(mat_use>29))];
end

y_temper_11billion = y_temper;
y_mat29_11billion = y_mat29;


%% Section 2: plotting MAT felt by an average person (Extended figure 8b)
C = linspecer(9,'sequential');

tbl_7bil = table(xwarming,y_temper_7billion);
tbl_9bil = table(xwarming,y_temper_9billion);
tbl_11bil = table(xwarming,y_temper_11billion);

modelspec_7bil  = 'y_temper_7billion ~ 1 + xwarming ';
modelspec_9bil  = 'y_temper_9billion~ 1 + xwarming ';
modelspec_11bil = 'y_temper_11billion ~ 1 + xwarming ';

mdl_7bil = fitlm(tbl_7bil,modelspec_7bil);
mdl_9bil = fitlm(tbl_9bil,modelspec_9bil);
mdl_11bil = fitlm(tbl_11bil,modelspec_11bil);

xv = 0:0.01:5;
xv = xv';
[ypred_7bil,yci_7bil] = predict(mdl_7bil,xv);
[ypred_9bil,yci_9bil] = predict(mdl_9bil,xv);
[ypred_11bil,yci_11bil] = predict(mdl_11bil,xv);

figure; 
hold on;
dotsize = 3;
xv = xv';
x_ci = [xv, fliplr(xv)];
y_ci = [yci_7bil(:,1)', flipud(yci_7bil(:,2))'];
h = fill(x_ci, y_ci, C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
y_ci = [yci_9bil(:,1)', flipud(yci_9bil(:,2))'];
h = fill(x_ci, y_ci, C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
y_ci = [yci_11bil(:,1)', flipud(yci_11bil(:,2))'];
h = fill(x_ci, y_ci, C(8,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(xv,ypred_7bil,'-','LineWidth',2,'Color',C(2,:));
plot(xwarming,y_temper_7billion,'o','MarkerSize',dotsize,'Color',C(2,:));
plot(xv,ypred_9bil,'-','LineWidth',2,'Color',C(3,:));
plot(xwarming,y_temper_9billion,'o','MarkerSize',dotsize,'Color', C(3,:));
plot(xv,ypred_11bil,'-','LineWidth',2,'Color',C(8,:));
plot(xwarming,y_temper_11billion,'o','MarkerSize',dotsize,'Color',C(8,:));
hold off;
box on;
xlabel ('Degree warming (^{o}C)','Fontsize',18); ylabel ('Temperature felt (^{o}C)','Fontsize',18); 
xlim([0 5]); ylim([15 30]); 
set(gca,'FontSize',15); 
title ('Mean temperature felt by an average person','Fontsize',12);

% checking model statistics
mdl_7bil 
mdl_9bil
mdl_11bil

%% Section 3: population living in areas with MAT >29 C (figure 3a)

C = linspecer(9,'sequential');

xwarming_used = xwarming;
y_mat29_7billion_percent = y_mat29_7billion/nansum(popcount2010) * 100;
y_mat29_9billion_percent = y_mat29_9billion/nansum(POP_S2_70) * 100;
y_mat29_11billion_percent = y_mat29_11billion/nansum(POP_S2_70) * 100;

y_mat29_7billion_percent = y_mat29_7billion_percent;
y_mat29_9billion_percent = y_mat29_9billion_percent;
y_mat29_11billion_percent = y_mat29_11billion_percent;

tbl_7bil = table(xwarming_used,y_mat29_7billion_percent);
tbl_9bil = table(xwarming_used,y_mat29_9billion_percent);
tbl_11bil = table(xwarming_used,y_mat29_11billion_percent);

modelspec_7bil  = 'y_mat29_7billion_percent ~ 1 + xwarming_used ';
modelspec_9bil  = 'y_mat29_9billion_percent ~ 1 + xwarming_used ';
modelspec_11bil = 'y_mat29_11billion_percent ~ 1 + xwarming_used ';

mdl_7bil = fitlm(tbl_7bil,modelspec_7bil);
mdl_9bil = fitlm(tbl_9bil,modelspec_9bil);
mdl_11bil = fitlm(tbl_11bil,modelspec_11bil);

xv = 0:0.01:5;
xv = xv';
[ypred_7bil,yci_7bil] = predict(mdl_7bil,xv);
[ypred_9bil,yci_9bil] = predict(mdl_9bil,xv);
[ypred_11bil,yci_11bil] = predict(mdl_11bil,xv);

figure; 
hold on;
xv = xv';
x_ci = [xv, fliplr(xv)];
y_ci = [yci_7bil(:,1)', flipud(yci_7bil(:,2))'];
h = fill(x_ci, y_ci, C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
y_ci = [yci_9bil(:,1)', flipud(yci_9bil(:,2))'];
h = fill(x_ci, y_ci, C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
y_ci = [yci_11bil(:,1)', flipud(yci_11bil(:,2))'];
h = fill(x_ci, y_ci, C(8,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(xv,ypred_7bil,'-','LineWidth',2,'Color',C(2,:));
plot(xwarming_used,y_mat29_7billion_percent,'o','MarkerSize',dotsize,'Color',C(2,:));
plot(xv,ypred_9bil,'-','LineWidth',2,'Color',C(3,:));
plot(xwarming_used,y_mat29_9billion_percent,'o','MarkerSize',dotsize,'Color', C(3,:));
plot(xv,ypred_11bil,'-','LineWidth',2,'Color',C(8,:));
plot(xwarming_used,y_mat29_11billion_percent,'o','MarkerSize',dotsize,'Color',C(8,:));

hold off;
box on;
xlabel ('Degree warming (^{o}C)','Fontsize',20); ylabel ('% of population','Fontsize',20); 
xlim([0 5]); 
% ylim([0 7e9]); 
ylim([0 70]); 
set(gca,'FontSize',16); 
title ('Population exposed to MAT > 29 C','Fontsize',12);
mdl_7bil 
mdl_9bil
mdl_11bil

