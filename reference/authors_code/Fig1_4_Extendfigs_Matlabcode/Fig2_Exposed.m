%% calculating people exposed to extreme heat (MAT>29C), and people outside niche  (Matlab 2021b)

clear;
folder = fileparts(matlab.desktop.editor.getActiveFilename); 
addpath(genpath(folder));
load 'displacement_data.mat';

%% Section 1: Population exposed to MAT>29 C (Figure 2a,d)

plotx = [2010 2030 2050 2070 2090];

%%%% 2010
popdata_use = popcount2010;
matdata_use = MAT0020;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out10 = prctile(y_mat29,95);                  
mincur_out10 = prctile(y_mat29,5);                  
meancur_out10 = mean(y_mat29);                     

%%%% SSP1 (2030-2090)
popdata_use = POP_S1_30;
matdata_use = MAT_S1_30;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out30 = prctile(y_mat29,95);                  
mincur_out30 = prctile(y_mat29,5);                  
meancur_out30 = mean(y_mat29);                     

popdata_use = POP_S1_50;
matdata_use = MAT_S1_50;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out50 = prctile(y_mat29,95);                  
mincur_out50 = prctile(y_mat29,5);                  
meancur_out50 = mean(y_mat29); 

popdata_use = POP_S1_70;
matdata_use = MAT_S1_70;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out70 = prctile(y_mat29,95);                  
mincur_out70 = prctile(y_mat29,5);                  
meancur_out70 = mean(y_mat29); 

popdata_use = POP_S1_90;
matdata_use = MAT_S1_90;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out90 = prctile(y_mat29,95);                  
mincur_out90 = prctile(y_mat29,5);                  
meancur_out90 = mean(y_mat29); 

max_S1 =  [maxcur_out10 maxcur_out30 maxcur_out50 maxcur_out70 maxcur_out90];
min_S1 =  [mincur_out10 mincur_out30 mincur_out50 mincur_out70 mincur_out90];
mean_S1 = [meancur_out10 meancur_out30 meancur_out50 meancur_out70 meancur_out90];

%%%% SSP2 (2030-2090)
popdata_use = POP_S2_30;
matdata_use = MAT_S2_30;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out30 = prctile(y_mat29,95);                  
mincur_out30 = prctile(y_mat29,5);                  
meancur_out30 = mean(y_mat29); 

popdata_use = POP_S2_50;
matdata_use = MAT_S2_50;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out50 = prctile(y_mat29,95);                  
mincur_out50 = prctile(y_mat29,5);                  
meancur_out50 = mean(y_mat29); 

popdata_use = POP_S2_70;
matdata_use = MAT_S2_70;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out70 = prctile(y_mat29,95);                  
mincur_out70 = prctile(y_mat29,5);                  
meancur_out70 = mean(y_mat29); 

popdata_use = POP_S2_90;
matdata_use = MAT_S2_90;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out90 = prctile(y_mat29,95);                  
mincur_out90 = prctile(y_mat29,5);                  
meancur_out90 = mean(y_mat29); 

max_S2 =  [maxcur_out10 maxcur_out30 maxcur_out50 maxcur_out70 maxcur_out90];
min_S2 =  [mincur_out10 mincur_out30 mincur_out50 mincur_out70 mincur_out90];
mean_S2 = [meancur_out10 meancur_out30 meancur_out50 meancur_out70 meancur_out90];

%%%% SSP3 (2030-2090)
popdata_use = POP_S3_30;
matdata_use = MAT_S3_30;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out30 = prctile(y_mat29,95);                  
mincur_out30 = prctile(y_mat29,5);                  
meancur_out30 = mean(y_mat29);                     

popdata_use = POP_S3_50;
matdata_use = MAT_S3_50;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out50 = prctile(y_mat29,95);                  
mincur_out50 = prctile(y_mat29,5);                  
meancur_out50 = mean(y_mat29); 

popdata_use = POP_S3_70;
matdata_use = MAT_S3_70;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out70 = prctile(y_mat29,95);                  
mincur_out70 = prctile(y_mat29,5);                  
meancur_out70 = mean(y_mat29); 

popdata_use = POP_S3_90;
matdata_use = MAT_S3_90;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out90 = prctile(y_mat29,95);                  
mincur_out90 = prctile(y_mat29,5);                  
meancur_out90 = mean(y_mat29); 

max_S3 =  [maxcur_out10 maxcur_out30 maxcur_out50 maxcur_out70 maxcur_out90];
min_S3 =  [mincur_out10 mincur_out30 mincur_out50 mincur_out70 mincur_out90];
mean_S3 = [meancur_out10 meancur_out30 meancur_out50 meancur_out70 meancur_out90];

%%%% SSP5 (2030-2090)
popdata_use = POP_S5_30;
matdata_use = MAT_S5_30;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out30 = prctile(y_mat29,95);                  
mincur_out30 = prctile(y_mat29,5);                  
meancur_out30 = mean(y_mat29);                     

popdata_use = POP_S5_50;
matdata_use = MAT_S5_50;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out50 = prctile(y_mat29,95);                  
mincur_out50 = prctile(y_mat29,5);                  
meancur_out50 = mean(y_mat29); 

popdata_use = POP_S5_70;
matdata_use = MAT_S5_70;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out70 = prctile(y_mat29,95);                  
mincur_out70 = prctile(y_mat29,5);                  
meancur_out70 = mean(y_mat29); 

popdata_use = POP_S5_90;
matdata_use = MAT_S5_90;
y_mat29 = [];
for i = 1:1:size(matdata_use,2)
    mat_use = matdata_use(:,i);
    y_mat29 =  [y_mat29; nansum(popdata_use(mat_use>29))];
end
maxcur_out90 = prctile(y_mat29,95);                  
mincur_out90 = prctile(y_mat29,5);                  
meancur_out90 = mean(y_mat29); 

max_S5 =  [maxcur_out10 maxcur_out30 maxcur_out50 maxcur_out70 maxcur_out90];
min_S5 =  [mincur_out10 mincur_out30 mincur_out50 mincur_out70 mincur_out90];
mean_S5 = [meancur_out10 meancur_out30 meancur_out50 meancur_out70 meancur_out90];


%%%% plotting total population exposed
C = linspecer(15,'sequential');
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_S1,fliplr(max_S1)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_S2,fliplr(max_S2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_S3,fliplr(max_S3)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_S5,fliplr(max_S5)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_S1,':','Color',C(4,:),'LineWidth',0.5); 
plot(plotx, min_S2,':','Color',C(2,:),'LineWidth',0.5); 
plot(plotx, min_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_S5,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_S1,':','Color',C(4,:),'LineWidth',0.5); 
plot(plotx, max_S2,':','Color',C(2,:),'LineWidth',0.5); 
plot(plotx, max_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_S5,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_S1,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_S2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_S3,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_S5,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
yticks([1e9 2e9 3e9 4e9 5e9 6e9 7e9 8e9]);
yticklabels({'1','2','3','4','5','6','7', '8'});
xlim([2010 2090]);
ylim([0 8e9]);
set(gca,'FontSize',16);
ylabel('Billion people','Fontsize',20); 
title('Population exposed to MAT>29C','Fontsize',12);


%%%% plotting percentage population exposed
totalpop_S1 = [nansum(popcount2010) nansum(POP_S1_30) nansum(POP_S1_50) nansum(POP_S1_70) nansum(POP_S1_90)];
totalpop_S2 = [nansum(popcount2010) nansum(POP_S2_30) nansum(POP_S2_50) nansum(POP_S2_70) nansum(POP_S2_90)];
totalpop_S3 = [nansum(popcount2010) nansum(POP_S3_30) nansum(POP_S3_50) nansum(POP_S3_70) nansum(POP_S3_90)];
totalpop_S5 = [nansum(popcount2010) nansum(POP_S5_30) nansum(POP_S5_50) nansum(POP_S5_70) nansum(POP_S5_90)];

figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_S1./totalpop_S1*100,fliplr(max_S1./totalpop_S1*100)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_S2./totalpop_S2*100,fliplr(max_S2./totalpop_S2*100)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_S3./totalpop_S3*100,fliplr(max_S3./totalpop_S3*100)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_S5./totalpop_S5*100,fliplr(max_S5./totalpop_S5*100)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_S1./totalpop_S1*100,':','Color',C(4,:),'LineWidth',0.5); 
plot(plotx, min_S2./totalpop_S2*100,':','Color',C(2,:),'LineWidth',0.5); 
plot(plotx, min_S3./totalpop_S3*100,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_S5./totalpop_S5*100,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_S1./totalpop_S1*100,':','Color',C(4,:),'LineWidth',0.5); 
plot(plotx, max_S2./totalpop_S2*100,':','Color',C(2,:),'LineWidth',0.5); 
plot(plotx, max_S3./totalpop_S3*100,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_S5./totalpop_S5*100,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_S1./totalpop_S1*100,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_S2./totalpop_S2*100,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_S3./totalpop_S3*100,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_S5./totalpop_S5*100,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 70]);
set(gca,'FontSize',16);
ylabel ('% of population','Fontsize',20); 
title('Percentage population exposed to MAT>29C','Fontsize',12);



%% Section 2: Population outside niche (1D: temperature niche) Figure 2b,c,e,f

%% loading niche displacement results (1D: temperature niche); 
load 'displace1Dresult_P69b_C10warm.mat';
max_clim_only_10 = prctile(Outp_displace_0to1,95); 
min_clim_only_10 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_10 = mean(Outp_displace_0to1); 
max_combined_10 = prctile(Outp_displace_1to2,95); 
min_combined_10 = prctile(Outp_displace_1to2, 5); 
mean_combined_10 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp1_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp1_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp1_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp1_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S1 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S1 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S1 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S1 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S1 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S1 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

load 'displace1Dresult_ssp2_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp2_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp2_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp2_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S2 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S2 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S2 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S2 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S2 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S2 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

load 'displace1Dresult_ssp3_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp3_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp3_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp3_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S3 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S3 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S3 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S3 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S3 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S3 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

load 'displace1Dresult_ssp5_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp5_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp5_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace1Dresult_ssp5_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S5 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S5 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S5 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S5 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S5 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S5 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

%%%% plotting # of population outside temperature niche due to temperature change only
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_climonly_S1 .* totalpop_S1*1e-2,fliplr(max_climonly_S1 .* totalpop_S1*1e-2)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S2 .* totalpop_S2*1e-2,fliplr(max_climonly_S2 .* totalpop_S2*1e-2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S3 .* totalpop_S3*1e-2,fliplr(max_climonly_S3 .* totalpop_S3*1e-2)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S5 .* totalpop_S5*1e-2,fliplr(max_climonly_S5 .* totalpop_S5*1e-2)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_climonly_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_climonly_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_climonly_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_climonly_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_climonly_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_climonly_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_climonly_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_climonly_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_climonly_S1.* totalpop_S1*1e-2,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_climonly_S2.* totalpop_S2*1e-2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_climonly_S3.* totalpop_S3*1e-2,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_climonly_S5.* totalpop_S5*1e-2,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 8e9]);
set(gca,'FontSize',16);
ylabel ('Billion people','Fontsize',20); 
yticks([1e9 2e9 3e9 4e9 5e9 6e9 7e9 8e9]);
yticklabels({'1','2','3','4','5','6','7','8'});
title ('# people outside temp niche due to temp change only','Fontsize',12);

%%%% plotting # of population outside temperature niche due to temperature change and demography change 
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_combined_S1.* totalpop_S1*1e-2,fliplr(max_combined_S1.* totalpop_S1*1e-2)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S2.* totalpop_S2*1e-2,fliplr(max_combined_S2.* totalpop_S2*1e-2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S3.* totalpop_S3*1e-2,fliplr(max_combined_S3.* totalpop_S3*1e-2)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S5.* totalpop_S5*1e-2,fliplr(max_combined_S5.* totalpop_S5*1e-2)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_combined_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_combined_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_combined_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_combined_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_combined_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_combined_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_combined_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_combined_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_combined_S1.* totalpop_S1*1e-2,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_combined_S2.* totalpop_S2*1e-2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_combined_S3.* totalpop_S3*1e-2,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_combined_S5.* totalpop_S5*1e-2,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 8e9]);
set(gca,'FontSize',16);
ylabel ('Billion people','Fontsize',20); 
yticks([1e9 2e9 3e9 4e9 5e9 6e9 7e9 8e9]);
yticklabels({'1','2','3','4','5','6','7','8'});
title ('# people outside temp niche due to temp and demo changes','Fontsize',12);

%%%% plotting % of population outside temperature niche due to temperature change only
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_climonly_S1,fliplr(max_climonly_S1)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S2,fliplr(max_climonly_S2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S3,fliplr(max_climonly_S3)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S5,fliplr(max_climonly_S5)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_climonly_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_climonly_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_climonly_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_climonly_S5,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_climonly_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_climonly_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_climonly_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_climonly_S5,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_climonly_S1,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_climonly_S2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_climonly_S3,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_climonly_S5,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 70]);
set(gca,'FontSize',16);
ylabel ('% of population','Fontsize',20); 
title ('% people outside temp niche due to temp change only','Fontsize',12);

%%%% plotting % of population outside temperature niche due to temperature change and demography change 
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_combined_S1,fliplr(max_combined_S1)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S2,fliplr(max_combined_S2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S3,fliplr(max_combined_S3)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S5,fliplr(max_combined_S5)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_combined_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_combined_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_combined_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_combined_S5,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_combined_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_combined_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_combined_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_combined_S5,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_combined_S1,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_combined_S2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_combined_S3,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_combined_S5,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 70]);
set(gca,'FontSize',16);
ylabel ('% of population','Fontsize',20); 
title ('% people outside temp niche due to temp and demo changes','Fontsize',12);




%% Section 3: Population outside niche (2D: temperature-precipitation niche) Extended figure 6

%% loading niche displacement results (2D: temperature-precipitation niche); 
load 'displace2Dresult_P69b_C10warm.mat';
max_clim_only_10 = prctile(Outp_displace_0to1,95); 
min_clim_only_10 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_10 = mean(Outp_displace_0to1); 
max_combined_10 = prctile(Outp_displace_1to2,95); 
min_combined_10 = prctile(Outp_displace_1to2, 5); 
mean_combined_10 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp1_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp1_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp1_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp1_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S1 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S1 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S1 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S1 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S1 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S1 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

load 'displace2Dresult_ssp2_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp2_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp2_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp2_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S2 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S2 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S2 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S2 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S2 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S2 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

load 'displace2Dresult_ssp3_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp3_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp3_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp3_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S3 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S3 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S3 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S3 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S3 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S3 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];

load 'displace2Dresult_ssp5_2030.mat';
max_clim_only_30 = prctile(Outp_displace_0to1,95); 
min_clim_only_30 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_30 = mean(Outp_displace_0to1); 
max_combined_30 = prctile(Outp_displace_1to2,95); 
min_combined_30 = prctile(Outp_displace_1to2, 5); 
mean_combined_30 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp5_2050.mat';
max_clim_only_50 = prctile(Outp_displace_0to1,95); 
min_clim_only_50 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_50 = mean(Outp_displace_0to1); 
max_combined_50 = prctile(Outp_displace_1to2,95); 
min_combined_50 = prctile(Outp_displace_1to2, 5); 
mean_combined_50 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp5_2070.mat';
max_clim_only_70 = prctile(Outp_displace_0to1,95); 
min_clim_only_70 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_70 = mean(Outp_displace_0to1); 
max_combined_70 = prctile(Outp_displace_1to2,95); 
min_combined_70 = prctile(Outp_displace_1to2, 5); 
mean_combined_70 = mean(Outp_displace_1to2); 
load 'displace2Dresult_ssp5_2090.mat';
max_clim_only_90 = prctile(Outp_displace_0to1,95); 
min_clim_only_90 = prctile(Outp_displace_0to1, 5); 
mean_clim_only_90 = mean(Outp_displace_0to1); 
max_combined_90 = prctile(Outp_displace_1to2,95); 
min_combined_90 = prctile(Outp_displace_1to2, 5); 
mean_combined_90 = mean(Outp_displace_1to2); 

max_climonly_S5 =  [max_clim_only_10 max_clim_only_30 max_clim_only_50 max_clim_only_70 max_clim_only_90];
min_climonly_S5 =  [min_clim_only_10 min_clim_only_30 min_clim_only_50 min_clim_only_70 min_clim_only_90];
mean_climonly_S5 = [mean_clim_only_10 mean_clim_only_30 mean_clim_only_50 mean_clim_only_70 mean_clim_only_90];
max_combined_S5 =  [max_combined_10 max_combined_30 max_combined_50 max_combined_70 max_combined_90];
min_combined_S5 =  [min_combined_10 min_combined_30 min_combined_50 min_combined_70 min_combined_90];
mean_combined_S5 = [mean_combined_10 mean_combined_30 mean_combined_50 mean_combined_70 mean_combined_90];


%%%% plotting # of population outside temp-preci niche due to climate change only
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_climonly_S1 .* totalpop_S1*1e-2,fliplr(max_climonly_S1 .* totalpop_S1*1e-2)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S2 .* totalpop_S2*1e-2,fliplr(max_climonly_S2 .* totalpop_S2*1e-2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S3 .* totalpop_S3*1e-2,fliplr(max_climonly_S3 .* totalpop_S3*1e-2)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S5 .* totalpop_S5*1e-2,fliplr(max_climonly_S5 .* totalpop_S5*1e-2)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_climonly_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_climonly_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_climonly_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_climonly_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_climonly_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_climonly_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_climonly_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_climonly_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_climonly_S1.* totalpop_S1*1e-2,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_climonly_S2.* totalpop_S2*1e-2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_climonly_S3.* totalpop_S3*1e-2,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_climonly_S5.* totalpop_S5*1e-2,'Color',C(15,:),'LineWidth',2);

hold off;
box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 9e9]);
set(gca,'FontSize',16);
ylabel ('Billion people','Fontsize',20); 
yticks([1e9 2e9 3e9 4e9 5e9 6e9 7e9 8e9 9e9]);
yticklabels({'1','2','3','4','5','6','7','8', '9'});
title ('# people outside temp-preci niche due to climate change only','Fontsize',12);

%%%% plotting # of population outside temp-preci niche due to climate change and demography change
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_combined_S1.* totalpop_S1*1e-2,fliplr(max_combined_S1.* totalpop_S1*1e-2)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S2.* totalpop_S2*1e-2,fliplr(max_combined_S2.* totalpop_S2*1e-2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S3.* totalpop_S3*1e-2,fliplr(max_combined_S3.* totalpop_S3*1e-2)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S5.* totalpop_S5*1e-2,fliplr(max_combined_S5.* totalpop_S5*1e-2)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_combined_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_combined_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_combined_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_combined_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_combined_S1.* totalpop_S1*1e-2,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_combined_S2.* totalpop_S2*1e-2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_combined_S3.* totalpop_S3*1e-2,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_combined_S5.* totalpop_S5*1e-2,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_combined_S1.* totalpop_S1*1e-2,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_combined_S2.* totalpop_S2*1e-2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_combined_S3.* totalpop_S3*1e-2,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_combined_S5.* totalpop_S5*1e-2,'Color',C(15,:),'LineWidth',2);

hold off;box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 9e9]);
set(gca,'FontSize',16);
ylabel ('Billion people','Fontsize',20); 
yticks([1e9 2e9 3e9 4e9 5e9 6e9 7e9 8e9 9e9]);
yticklabels({'1','2','3','4','5','6','7','8', '9'});
title ('# people outside temp-preci niche due to climate and demography changes','Fontsize',12);

%%%% plotting % of population outside temp-preci niche due to climate change only
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_climonly_S1,fliplr(max_climonly_S1)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S2,fliplr(max_climonly_S2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S3,fliplr(max_climonly_S3)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_climonly_S5,fliplr(max_climonly_S5)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_climonly_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_climonly_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_climonly_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_climonly_S5,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_climonly_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_climonly_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_climonly_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_climonly_S5,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_climonly_S1,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_climonly_S2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_climonly_S3,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_climonly_S5,'Color',C(15,:),'LineWidth',2);

hold off;box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 80]);
set(gca,'FontSize',16);
ylabel ('% of population','Fontsize',20); 
title ('% people outside temp-preci niche due to climate change only','Fontsize',12);

%%%% plotting % of population outside temp-preci niche due to climate change and demography change 
figure;
hold on;
h = fill([plotx,fliplr(plotx)],[min_combined_S1,fliplr(max_combined_S1)],C(4,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S2,fliplr(max_combined_S2)],C(2,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S3,fliplr(max_combined_S3)],C(12,:));
set(h,'LineStyle','none','facealpha',0.2);
h = fill([plotx,fliplr(plotx)],[min_combined_S5,fliplr(max_combined_S5)],C(15,:));
set(h,'LineStyle','none','facealpha',0.2);

plot(plotx, min_combined_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, min_combined_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, min_combined_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, min_combined_S5,':','Color',C(15,:),'LineWidth',0.5);
plot(plotx, max_combined_S1,':','Color',C(4,:),'LineWidth',0.5);
plot(plotx, max_combined_S2,':','Color',C(2,:),'LineWidth',0.5);
plot(plotx, max_combined_S3,':','Color',C(12,:),'LineWidth',0.5);
plot(plotx, max_combined_S5,':','Color',C(15,:),'LineWidth',0.5);

plot(plotx, mean_combined_S1,'Color',C(4,:),'LineWidth',2);
plot(plotx, mean_combined_S2,'Color',C(2,:),'LineWidth',2);
plot(plotx, mean_combined_S3,'Color',C(12,:),'LineWidth',2);
plot(plotx, mean_combined_S5,'Color',C(15,:),'LineWidth',2);

hold off;box on;
xticks([2010 2030 2050 2070 2090]);
xlim([2010 2090]);
ylim([0 80]);
set(gca,'FontSize',16);
ylabel ('% of population','Fontsize',20);
title ('% people outside temp-preci niche due to climate and demography changes','Fontsize',12);



