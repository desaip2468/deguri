require 'csv'
require 'set'
require 'colorize'

require 'byebug'

filename1 = "PAYMENT_201811.csv"
filename2 = "PAYMENT_201812.csv"
filename3 = "PAYMENT_201901.csv"
filename4 = "PAYMENT_201902.csv"

headers = %w[
  panel_id
  gender
  age
  area_code1
  area_code2
  area_name1
  area_name2
  approval_type
  category_code
  category_group_code
  company_name
  approval_price
  company_code
  card_payment_type
  card_name
  approval_real_price
  price
]
easypay_headers = %w[
  easypay_company_name
  easypay_company_code
  easypay_link_company
  easypay_accumulated_price
  easypay_residual_limit
  easypay_approval_point
  easypay_point_balance
]
easypay_key_by_sms_id = Marshal.load(File.read('key_by_sms_id'))

output = CSV.generate do |csv|
  csv << headers + easypay_headers

  [filename1, filename2, filename3, filename4].each do |file|
    puts "Analyzing #{file} ..."
    total_count = `cat #{file} | wc -l`.chomp
    i = 0

    CSV.foreach(file, headers: true) do |row|
      i += 1
      print "\r#{i}/#{total_count}"
      
      next unless (50..1000).include?(row['age'].to_i)

      key = headers.map {|header| row[header]}

      if easypay_key_by_sms_id.key?(row['sms_id'])
        key += easypay_key_by_sms_id[row['sms_id']]
      else
        key += easypay_headers.map {'NULL'}
      end

      csv << key
    end
  end
end

File.write('PAYMENT_5060S_WITH_EASYPAY_DATA.csv', output)
