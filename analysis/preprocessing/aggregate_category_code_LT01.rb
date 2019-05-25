require 'csv'
require 'set'
require 'colorize'
require 'mysql2'

client = Mysql2::Client.new(username: 'root', database: 'desaip')

filename1 = "payments_ppdb_app_g_x_category_code_aggregated.csv"

total_count = `cat #{filename1} | wc -l`.chomp

output = nil
[filename1].each do |file|
  puts "Analyzing #{file} ..."
  i = 0
  output = CSV.generate do |csv|

    CSV.foreach(file, headers: true) do |row|
      csv << row.headers + (1..17).map {|int| "category_code_LT01_#{int}_count"} if i == 0
      i += 1
      print "\r#{i}/#{total_count}"

      new_headers_map = {}

      (1..17).each do |category_code_number|
        panel_id = row['panel_id']
        db_result = client.query("select coalesce(count(*), 0) from payments where panel_id = '#{panel_id}' and approval_type = 'LT01' and floor(category_code / 100) = #{category_code_number};").to_a.map(&:values).first.first

        # puts header_to_category_number[header]
        # puts row[header]
        # puts new_headers_map
        new_headers_map[category_code_number] = db_result
      end

      key = row.to_a.map(&:last) + (1..17).map {|h| new_headers_map[h]}

      csv << key
    end
  end
end

File.write('payments_ppdb_app_category_code_aggregated_LT01.csv', output)
