
filename_prepend = './data/dy_Report_';
filename_append = '.xml';
filename_serial = 2009:2018;


max_num_of_date = -1;
num_of_file = length(filename_serial);

filename_list = cell(num_of_file, 1);
legend_list = cell(num_of_file, 1);
for i = 1 : num_of_file
    filename_list{i} = [ ...
        filename_prepend num2str(filename_serial(i)) filename_append];
    legend_list{i} = num2str(filename_serial(i));
end

%%

figure; hold on;
for f = 1 : num_of_file
    
disp(['Processing ' num2str(filename_serial(f))]);
    
filename = filename_list{f};

c = xml2struct(filename);

%%

location_list = c.cwbopendata.dataset.location;


if max_num_of_date <= 0 
    num_of_date = length(location_list{1}.weatherElement.time);
else
    num_of_date = max_num_of_date;
end


num_of_station = length(location_list);

compact_rain_data = cell(num_of_station, num_of_date);
for i = 1 : num_of_station    
    compact_rain_data{i} = ...
        location_list{i}.weatherElement.time;
end

rain_data = zeros(num_of_station, num_of_date);
for i = 1 : num_of_station 
    
    % Remove 'XINWU,??' in 2018
    if filename_serial(f) == 2018
        if i == 29
            continue;
        end
    end
    
    for r = 1 : length(compact_rain_data{i})
        
        day_index = day(datetime(compact_rain_data{i}{r}.dataTime.Text, 'InputFormat', 'yyyy-MM-dd'), 'dayofyear');
                
        rain_data(i, day_index) = str2double(compact_rain_data{i}{r}.elementValue.value.Text);
    end
end

rain_data(isnan(rain_data)) = 0;

plot(cumsum(sum(rain_data)), 'LineWidth',3);
text(num_of_date, sum(sum(rain_data)), legend_list{f});

end

title('Accumulated Rainfall');
ylabel('Rainfall (mm)');
xlabel('Day');

% c.cwbopendata.dataset.location{1}.locationName
% 
% c.cwbopendata.dataset.location{1}.stationId
% 
% c.cwbopendata.dataset.location{1}.weatherElement.time{1}.elementValue.value
