%% Calculating population density against Mean Annual Temperature (Temperature niche): Figure 1, Extended Figures 1, 5 & 7

clear;
folder = fileparts(matlab.desktop.editor.getActiveFilename); 
addpath(genpath(folder));
load 'displacement_data.mat';

nichefactor = 1e6;
SSP1_30_norm   = normsumunity(nichefactor,POP_S1_30);              % SSP1-5 scenarios of population growth 2030
SSP2_30_norm   = normsumunity(nichefactor,POP_S2_30);
SSP3_30_norm   = normsumunity(nichefactor,POP_S3_30);
SSP5_30_norm   = normsumunity(nichefactor,POP_S5_30);
SSP1_50_norm   = normsumunity(nichefactor,POP_S1_50);              % SSP1-5 scenarios of population growth 2050
SSP2_50_norm   = normsumunity(nichefactor,POP_S2_50);
SSP3_50_norm   = normsumunity(nichefactor,POP_S3_50);
SSP5_50_norm   = normsumunity(nichefactor,POP_S5_50);
SSP1_70_norm   = normsumunity(nichefactor,POP_S1_70);              % SSP1-5 scenarios of population growth 2070
SSP2_70_norm   = normsumunity(nichefactor,POP_S2_70);
SSP3_70_norm   = normsumunity(nichefactor,POP_S3_70);
SSP5_70_norm   = normsumunity(nichefactor,POP_S5_70);
SSP1_90_norm   = normsumunity(nichefactor,POP_S1_90);              % SSP1-5 scenarios of population growth 2090
SSP2_90_norm   = normsumunity(nichefactor,POP_S2_90);
SSP3_90_norm   = normsumunity(nichefactor,POP_S3_90);
SSP5_90_norm   = normsumunity(nichefactor,POP_S5_90);

%% Section 1: Figure 1a (Reference & Current Niche)

mat_range   = [-5.0 35.0]; 
leastsample = 1000;
%%%% Reference niche (1960-1990 climate + 1980 population)
zfactor = popden1980;  
matuse  = MAT6090;  
[~,nmatuse] = size(matuse);
HCN_6090 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_6090 = [HCN_6090; mean_zfac_vec];
end
maxcur_out_6090 = prctile(HCN_6090,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_6090 = prctile(HCN_6090,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_6090 = mean(HCN_6090);                     %    mean value of running mean ensemble

%%%%%  Current niche (2000-2020 climate + 2010 population)
zfactor = popden2010;   
matuse  = MAT0020; 
[~,nmatuse] = size(matuse);
HCN_0020 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_0020 = [HCN_0020; mean_zfac_vec];
end
maxcur_out_0020 = prctile(HCN_0020,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_0020 = prctile(HCN_0020,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_0020 = mean(HCN_0020);                     %    mean value of running mean ensemble

%%% plotting Figure 1a
matbin      = 2.0;                                      % moving window size along MAT (for running mean curves)
matmovbin   = 1.0;                                      % moving window step along MAT (for running mean curves)
matbinvec   = mat_range(1):matmovbin:mat_range(2);
matbinvec   = matbinvec + matmovbin/2.0;   
ft = fittype( 'gauss2' );  
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off'; opts.Lower = [-Inf -Inf 0 -Inf 25 0]; opts.Upper = [Inf Inf Inf Inf 30 5];        
matvec      = -5:0.1:35; matvec = matvec.';  
binvec = mat_range(1):1.0:mat_range(2)+0.5;
figure;
h_RM = gcf;
hold on;
C = linspecer(9,'sequential'); 
% 1960-1990 
fltout = isnan(meancurRM_out_6090)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_6090(fltout),fliplr(maxcur_out_6090(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_6090,'-','LineWidth',2, 'Color',C(1,:));
excl = isnan(meancurRM_out_6090)==0; 
[fitmatgaus_6090_mean, ~] = fit( matbinvec(excl).', meancurRM_out_6090(excl).', ft, opts );
dGniche_curve = fitmatgaus_6090_mean(matvec);
plot(matvec,dGniche_curve,'--','Color',C(1,:),'Linewidth',2);                 % here producing the blue dashed curves in Fig 2A & S2
% 2000-2020 
fltout = isnan(meancurRM_out_0020)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_0020(fltout),fliplr(maxcur_out_0020(fltout))],C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_0020,'-','LineWidth',2, 'Color',C(2,:));
excl = isnan(meancurRM_out_0020)==0; 
[fitmatgaus_0020_mean, ~] = fit( binvec(excl).', meancurRM_out_0020(excl).', ft, opts );
dGniche_curve = fitmatgaus_0020_mean(matvec);
plot(matvec,dGniche_curve,'--','Color',C(2,:),'Linewidth',2);                 % here producing the blue dashed curves in Fig 2A & S2
hold off;
xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
xlim([-5 35]); ylim([0 1.75]);
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
title('Reference & current niche','Fontsize',12);

%% Section 2: Figure 1b (Future niche under SSP2-4.5)

%%%%  2030 
zfactor = SSP2_30_norm;   
matuse  = MAT_S2_30;
[~,nmatuse] = size(matuse);
HCN_30 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_30 = [HCN_30; mean_zfac_vec];
end
maxcur_out_30 = prctile(HCN_30,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_30 = prctile(HCN_30,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_30 = mean(HCN_30);                     %    mean value of running mean ensemble
%%%%  2050
zfactor = SSP2_50_norm;   
matuse  = MAT_S2_50; 
[~,nmatuse] = size(matuse);
HCN_50 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_50 = [HCN_50; mean_zfac_vec];
end
maxcur_out_50 = prctile(HCN_50,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_50 = prctile(HCN_50,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_50 = mean(HCN_50);                     %    mean value of running mean ensemble
%%%%  2070
zfactor = SSP2_70_norm;   
matuse  = MAT_S2_70; 
[~,nmatuse] = size(matuse);
HCN_70 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_70 = [HCN_70; mean_zfac_vec];
end
maxcur_out_70 = prctile(HCN_70,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_70 = prctile(HCN_70,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_70 = mean(HCN_70);                     %    mean value of running mean ensemble
%%%%  2090
zfactor = SSP2_90_norm;   
matuse  = MAT_S2_90; 
[~,nmatuse] = size(matuse);
HCN_90 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_90 = [HCN_90; mean_zfac_vec];
end
maxcur_out_90 = prctile(HCN_90,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_90 = prctile(HCN_90,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_90 = mean(HCN_90);                     %    mean value of running mean ensemble

%%%% plotting Figure 1b
figure;
hold on;
% 1960-1990 
fltout = isnan(meancurRM_out_6090)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_6090(fltout),fliplr(maxcur_out_6090(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_6090,'-','LineWidth',2, 'Color',C(1,:));
% 2000-2010 
fltout = isnan(meancurRM_out_0020)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_0020(fltout),fliplr(maxcur_out_0020(fltout))],C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_0020,'-','LineWidth',2, 'Color',C(2,:));
% 2030
fltout = isnan(meancurRM_out_30)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_30(fltout),fliplr(maxcur_out_30(fltout))],C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_30,'-','LineWidth',2, 'Color',C(3,:));
% 2050
fltout = isnan(meancurRM_out_50)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_50(fltout),fliplr(maxcur_out_50(fltout))],C(6,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_50,'-','LineWidth',2, 'Color',C(6,:));
% 2070
fltout = isnan(meancurRM_out_70)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_70(fltout),fliplr(maxcur_out_70(fltout))],C(7,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_70,'-','LineWidth',2, 'Color',C(7,:));
% 2090
fltout = isnan(meancurRM_out_90)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_90(fltout),fliplr(maxcur_out_90(fltout))],C(9,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_90,'-','LineWidth',2, 'Color',C(9,:));

xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
xlim([-5 35]); ylim([0 1.75]);
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
title('Niche change SSP2-4.5','Fontsize',12);
hold off;

%%  Section 3: Extended Figure 5 
%%%%  Future niche under SSP1-2.6 
%%%%  2030 
zfactor = SSP1_30_norm;   
matuse  = MAT_S1_30;
[~,nmatuse] = size(matuse);
HCN_30 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_30 = [HCN_30; mean_zfac_vec];
end
maxcur_out_30 = prctile(HCN_30,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_30 = prctile(HCN_30,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_30 = mean(HCN_30);                     %    mean value of running mean ensemble
%%%%  2050
zfactor = SSP1_50_norm;   
matuse  = MAT_S1_50; 
[~,nmatuse] = size(matuse);
HCN_50 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_50 = [HCN_50; mean_zfac_vec];
end
maxcur_out_50 = prctile(HCN_50,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_50 = prctile(HCN_50,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_50 = mean(HCN_50);                     %    mean value of running mean ensemble
%%%%  2070
zfactor = SSP1_70_norm;   
matuse  = MAT_S1_70; 
[~,nmatuse] = size(matuse);
HCN_70 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_70 = [HCN_70; mean_zfac_vec];
end
maxcur_out_70 = prctile(HCN_70,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_70 = prctile(HCN_70,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_70 = mean(HCN_70);                     %    mean value of running mean ensemble
%%%%  2090
zfactor = SSP1_90_norm;   
matuse  = MAT_S1_90; 
[~,nmatuse] = size(matuse);
HCN_90 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_90 = [HCN_90; mean_zfac_vec];
end
maxcur_out_90 = prctile(HCN_90,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_90 = prctile(HCN_90,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_90 = mean(HCN_90);                     %    mean value of running mean ensemble
%%%% plotting extended Figure 5a
figure;
hold on;
% 1960-1990 
fltout = isnan(meancurRM_out_6090)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_6090(fltout),fliplr(maxcur_out_6090(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_6090,'-','LineWidth',2, 'Color',C(1,:));
% 2000-2010 
fltout = isnan(meancurRM_out_0020)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_0020(fltout),fliplr(maxcur_out_0020(fltout))],C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_0020,'-','LineWidth',2, 'Color',C(2,:));
% 2030
fltout = isnan(meancurRM_out_30)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_30(fltout),fliplr(maxcur_out_30(fltout))],C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_30,'-','LineWidth',2, 'Color',C(3,:));
% 2050
fltout = isnan(meancurRM_out_50)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_50(fltout),fliplr(maxcur_out_50(fltout))],C(6,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_50,'-','LineWidth',2, 'Color',C(6,:));
% 2070
fltout = isnan(meancurRM_out_70)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_70(fltout),fliplr(maxcur_out_70(fltout))],C(7,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_70,'-','LineWidth',2, 'Color',C(7,:));
% 2090
fltout = isnan(meancurRM_out_90)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_90(fltout),fliplr(maxcur_out_90(fltout))],C(9,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_90,'-','LineWidth',2, 'Color',C(9,:));
xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
xlim([-5 35]); ylim([0 1.75]);
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
title('Niche change SSP1-2.6','Fontsize',12);
hold off;

%%%%  Future niche under SSP3-7.0 
%%%%  2030 
zfactor = SSP3_30_norm;   
matuse  = MAT_S3_30;
[~,nmatuse] = size(matuse);
HCN_30 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_30 = [HCN_30; mean_zfac_vec];
end
maxcur_out_30 = prctile(HCN_30,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_30 = prctile(HCN_30,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_30 = mean(HCN_30);                     %    mean value of running mean ensemble
%%%%  2050
zfactor = SSP3_50_norm;   
matuse  = MAT_S3_50; 
[~,nmatuse] = size(matuse);
HCN_50 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_50 = [HCN_50; mean_zfac_vec];
end
maxcur_out_50 = prctile(HCN_50,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_50 = prctile(HCN_50,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_50 = mean(HCN_50);                     %    mean value of running mean ensemble
%%%%  2070
zfactor = SSP3_70_norm;   
matuse  = MAT_S3_70; 
[~,nmatuse] = size(matuse);
HCN_70 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_70 = [HCN_70; mean_zfac_vec];
end
maxcur_out_70 = prctile(HCN_70,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_70 = prctile(HCN_70,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_70 = mean(HCN_70);                     %    mean value of running mean ensemble
%%%%  2090
zfactor = SSP3_90_norm;   
matuse  = MAT_S3_90; 
[~,nmatuse] = size(matuse);
HCN_90 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_90 = [HCN_90; mean_zfac_vec];
end
maxcur_out_90 = prctile(HCN_90,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_90 = prctile(HCN_90,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_90 = mean(HCN_90);                     %    mean value of running mean ensemble
%%%% plotting extended Figure 5b
figure;
hold on;
% 1960-1990 
fltout = isnan(meancurRM_out_6090)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_6090(fltout),fliplr(maxcur_out_6090(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_6090,'-','LineWidth',2, 'Color',C(1,:));
% 2000-2010 
fltout = isnan(meancurRM_out_0020)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_0020(fltout),fliplr(maxcur_out_0020(fltout))],C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_0020,'-','LineWidth',2, 'Color',C(2,:));
% 2030
fltout = isnan(meancurRM_out_30)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_30(fltout),fliplr(maxcur_out_30(fltout))],C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_30,'-','LineWidth',2, 'Color',C(3,:));
% 2050
fltout = isnan(meancurRM_out_50)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_50(fltout),fliplr(maxcur_out_50(fltout))],C(6,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_50,'-','LineWidth',2, 'Color',C(6,:));
% 2070
fltout = isnan(meancurRM_out_70)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_70(fltout),fliplr(maxcur_out_70(fltout))],C(7,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_70,'-','LineWidth',2, 'Color',C(7,:));
% 2090
fltout = isnan(meancurRM_out_90)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_90(fltout),fliplr(maxcur_out_90(fltout))],C(9,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_90,'-','LineWidth',2, 'Color',C(9,:));
xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
xlim([-5 35]); ylim([0 1.75]);
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
title('Niche change SSP3-7.0','Fontsize',12);
hold off;

%%%%  Future niche under SSP5-8.5 
%%%%  2030 
zfactor = SSP5_30_norm;   
matuse  = MAT_S5_30;
[~,nmatuse] = size(matuse);
HCN_30 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_30 = [HCN_30; mean_zfac_vec];
end
maxcur_out_30 = prctile(HCN_30,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_30 = prctile(HCN_30,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_30 = mean(HCN_30);                     %    mean value of running mean ensemble
%%%%  2050
zfactor = SSP5_50_norm;   
matuse  = MAT_S5_50; 
[~,nmatuse] = size(matuse);
HCN_50 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_50 = [HCN_50; mean_zfac_vec];
end
maxcur_out_50 = prctile(HCN_50,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_50 = prctile(HCN_50,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_50 = mean(HCN_50);                     %    mean value of running mean ensemble
%%%%  2070
zfactor = SSP5_70_norm;   
matuse  = MAT_S5_70; 
[~,nmatuse] = size(matuse);
HCN_70 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_70 = [HCN_70; mean_zfac_vec];
end
maxcur_out_70 = prctile(HCN_70,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_70 = prctile(HCN_70,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_70 = mean(HCN_70);                     %    mean value of running mean ensemble
%%%%  2090
zfactor = SSP5_90_norm;   
matuse  = MAT_S5_90; 
[~,nmatuse] = size(matuse);
HCN_90 = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_90 = [HCN_90; mean_zfac_vec];
end
maxcur_out_90 = prctile(HCN_90,95);                  % 95 percentile of running mean ensemble (here equivalent to maximum due to sparse data points)
mincur_out_90 = prctile(HCN_90,5);                   %  5 percentile of running mean ensemble (here equivalent to minimum due to sparse data points)
meancurRM_out_90 = mean(HCN_90);                     %    mean value of running mean ensemble
%%%% plotting extended Figure 5c
figure;
hold on;
% 1960-1990 
fltout = isnan(meancurRM_out_6090)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_6090(fltout),fliplr(maxcur_out_6090(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_6090,'-','LineWidth',2, 'Color',C(1,:));
% 2000-2010 
fltout = isnan(meancurRM_out_0020)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_0020(fltout),fliplr(maxcur_out_0020(fltout))],C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_0020,'-','LineWidth',2, 'Color',C(2,:));
% 2030
fltout = isnan(meancurRM_out_30)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_30(fltout),fliplr(maxcur_out_30(fltout))],C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_30,'-','LineWidth',2, 'Color',C(3,:));
% 2050
fltout = isnan(meancurRM_out_50)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_50(fltout),fliplr(maxcur_out_50(fltout))],C(6,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_50,'-','LineWidth',2, 'Color',C(6,:));
% 2070
fltout = isnan(meancurRM_out_70)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_70(fltout),fliplr(maxcur_out_70(fltout))],C(7,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_70,'-','LineWidth',2, 'Color',C(7,:));
% 2090
fltout = isnan(meancurRM_out_90)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_90(fltout),fliplr(maxcur_out_90(fltout))],C(9,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_90,'-','LineWidth',2, 'Color',C(9,:));
xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
xlim([-5 35]); ylim([0 1.75]);
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
title('Niche change SSP5-8.5','Fontsize',12);
hold off;


%% Section 4： Figure 1c & Extended figure 7

zfactor = SSP2_70_norm ;    % 'SSP2_70_norm' for  9.5 billion  (fig 1c)
                            % 'popden2010' for    6.9 billion  (extend fig 7a)
                            % 'SSP3_70_norm' for  11.2 billion (extend fig 7b)
%%%%% 1.5 C warming
matuse  = MAT_S1_30; 
[~,nmatuse] = size(matuse);
HCN_current15C = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_current15C = [HCN_current15C; mean_zfac_vec];
end
maxcur_out_current15c = prctile(HCN_current15C,95);                   
mincur_out_current15c = prctile(HCN_current15C,5);                   
meancurRM_out_current15c = mean(HCN_current15C);                    
%%%%% 1.8 C warming
matuse  = MAT_S1_90;
[~,nmatuse] = size(matuse);
HCN_current18C = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_current18C = [HCN_current18C; mean_zfac_vec];
end
maxcur_out_current18c = prctile(HCN_current18C,95);                
mincur_out_current18c = prctile(HCN_current18C,5);                   
meancurRM_out_current18c = mean(HCN_current18C);                   
%%%%% 2.1 C warming
matuse  = MAT_S3_50;     
[~,nmatuse] = size(matuse);
HCN_current21C = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_current21C = [HCN_current21C; mean_zfac_vec];
end
maxcur_out_current21c = prctile(HCN_current21C,95);                 
mincur_out_current21c = prctile(HCN_current21C,5);                  
meancurRM_out_current21c = mean(HCN_current21C); 
%%%%% 2.4 C warming
matuse  = MAT_S5_50;     
[~,nmatuse] = size(matuse);
HCN_current24C = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_current24C = [HCN_current24C; mean_zfac_vec];
end
maxcur_out_current24c = prctile(HCN_current24C,95);                  
mincur_out_current24c = prctile(HCN_current24C,5);                    
meancurRM_out_current24c = mean(HCN_current24C); 
%%%%% 2.7 C warming
matuse  = MAT_S2_90;    
[~,nmatuse] = size(matuse);
HCN_current27C = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_current27C = [HCN_current27C; mean_zfac_vec];
end
maxcur_out_current27c = prctile(HCN_current27C,95);                  
mincur_out_current27c = prctile(HCN_current27C,5);                   
meancurRM_out_current27c = mean(HCN_current27C);                     
%%%%% 3.6 C warming
matuse  = MAT_S3_90;    
[~,nmatuse] = size(matuse);
HCN_current36C = [];
for imat = 1:1:nmatuse
    iimatuse = matuse(:,imat);
    flt = zfactor>=0 & ~isnan(iimatuse);
    zfac_norm = normsumunity(nichefactor,zfactor (flt));
    mean_zfac_vec  = runningmeandata(zfac_norm, iimatuse(flt), 2.0, 1.0, mat_range,leastsample);
    HCN_current36C = [HCN_current36C; mean_zfac_vec];
end
maxcur_out_current36c = prctile(HCN_current36C,95);                 
mincur_out_current36c = prctile(HCN_current36C,5);                   
meancurRM_out_current36c = mean(HCN_current36C);                     

%%%% plotting figure 1c
figure;
h_RM = gcf;
hold on;
C = linspecer(9,'sequential');
% 0.3 C warming (1960-1990) 
fltout = isnan(meancurRM_out_6090)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_6090(fltout),fliplr(maxcur_out_6090(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(binvec,meancurRM_out_6090,'-','LineWidth',2, 'Color',C(1,:));
% 1.5-3.6 C warming
fltout = isnan(meancurRM_out_current15c)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_current15c(fltout),fliplr(maxcur_out_current15c(fltout))],C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
fltout = isnan(meancurRM_out_current18c)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_current18c(fltout),fliplr(maxcur_out_current18c(fltout))],C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
fltout = isnan(meancurRM_out_current21c)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_current21c(fltout),fliplr(maxcur_out_current21c(fltout))],C(6,:));
set(h,'LineStyle','none','facealpha',0.3);
fltout = isnan(meancurRM_out_current24c)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_current24c(fltout),fliplr(maxcur_out_current24c(fltout))],C(7,:));
set(h,'LineStyle','none','facealpha',0.3);
fltout = isnan(meancurRM_out_current27c)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_current27c(fltout),fliplr(maxcur_out_current27c(fltout))],C(8,:));
set(h,'LineStyle','none','facealpha',0.3);
fltout = isnan(meancurRM_out_current36c)==0;
h = fill([binvec(fltout),fliplr(binvec(fltout))],[mincur_out_current36c(fltout),fliplr(maxcur_out_current36c(fltout))],C(9,:));
set(h,'LineStyle','none','facealpha',0.3);

plot(binvec,meancurRM_out_current15c,'-','LineWidth',2, 'Color',C(2,:));
plot(binvec,meancurRM_out_current18c,'-','LineWidth',2, 'Color',C(3,:));
plot(binvec,meancurRM_out_current21c,'-','LineWidth',2, 'Color',C(6,:));
plot(binvec,meancurRM_out_current24c,'-','LineWidth',2, 'Color',C(7,:));
plot(binvec,meancurRM_out_current27c,'-','LineWidth',2, 'Color',C(8,:));
plot(binvec,meancurRM_out_current36c,'-','LineWidth',2, 'Color',C(9,:));

xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
xlim([-5 35]); ylim([0 1.75]);
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
title('Niche change with warming','Fontsize',12);
hold off;

%% Section 5: Extended Figure 1 (data generated by previous work "Future of the Human Climate Niche")

C = linspecer(9,'sequential');
mat_range   = [-5.0 35.0]; 
matbin      = 2.0;                                      % moving window size along MAT (for running mean curves)
matmovbin   = 1.0;                                      % moving window step along MAT (for running mean curves)
matbinvec   = mat_range(1):matmovbin:mat_range(2);
matbinvec   = matbinvec + matmovbin/2.0;   
ft = fittype( 'gauss2' );  
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off'; opts.Lower = [-Inf -Inf 0 -Inf 25 0]; opts.Upper = [Inf Inf Inf Inf 30 5];        
matvec      = -5:0.1:35; matvec = matvec.';  
binvec = mat_range(1):1.0:mat_range(2)+0.5;

load 'Extend_Fig1_oldref.mat';       % Old reference
load 'Extend_Fig1_newref.mat';       % New reference
load 'Extend_Fig1_6K_ArchGlobe.mat'; % 6K BP based on ArchaeoGlobe population data
load 'Extend_Fig1_6Kbp_HYDE.mat';    % 6K BP based on HYDE population data
load 'Extend_Fig1_300bp.mat';        % 300 BP
load 'Extend_Fig1_500bp.mat';        % 500 BP

%%%% plotting extended figure 1a
%%%% 300 BP
figure;
hold on;
maxcur_out = prctile(out_17pop_mat_curve,95);      
mincur_out = prctile(out_17pop_mat_curve,5);       
meancur_out = mean(out_17pop_mat_curve);           
fltout = isnan(maxcur_out)==0;
bandcolor = [0.9290, 0.6940, 0.1250]; 
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],bandcolor);
set(h,'LineStyle','none','facealpha',0.3);
plot(matbinvec, meancur_out,'Color',bandcolor,'LineWidth',2);

%%%% 500 BP
maxcur_out = prctile(out_15pop_mat_curve,95);      
mincur_out = prctile(out_15pop_mat_curve,5);       
meancur_out = mean(out_15pop_mat_curve);            
fltout = isnan(maxcur_out)==0;
bandcolor = [102/256 204/256 0/226]; 
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],[6/256 127/256 16/226]);
set(h,'LineStyle','none','facealpha',0.3);
plot(matbinvec, meancur_out,'Color',[6/256 127/256 16/226],'LineWidth',2);

%%%% old reference (population 2015 + climate 1960-1990)
maxcur_out = prctile(out_curpop_mat_curve,95);                  
mincur_out = prctile(out_curpop_mat_curve,5);                   
meancurRM_out = mean(out_curpop_mat_curve);                     
fltout = isnan(maxcur_out)==0;
bandcolor = C(8,:); 
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],bandcolor);
set(h,'LineStyle','none','facealpha',0.3);
plot(matbinvec, meancurRM_out,'Color',bandcolor,'LineWidth',2); 
excl = isnan(meancurRM_out)==0; 
[fitmatgaus_current_mean, ~] = fit( matbinvec(excl).', meancurRM_out(excl).', ft, opts );
dGniche_curve = fitmatgaus_current_mean(matvec);
plot(matvec,dGniche_curve,'--','Color',bandcolor,'Linewidth',2);                

%%%% New reference (population 1980 + climate 1960-1990)
maxcur_out = prctile(out_curpop6090_mat_curve,95);                
mincur_out = prctile(out_curpop6090_mat_curve,5);                  
meancurRM_out = mean(out_curpop6090_mat_curve);                    
fltout = isnan(meancurRM_out)==0;
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(matbinvec, meancurRM_out,'Color',C(1,:),'LineWidth',2); 
excl = isnan(meancurRM_out)==0; 
[fitmatgaus_6090_mean, ~] = fit( matbinvec(excl).', meancurRM_out(excl).', ft, opts );
dGniche_curve = fitmatgaus_6090_mean(matvec);
plot(matvec,dGniche_curve,'--','Color',C(1,:),'Linewidth',2);                

hold off;
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
ylim([0 1.75]); xlim([-5 35]);
xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
title('Old & new references vs 300 & 500 BP ','Fontsize',12);

%%%% plotting extended figure 1b
figure;
hold on;
%%%% 6K BP HYDE
maxcur_out = prctile(out_MHpop_mat_curve,95);               
mincur_out = prctile(out_MHpop_mat_curve,5);                
meancur_out = mean(out_MHpop_mat_curve);                   
bandcolorMH =  [6/256 127/256 16/226];  
fltout = isnan(maxcur_out)==0;
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],bandcolorMH);
set(h,'LineStyle','none','facealpha',0.36);
plot(matbinvec, meancur_out,'Color',bandcolorMH,'LineWidth',2);

%%%% 6K BP ArchaeoGlobe
bandcolorAG = [0.9290, 0.6940, 0.1250];
maxcur_out = prctile(out_popAG_mat_curve,95);               
mincur_out = prctile(out_popAG_mat_curve,5);                
meancur_out = mean(out_popAG_mat_curve);                    
fltout = isnan(maxcur_out)==0;
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],bandcolorAG);
set(h,'LineStyle','none','facealpha',0.36);
plot(matbinvec, meancur_out,'Color',bandcolorAG,'LineWidth',2);

%%%% old reference (population 2015 + climate 1960-1990)
maxcur_out = prctile(out_curpop_mat_curve,95);                  
mincur_out = prctile(out_curpop_mat_curve,5);                   
meancurRM_out = mean(out_curpop_mat_curve);                     
fltout = isnan(maxcur_out)==0;
bandcolor = C(8,:); 
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],bandcolor);
set(h,'LineStyle','none','facealpha',0.3);
plot(matbinvec, meancurRM_out,'Color',bandcolor,'LineWidth',2); 
excl = isnan(meancurRM_out)==0; 
[fitmatgaus_current_mean, ~] = fit( matbinvec(excl).', meancurRM_out(excl).', ft, opts );
dGniche_curve = fitmatgaus_current_mean(matvec);
plot(matvec,dGniche_curve,'--','Color',bandcolor,'Linewidth',2);                

%%%% New reference (population 1980 + climate 1960-1990)
maxcur_out = prctile(out_curpop6090_mat_curve,95);                
mincur_out = prctile(out_curpop6090_mat_curve,5);                  
meancurRM_out = mean(out_curpop6090_mat_curve);                    
fltout = isnan(meancurRM_out)==0;
h = fill([matbinvec(fltout),fliplr(matbinvec(fltout))],[mincur_out(fltout),fliplr(maxcur_out(fltout))],C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(matbinvec, meancurRM_out,'Color',C(1,:),'LineWidth',2); 
excl = isnan(meancurRM_out)==0; 
[fitmatgaus_6090_mean, ~] = fit( matbinvec(excl).', meancurRM_out(excl).', ft, opts );
dGniche_curve = fitmatgaus_6090_mean(matvec);
plot(matvec,dGniche_curve,'--','Color',C(1,:),'Linewidth',2);                

hold off;
box on;set(gca,'YTickLabel',[],'ytick',[],'FontSize',16);
ylim([0 1.75]); xlim([-5 35]);
xlabel ('MAT (^{o}C)','Fontsize',20);
ylabel ('Population density','Fontsize',20); 
title('Old & new references vs 6KBP ','Fontsize',12);

