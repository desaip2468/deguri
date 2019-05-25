require 'csv'
require 'set'
require 'colorize'

require 'byebug'

filename1 = "EASYPAY_1811_1902_DUPLICATE_REMOVED_BY_SMS_ID_REVISED_V2.csv"

headers = %w[
  company_name
  company_code
  link_company
  accumulated_price
  residual_limit
  approval_point
  point_balance
]
key_by_sms_id = Hash.new

total_count = `cat #{filename1} | wc -l`.chomp

null_count = 0

[filename1].each do |file|
  puts "Analyzing #{file} ..."
  i = 0

  CSV.foreach(file, headers: true) do |row|
    i += 1
    print "\r#{i}/#{total_count}"
    key = headers.map {|header| row[header]}
    price = row['accumulated_price']

    key_by_sms_id[sms_id] ||= key
  end

  File.write('key_by_sms_id', Marshal.dump(key_by_sms_id))
end
