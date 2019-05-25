# Warning: 오래 걸림... 귀찮아서 튜닝 안함

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
      if i == 0
        headers = row.headers
        @new_aggregatable_headers = headers.select {|h| h.match? /category_code_\d{1,2}_count/}

        @header_to_category_number = @new_aggregatable_headers.to_h {|h| [h, "price_sum_of_#{h.gsub('_count', '')}"]}
        @new_aggregated_headers = @header_to_category_number.values.sort.uniq

        csv << headers + @new_aggregated_headers
      end
      i += 1
      print "\r#{i}/#{total_count}"

      new_headers_map = @new_aggregated_headers.to_h {|h| [h, 0]}
      @new_aggregatable_headers.each do |header|
        category_code_number = header.split('_')[2]
        panel_id = row['panel_id']
        db_result = client.query("select coalesce(sum(price), 0) from payments where panel_id = '#{panel_id}' and floor(category_code / 100) = #{category_code_number};").to_a.map(&:values).first.first

        # puts header_to_category_number[header]
        # puts row[header]
        # puts new_headers_map
        new_headers_map[@header_to_category_number[header]] = db_result
      end

      key = row.to_a.map(&:last) + @new_aggregated_headers.map {|h| new_headers_map[h]}

      csv << key
    end
  end
end

File.write('payments_ppdb_app_g_x_price_sum_by_category_code.csv', output)
