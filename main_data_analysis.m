%% General Information

% Nicolas Kylilis, PhD
% 13th April 2018

% Matlab program for the automatic analysis of microplate reader data from
% experiments with bacterial cultures

% INSTRUCTIONS FOR THE USER
% - save microplate reader data as an xlxs document named "data". 


%% Modules / 
% - remove percentage symbol[%] to activate modules()
warning('off','all');

% - growth_rate_module has no dependencies.
% - for this module: i) rename an xlxs sheet as "OD700"; ii)Add 
%   time(in minutes) in column A; iii) Add OD readings from column B onwards
growth_rate_module;

% - fluorescence_module(FP) dependencies: growth_rate_module
% - for this module: i) rename an xlxs sheet as "FP"; ii)Add 
%   time(in minutes) in column A; iii) Add fluorescence readings from column B onwards
FP = 'YFP';
fluorescence_module(FP);

% add here more fluorescence modules for other fluorescent reportes
% Example:
% FP = 'RFP'
% fluorescence_module(FP);


disp('Program finished')
