
% gathers data from file
filename = 'data';
data = xlsread(filename, 'OD700');
time = data(:,1);
timestep = (time(2,1)-time(1,1))/60;

x1 = 1;
x2 = 12;
for i = 1:8     %number of rows in 96-well plate = 8
    
    % plots growth curves
    OD700_data_row = growth_curves(x1,x2,data,time);
    
    % computes growth rate and draws growth rate plots
    % output is growth_rates matrix = time x column(=12)
    growth_rates = growth_rate(time, OD700_data_row, x1, x2, timestep);
    
    % computes maximun growth rate value and time
    [max_growth_rates, index] = max_gr(growth_rates);
    matrixGR(i,:) = max_growth_rates;
    matrixGRindex(i,:) = index;
    
    x1 = x1+12;
    x2 = x2 +12;
    
end

xlswrite('File_12_max_growth_rate_analysis', matrixGR);
xlswrite('File_13_max_growth_rate_index', matrixGRindex);


%% growth curves
function OD700_data_row = growth_curves(x1,x2, data, time)

    % gathers data from file
    OD700_data = data(:,2:end);

    % smoothing initial values for OD700
    t = length(time);
    OD700_data_row = OD700_data(1:end,x1:x2); % data analysis batched per row (1 blank + 11 samples)

    for i= 1:12         % i = Sample (microplate column);      
        for n=2:t       %n = timepoint

            if OD700_data_row(n,i)<=(1.05*OD700_data_row(1,i))
                OD700_data_row(n,i)=(1.05*OD700_data_row(1,i));
            end

        end
        OD700_data_row(1,i) = OD700_data_row(2,i);  % converts first time reading to an equal value as the second time reading
    end

    a = [time OD700_data_row];
    for i = 1:12
        subplot(3,4,i)
        plot(time, OD700_data_row(:,i),'k.','MarkerSize',5)
        xlabel('time (minutes)')
        ylabel('OD700')
        ylim([0 0.6]);
        xlim([0 1500]);
        title('Sample: '  + string(x1-1+i) )
    end
    saveas(gcf,char('Fig_01 - Growth curves - Samples '  + string(x1) + '-' + string(x2)+'.png'))

    xlswrite(char('File_01 - Growth_curves - Samples ' + string(x1) + '-' + string(x2)), a);

    % subtraction of media autofluorescence value. This is required for growth rate
    %calculations
    OD700_data_row = OD700_data_row - OD700_data_row(1,1);
    OD700_data_row(OD700_data_row<0.01) = 0.01;

end

%% growth rate curves
function k = growth_rate(time, OD700_data_row, x1, x2, timestep)

ln_OD700_row = log(OD700_data_row);

time_gr = time(3:end-1);
k = zeros(length(time_gr),12);

for g = 1:12                          
    
    v = zeros(1,length(time_gr));
    
    for i = 3:(length(time)-3)
        A = [ln_OD700_row(i,g)  ln_OD700_row(i-1,g) ln_OD700_row(i+1,g)];
        B = [ln_OD700_row(i-1,g) ln_OD700_row(i-2,g) ln_OD700_row(i,g)];
        y = mean(A) - mean(B);
        growth_r = y/(2*timestep);
        v(1,i)=growth_r;
    end
    k(:,g) = v;
    
end
c=zeros(1,12);
k = [c; c; k; c];
for i = 1:12
    subplot(3,4,i)
    plot(time, k(:,i),'k.','MarkerSize',5)
    xlabel('time (minutes)')
    ylabel('growth rate(h-1)')
    ylim([0 0.8]);
    xlim([0 1500]);
    title('Sample: '  + string(x1-1+i) )
end
saveas(gcf,char('Fig_02 - Growth rate - Samples '  + string(x1) + '-' + string(x2)+'.png'))

xlswrite(char('File_02 - growth_rate_analysis - Samples ' + string(x1) + '-' + string(x2)), k);

end

%% max growth rate calculation
function [max_growth_rates, index] = max_gr(k)

[max_growth_rates, index] = max(k,[],1);
end