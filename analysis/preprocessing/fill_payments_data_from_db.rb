require 'csv'
require 'set'
require 'colorize'
require 'mysql2'
require 'byebug'

client = Mysql2::Client.new(username: 'root', database: 'desaip')
filename1 = 'output14.csv'

columns_to_add = {[:approval_real_price, :approval_type] => :sum_by}
added_headers = []
total_count = `cat #{filename1} | wc -l`.chomp

columns_to_add.each do |column, agg_method|
  puts "Analyzing #{filename1} ..."
  i = 0
  if agg_method == :count
    column_all_values = client.query("select distinct #{column} from payments").to_a.map(&:values).flatten.map(&:strip)
    output = CSV.generate do |csv|
      CSV.foreach(filename1, headers: true) do |row|
        csv << row.headers + column_all_values.map {|v| "#{column}_#{v}_#{agg_method}"} if i == 0
        i += 1
        print "\r#{i}/#{total_count}"
        panel_id = row['panel_id']

        agg_query = "select #{column}, count(*) from payments where panel_id = '#{panel_id}' and (price != 0 or approval_real_price = 0) group by #{column}"
        agg_key_values = client.query(agg_query).to_a.map(&:values).map {|k, v| [k.strip, v]}.to_h

        additional_key = column_all_values.map {|v| agg_key_values[v] || 0}
        csv << row.to_a.map(&:last) + additional_key
      end
    end
  elsif agg_method == :sum
    output = CSV.generate do |csv|
      CSV.foreach(filename1, headers: true) do |row|
        csv << row.headers + ["#{column}_#{agg_method}"] if i == 0
        i += 1
        print "\r#{i}/#{total_count}"
        panel_id = row['panel_id']

        agg_query = "select sum(#{column}) from payments where panel_id = '#{panel_id}' and (price != 0 or approval_real_price = 0)"
        additional_key = client.query(agg_query).to_a.map(&:values).first
        csv << row.to_a.map(&:last) + additional_key
      end
    end
  elsif agg_method == :sum_by
    output = CSV.generate do |csv|
      CSV.foreach(filename1, headers: true) do |row|
        target_column, agg_column = column
        agg_column_all_values = client.query("select distinct #{agg_column} from payments").to_a.map(&:values).flatten.map(&:strip)
        csv << row.headers + agg_column_all_values.map {|v| "#{target_column}_#{agg_method}_by_#{agg_column}_#{v}"} if i == 0
        i += 1
        print "\r#{i}/#{total_count}"
        panel_id = row['panel_id']

        agg_query = "select #{agg_column}, sum(#{target_column}) from payments where panel_id = '#{panel_id}' and (price != 0 or approval_real_price = 0) group by #{agg_column}"
        agg_key_values = client.query(agg_query).to_a.map(&:values).map {|k, v| [k.strip, v]}.to_h

        additional_key = agg_column_all_values.map {|v| agg_key_values[v] || 0}
        csv << row.to_a.map(&:last) + additional_key
      end
    end
  end

  File.write('output15.csv', output)
end
