function [outputArg1] = niche2D_mapping(inputArg1,inputArg2,inputArg3,inputArg4, inputArg5, inputArg6)

xfactor = inputArg2;
yfactor = inputArg1;
zfactor = inputArg3;
xcor = inputArg4;
ycor = inputArg5;
niche2d_surface = inputArg6;


map_range = [0 4000];                               % data range mean annual temperature
mat_range = [-10 40];                               % data range mean annual precipitation
datarange =  [map_range(1) map_range(2) mat_range(1) mat_range(2)];
out_res = 100; 
nichefactor = 1e6;

[~,~,standard_nichevalue] = ...
    cloudensityExtract2(xfactor,yfactor,zfactor,datarange,false,[out_res,out_res],true,[7,7],niche2d_surface);

point_in_datarange = xfactor<=datarange(2) & xfactor>=datarange(1) & yfactor<=datarange(4) & yfactor>=datarange(3);
xwithin = xcor(point_in_datarange);
ywithin = ycor(point_in_datarange);
xoutside = xcor(~point_in_datarange);
youtside = ycor(~point_in_datarange);
niche_outside = xoutside * 0.0; %% make sure consistent vector length
xoutput = [xwithin;xoutside];
youtput = [ywithin;youtside];
niche_output_point = [standard_nichevalue;niche_outside];  %% denvalue is for the point within the range
nicheProjected_maps = normsumunity(nichefactor,niche_output_point);

output_niche_mapping = [xoutput youtput nicheProjected_maps];
outputArg1 = output_niche_mapping;

fig = gcf; close(fig);

end

