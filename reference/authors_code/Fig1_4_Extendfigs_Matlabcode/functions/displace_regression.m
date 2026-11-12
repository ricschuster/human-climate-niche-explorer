function [outputArg1,outputArg2,outputArg3,outputArg4,outputArg5, outputArg6] = displace_regression(warmingplotx,warmingplot_0to1_y, warmingplot_1to2_y,x_intercept,forceslope, xv)

% 'warmingplotx', 'warmingplot_0to1_y','warmingplot_0to2_y','warmingplot_1to2_y'
warmingplotx_offset = warmingplotx - x_intercept; % to force x-axis intercept at 0.3 C 

tbl_0to1 = table(warmingplotx_offset,warmingplot_0to1_y);
tbl_1to2 = table(warmingplotx_offset,warmingplot_1to2_y);

modelspec_0to1 = 'warmingplot_0to1_y ~ -1 + warmingplotx_offset ';
mdl_0to1 = fitlm(tbl_0to1,modelspec_0to1);
mdl_0to1_slope = mdl_0to1.Coefficients.Estimate; % force the slope to be the same

% not forcing same slope
if forceslope == 1
    b0 = [18];
    %options for fitnlm
    options = statset('Display','iter','TolFun',1e-10);
    % f_1to2 = @(b,x) 21.2210 + 11.7816*x;
    f_1to2 = @(b,x) b(1) + b(2)*x;
    f_1to2 = @(b,x) f_1to2([b(1), 11.7816],x);
    % Fit the data
    mdl_1to2 = fitnlm(tbl_1to2,f_1to2,b0,'Options',options);
else 
    modelspec_1to2 = 'warmingplot_1to2_y ~ 1 + warmingplotx_offset';
    mdl_1to2 = fitlm(tbl_1to2,modelspec_1to2);
end

xv2 = xv';
[ypred_0to1,yci_0to1] = predict(mdl_0to1,xv2);
[ypred_1to2,yci_1to2] = predict(mdl_1to2,xv2);

outputArg1 = ypred_0to1;
outputArg2 = yci_0to1;
outputArg3 = ypred_1to2;
outputArg4 = yci_1to2;
outputArg5 = mdl_0to1;
outputArg6 = mdl_1to2;

end