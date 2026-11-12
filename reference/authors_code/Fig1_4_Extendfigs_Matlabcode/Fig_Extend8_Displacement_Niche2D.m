%% Calculating displacement of temperature-precipitation niche (2D niche) and population outside the niche (Matlab 2021b)

clear;
folder = fileparts(matlab.desktop.editor.getActiveFilename); 
addpath(genpath(folder));
load 'displacement_data.mat';

%% Section1: 2D climate niche reference 1960-1990

map_range = [0 4000];                               % data range mean annual temperature
mat_range = [-10 40];                               % data range mean annual precipitation
datarange =  [map_range(1) map_range(2) mat_range(1) mat_range(2)];
out_res = 100; 
nichefactor = 1e6;

[Surf_niche_ref6090]     =         niche2D(MATwldclm_6090, MAPwldclm_6090, popden1980, true); title('reference niche');     %% 2D niche characterized by a smoothed surface
figure; [Mapp_niche_ref6090]     = niche2D_mapping(MATwldclm_6090, MAPwldclm_6090, popden1980, x, y, Surf_niche_ref6090);     %% projecting the 2D niche (the surface) onto the geographic space 
niche2D_0 = Mapp_niche_ref6090;
heatmapcompute(niche2D_0(:,1),niche2D_0(:,2),niche2D_0(:,3),[-180 180 -60 90],false,true,[4200,1800],false);
colormap('jet');

 
%% Section2: human climate niche for 1.0 (2010, near present), 1.5, 1.8, 2.1, 2.4, 2.7 C warming (generating results for extended figure 6 & 8a)
 
% ensemble GCM models: 
% MAT0020    (2000-2020) for  1.0 C warming ;
% SSP1.26-30 (2021-2040) for  1.5 C warming ;
% SSP1.26-90 (2081-2100) for  1.8 C warming ;
% SSP2.45-50 (2041-2160) for  2.0 C warming ;
% SSP3.70-50 (2041-2060) for  2.1 C warming ;
% SSP5.85-50 (2041-2060) for  2.4 C warming ;
% SSP2.45-90 (2081-2100) for  2.7 C warming ;
% SSP3.70-90 (2081-2100) for  3.6 C warming ;
% SSP5.85-90 (2081-2100) for  4.4 C warming ;

% use Population for Year 2070 as a fixed amount of total population:
% 2017 population (present)
% SSP2_70: ~9.5 billion
% SSP3_70: ~11.2 billion
% if considering different spatial distributions:
% SSP2_90: 9.2 billion
% SSP5_90: 8.0 billion 

popden_future   = POP_S1_90;        % adapt to: popden2010 (6.9 billion), POP_S2_70(9.5 billion), POP_S3_70(11.2 billion) for checking fixed population; 
matuse          = MAT_S1_90;        % adapt to: MAT0020  MAT_S1_30  MAT_S1_90  MAT_S2_50  MAT_S3_50  MAT_S5_50  MAT_S2_90  MAT_S3_90  MAT_S5_90
mapuse          = MAP_S1_90; 
savestr         = 'ssp1_2090';      % output file name
pathstr         = folder;           % output file path
ifsave          = false;            % save the niche displacement results (T/F)

% demography change induced displacement (compared with reference) 
disp ('calculating demography change induced displacement ...');

[Surf_niche_Cref_Pfut] =         niche2D(MATwldclm_6090, MAPwldclm_6090, popden_future, false);
[Mapp_niche_Cref_Pfut] = niche2D_mapping(MATwldclm_6090, MAPwldclm_6090, popden_future, x, y, Surf_niche_Cref_Pfut);
% align the data
A = niche2D_0;
B = Mapp_niche_Cref_Pfut;
F = scatteredInterpolant(B(:,1), B(:,2), (1:size(B,1)).', 'nearest');
A_is_nearest_idx = F( A(:,1:2) );
B_closest_to_A = B(A_is_nearest_idx, :);
niche2D_2ref = B_closest_to_A;

disp ('Displacement 2D niche 0-->2ref (%)');
difniche = niche2D_2ref(:,3) - niche2D_0(:,3);
displace_0to2ref = nansum(difniche(difniche>0))/nansum(niche2D_0(:,3)) * 100

%%%% climate induced & combined
Outp_displace_0to1 = [];            %% senario 0 (reference) to scenario 1 (projectting reference Niche to future Climate): displacement induced by climate only
Outp_displace_0to2 = [];            %% senario 0 (reference) to scenario 2 (future Climate + future population): additional displacement induced by demography change
Outp_displace_1to2 = [];            %% senario 1 to scenario 2: displacement induced by climate change and demography change combined
Outp_displace_1to2ref = [];         %% looking at scenario 2 based on reference climate (for checking robustness) 

nclim = size(matuse,2);
for iclim= 1:1:nclim
    disp ('calculating climate induced displacement (model)...');
    iclim

    MAT_future = matuse(:,iclim);
    MAP_future = mapuse(:,iclim);
  
    [Mapp_niche2d_proj_to_FutClim] =  niche2D_mapping(MAT_future, MAP_future, popden_future, x, y, Surf_niche_ref6090);    
    [Surf_niche_Cfut_Pfut] =          niche2D(MAT_future, MAP_future, popden_future, false);
    [Mapp_niche_Cfut_Pfut] =          niche2D_mapping(MAT_future, MAP_future, popden_future, x, y, Surf_niche_Cfut_Pfut);
       
    A = niche2D_0;
    % align the data
    B = Mapp_niche2d_proj_to_FutClim;
    F = scatteredInterpolant(B(:,1), B(:,2), (1:size(B,1)).', 'nearest');
    A_is_nearest_idx = F( A(:,1:2) );
    B_closest_to_A = B(A_is_nearest_idx, :);
    niche2D_1 = B_closest_to_A;
    
    B = Mapp_niche_Cfut_Pfut;
    F = scatteredInterpolant(B(:,1), B(:,2), (1:size(B,1)).', 'nearest');
    A_is_nearest_idx = F( A(:,1:2) );
    B_closest_to_A = B(A_is_nearest_idx, :);
    niche2D_2 = B_closest_to_A;    
         
    clearvars A B A_is_nearest_idx B_closest_to_A;    
   
    % calculate the displacement
    disp ('Displacement 2D niche climate 0-->1 (%)');
    difniche = niche2D_1(:,3) - niche2D_0(:,3);
    displace_0to1 = nansum(difniche(difniche>0))/nansum(niche2D_0(:,3)) * 100

    disp ('Displacement 2D niche demogrp 0-->2 (%)');
    difniche = niche2D_2(:,3) - niche2D_0(:,3);
    displace_0to2 = nansum(difniche(difniche>0))/nansum(niche2D_0(:,3)) * 100

    disp ('Displacement 2D combined niche 1-->2 (%)');
    difniche = niche2D_2(:,3) - niche2D_1(:,3);
    displace_1to2 = nansum(difniche(difniche>0))/nansum(niche2D_1(:,3)) * 100

    disp ('Displacement 2D combined niche 1-->2ref (%)');
    difniche = niche2D_2ref(:,3) - niche2D_1(:,3);
    displace_1to2ref = nansum(difniche(difniche>0))/nansum(niche2D_1(:,3)) * 100

    Outp_displace_0to1 = [Outp_displace_0to1; displace_0to1];
    Outp_displace_0to2 = [Outp_displace_0to2; displace_0to2];
    Outp_displace_1to2 = [Outp_displace_1to2; displace_1to2];
    Outp_displace_1to2ref = [Outp_displace_1to2ref; displace_1to2ref];    
end

if ifsave
    %%%%  save the niche maps
    savefilename_nichemap_n0 = [pathstr 'Niche2D_meanmap_' savestr '_n0.csv'];
    savefilename_nichemap_n1 = [pathstr 'Niche2D_meanmap_' savestr '_n1.csv'];
    savefilename_nichemap_n2 = [pathstr 'Niche2D_meanmap_' savestr '_n2.csv'];
    dlmwrite (savefilename_nichemap_n0,niche2D_0,',');
    dlmwrite (savefilename_nichemap_n1,niche2D_1,',');
    dlmwrite (savefilename_nichemap_n2,niche2D_2,',');
    %%%%  save the displacement results
    savefilename_displace = [pathstr 'displace2Dresult_' savestr '.mat'];
    save (savefilename_displace,'Outp_displace_0to1','Outp_displace_0to2','Outp_displace_1to2','Outp_displace_1to2ref');
end

%%  Section3: regression people outside niche agasint warming (Figure 8a)

x_intercept = 0.3; % force x axis intecpt of 0.3 C (i.e. the reference 1960-1990, corresponding to 0.3 C warming & no displacement )
forceslope = 0;
xv = -1:0.01:5;
dotsize = 3;
C = linspecer(9,'sequential');

figure; 
hold on;

load 'displace2Dresult_alldata_pop69billion.mat';  %% loading the results generated by Section 2
[ypred_0to1,yci_0to1,ypred_1to2,yci_1to2, mdl_0to1, mdl_1to2_69b] = displace_regression(warmingplotx,warmingplot_0to1_y, warmingplot_1to2_y,x_intercept,forceslope,xv);
% climate only
xv = xv + x_intercept;
x_ci = [xv, fliplr(xv)];
y_ci = [yci_0to1(:,1)', flipud(yci_0to1(:,2))']; 
h = fill(x_ci, y_ci, C(1,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(xv,ypred_0to1,'-','LineWidth',2,'Color',C(1,:));
plot(warmingplotx,warmingplot_0to1_y,'o','MarkerSize',dotsize,'Color',C(1,:));

% climate+demography combined
y_ci = [yci_1to2(:,1)', flipud(yci_1to2(:,2))'];
h = fill(x_ci, y_ci, C(2,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(xv,ypred_1to2,'-','LineWidth',2,'Color',C(2,:));
plot(warmingplotx,warmingplot_1to2_y,'o','MarkerSize',dotsize,'Color',C(2,:));

load 'displace2Dresult_alldata_pop95billion.mat';  %% loading the results generated by Section 2
[~,~,ypred_1to2,yci_1to2, ~, mdl_1to2_95b] = displace_regression(warmingplotx,warmingplot_0to1_y, warmingplot_1to2_y,x_intercept,forceslope,xv);
% climate+demography combined
y_ci = [yci_1to2(:,1)', flipud(yci_1to2(:,2))'];
h = fill(x_ci, y_ci, C(3,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(xv,ypred_1to2,'-','LineWidth',2,'Color',C(3,:));
plot(warmingplotx,warmingplot_1to2_y,'o','MarkerSize',dotsize,'Color',C(3,:));

load 'displace2Dresult_alldata_pop112billion.mat';  %% loading the results generated by Section 2
[~,~,ypred_1to2,yci_1to2, ~, mdl_1to2_112b] = displace_regression(warmingplotx,warmingplot_0to1_y, warmingplot_1to2_y,x_intercept,forceslope,xv);
% climate+demography combined
y_ci = [yci_1to2(:,1)', flipud(yci_1to2(:,2))'];
h = fill(x_ci, y_ci, C(8,:));
set(h,'LineStyle','none','facealpha',0.3);
plot(xv,ypred_1to2,'-','LineWidth',2,'Color',C(8,:));
plot(warmingplotx,warmingplot_1to2_y,'o','MarkerSize',dotsize,'Color',C(8,:));

hold off;
box on;
xlabel ('Degree warming (^{o}C)','Fontsize',20); ylabel ('% of population','Fontsize',20); 
xlim([0 5]); ylim([0 80]); 
set(gca,'FontSize',16); 
title ('Displacement 2D niche','Fontsize',12);

% checking regression statistics
mdl_0to1 
mdl_1to2_69b
mdl_1to2_95b
mdl_1to2_112b


