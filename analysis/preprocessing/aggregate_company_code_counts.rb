require 'csv'
require 'set'
require 'colorize'

filename1 = "payments_ppdb_app_g2.csv"

total_count = `cat #{filename1} | wc -l`.chomp

output = nil
[filename1].each do |file|
  puts "Analyzing #{file} ..."
  i = 0
  output = CSV.generate do |csv|

    CSV.foreach(file, headers: true) do |row|
      if i == 0
        headers = row.headers
        @new_aggregatable_headers = headers.select {|h| h.start_with? 'company_code'}

        @header_to_category_number = @new_aggregatable_headers.to_h {|h| [h, "company_code_#{h.split('_')[2][0..1]}_count"]}
        @new_aggregated_headers = @header_to_category_number.values.sort.uniq

        csv << headers + @new_aggregated_headers
      end
      i += 1
      print "\r#{i}/#{total_count}"

      new_headers_map = @new_aggregated_headers.to_h {|h| [h, 0]}
      @new_aggregatable_headers.each do |header|
        # puts header_to_category_number[header]
        # puts row[header]
        # puts new_headers_map
        new_headers_map[@header_to_category_number[header]] += row[header].to_i
      end

      key = row.to_a.map(&:last) + @new_aggregated_headers.map {|h| new_headers_map[h]}

      csv << key

    end
  end
end

File.write('payments_ppdb_app_g2_company_code_aggregated.csv', output)
