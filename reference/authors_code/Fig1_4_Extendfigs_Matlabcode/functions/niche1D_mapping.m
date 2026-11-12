function [outputArg1] = niche1D_mapping(inputArg1,inputArg2, inputArg3, inputArg4, inputArg5)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nichefactor = 1e6;

mat_use = inputArg1;
fitmatgaus = inputArg2;

xcor = inputArg3;
ycor = inputArg4;
ismapping = inputArg5;

niche_mat = fitmatgaus(mat_use);         
niche_mat_norm = normsumunity(nichefactor,niche_mat);       % normalize niche to sum unity
output_niche_to_map = [xcor ycor niche_mat_norm];

if ismapping==true
    figure;
    heatmapcompute(output_niche_to_map(:,1),output_niche_to_map(:,2),output_niche_to_map(:,3),[-180 180 -60 90],false,true,[4200,1800],false);
    colormap('jet');
    title('Temperature Niche');
end

outputArg1 = output_niche_to_map;
end

