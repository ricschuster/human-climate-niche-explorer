clear;
folder = fileparts(matlab.desktop.editor.getActiveFilename); 
addpath(genpath(folder));
load 'extremetemp.mat';

%% MAT vs number of days of drybulb temperature over 40 (2001-2020, ERA5 data);

figure;
plot(MAT0020ERA5, ERA5_DryBT40_days/20.0,'.','MarkerSize',1);
hold on;
leastsample = 30;
mat_range = [10 40];
mean_zfac_vec  = runningmeandata(ERA5_DryBT40_days/20.0, MAT0020ERA5, 2.0, 0.5, mat_range,leastsample); 
binvec = mat_range(1):0.5:mat_range(2)+0.25;
plot(binvec,mean_zfac_vec,'-r','LineWidth',2); 
yyy = 0:0.01:200;
xxx = yyy*0+29;
plot(xxx,yyy,'-k');
hold off;
xlabel ('MAT (^{o}C)','Fontsize',16); 
ylabel ({'Number of days with'; 'maximum temperature over 40 ^{o}C'},'Fontsize',16); 
xlim([10 35]); ylim([0 170]);

%% MAT vs number of days of wetbulb temperature over 28 (2001-2020, CMIP6 model historical) 

figure;
wbt28 = CMIP6_WBT28.wbt28_days;
mat28 = CMIP6_WBT28.mat;
plot(mat28, wbt28,'.','MarkerSize',2);
xlim([10 35]);
xlabel ('MAT (^{o}C)','Fontsize',14); 
ylabel ({'Number of days with WBT above 28 ^{o}C'},'Fontsize',14); 
hold on;
leastsample = 20;
mat_range = [10 40];
mean_zfac_vec  = runningmeandata(wbt28,mat28, 2.0, 0.5, mat_range,leastsample); 
binvec = mat_range(1):0.5:mat_range(2)+0.25;
plot(binvec,mean_zfac_vec,'-r','LineWidth',2); 
plot(xxx,yyy,'-k');
hold off;
ylim([0 30]);
