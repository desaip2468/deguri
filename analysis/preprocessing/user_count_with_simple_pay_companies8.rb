require 'csv'
require 'set'
require 'colorize'

require 'byebug'

filename1 = "PAYMENT_201812.csv"

headers = %w[
  company_name
  company_code
  link_company
  accumulated_price
  residual_limit
  approval_point
  point_balance
]
total_count = `cat #{filename1} | wc -l`.chomp

[filename1].each do |file|
  puts "Analyzing #{file} ..."
  i = 0

  CSV.foreach(file, headers: true) do |row|
    i += 1
    # print "\r#{i}/#{total_count}"
    key = headers.map {|header| row[header]}

    raise if row['price'] == 'NULL'
  end
end
