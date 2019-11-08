function fluorescence_module(FP)

% gathers data from file
filename = 'data';
data = xlsread(filename, FP);
time = data(:,1);
timestep = (time(2,1)-time(1,1))/60;
GFPdata = data(:,2:end);
index = csvread('File_13_max_growth_rate_index.csv');
max_gr = csvread('File_12_max_growth_rate_analysis.csv');

%% total GFP
% Plot total well fluorescence
x1 = 1;
x2 = 12;
g = [time GFPdata];
for row = 1:8 %repeats
        for i = 1:12
            subplot(3,4,i)
            plot(time, GFPdata(:,x1-1+i),'k.','MarkerSize',5)
            xlabel('Time (minutes)')
            ylabel('Fluorescence (au)')
            %title('Sample: '  + string(x1-1+i) )
        end
        saveas(gcf,char('Fig_03 - Total well Fluorescence Intensity - Samples '  + string(x1) + '-' + string(x2)+'.png'))
        xlswrite(char('File_03 - Total well Fluorescence Intensity - Samples ' + string(x1) + '-' + string(x2)), g);

        x1 = x1+12;
        x2 = x2+12;
end

% correct fluorescence signal for media autofluorescence
x1 = 1;
x2 = 12;
for row = 1:8 %repeats
    
    for col = x1+1:x2 % samples

        GFPdata(:,col) = GFPdata(:,col) - GFPdata(:,x1);
        if col == x2
            GFPdata(:,x1) = GFPdata(:,x1) - GFPdata(:,x1);
        end

    end
    
    x1 = x1+12;
    x2 = x2+12;
end
GFPdata(GFPdata<0) = 0;
xlswrite('File_21-'+string(FP)+'_data', GFPdata);

%% GFP per cell
abs_data = xlsread(filename, 'OD700');
OD700data = abs_data(:,2:end);

x1 = 1;
x2 = 12;
% correct OD700 for media absorbance
for row = 1:8   % microplate rows
    
    for col = (x1+1):x2   %microplate columns

        OD700data(:,col) = OD700data(:,col) - OD700data(:,x1);
        
        if col == x2
            OD700data(:,x1) = OD700data(:,x1) - OD700data(:,x1);
        end
            

    end
    
    x1 = x1+12;
    x2 = x2+12;
end
OD700data(OD700data<0.01) = 0;
xlswrite('File_22 - media absorbance corrected OD700', OD700data);

GFP_per_cell = GFPdata./OD700data;

x1=1;
x2=12;
for j=1:8
 
    h=1;
    for s = x1:x2
        subplot(3,4,h)
        plot(time, GFP_per_cell(:,s),'k.','MarkerSize',5)
        xlabel('time (minutes)');
        ylabel(string(FP) + 'fluoresce/cell');
        xlim([0 1500]);
        %title('Sample: '  + string(s));
        vline(index(j,h)*20-20, 'r--', 'max gr');
        h = h+1;
    end
    saveas(gcf, char('Fig_04-' + string(FP) + 'percell-Samples' + string(x1) + '-' + string(x2)+'.png'))
    
    a = [time GFP_per_cell(:,x1:x2)];
    xlswrite(char('File_04-'+ string(FP) + 'percell - Samples ' + string(x1) + '-' + string(x2)), a);
    
    x1 = x1+12;
    x2 = x2+12;
end

%% GFP production rate per cell

[m,n] = size(GFP_per_cell);
GFP_pr_matrix = zeros(m,n);
x1 = 1;
x2 = 12;
p = length(time);
for rep = 1:8
    
    for sample =x1:x2
        for tp = 3:(p-1)
            t0 = [GFP_per_cell(tp, sample) GFP_per_cell(tp-1, sample) GFP_per_cell(tp+1, sample)];
            tminus1 = [GFP_per_cell(tp-1, sample) GFP_per_cell(tp-2, sample) GFP_per_cell(tp, sample)];
            prod_rate = (mean(t0) - mean(tminus1))/timestep;
            GFP_pr_matrix(tp, sample) = prod_rate;
        end

    end
    
    x1 = x1+12;
    x2 = x2+12;
end

x1=1;
x2=12;
for j=1:8
    h=1;
    for s = x1:x2
        subplot(3,4,h)
        plot(time, GFP_pr_matrix(:,s),'k.','MarkerSize',5)
        xlabel('time (minutes)');
        ylabel(string(FP) + ' prod.rate (au/h)');
        xlim([0 1500]);
        %title('Sample: '  + string(s));
        vline(index(j,h)*20-20, 'r--', 'max gr');
        h = h+1;
    end
    saveas(gcf,char('Fig_05-'+ string(FP) + 'production rate- Samples '  + string(x1) + '-' + string(x2)+'.png'))
    
    a = [time GFP_pr_matrix(:,x1:x2)];
    xlswrite(char('File_05-'+ string(FP) + 'production rate - Samples ' + string(x1) + '-' + string(x2)), a);
    
    x1 = x1+12;
    x2 = x2+12;
end
%% GFP expression rate

% production rate at max growth rate
x1=1;
x2=12;
rate = zeros(8,12);
for r = 1:8
    exp_rate_mat = [];
    for s = 1:12
        max = max_gr(r,s);
        %disp(max);
        index_max_gr = index(r,s);
        %disp(index_max_gr)
        expr_rate = (GFP_per_cell(index_max_gr,x1-1+s)-GFP_per_cell(index(r,2),x1+1))*max; %(fluorescence/cell for sample at max growth rate time point) - (fluorescence/cell for empty cell at amxgrowth rate time point)
        exp_rate_mat = [exp_rate_mat expr_rate];
        
    end
    rate(r,:) = exp_rate_mat;
    x1 = x1+12;
    x2 = x2+12;
end

xlswrite(char('File_23-'+string(FP) + '_expression rates'), rate);
end
