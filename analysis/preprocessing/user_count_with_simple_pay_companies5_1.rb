require 'csv'
require 'set'
require 'colorize'

require 'byebug'

filename1 = "EASYPAY_1811_1902_DUPLICATE_REMOVED.csv"

key_by_sms_id = Hash.new

# company_include_names = %w[
#   페이코
#   페이나우
#   삼성페이
# ].to_set
headers = %w[
  panel_id
  gender
  age
  sms_id
  user_id
  user_sim_number
  pattern_id
  category_code
  category_group_code
  rating
  latitude
  longitude
  address
  sms_registration_timestamp
  sms_registration_month
  sms_registration_date
  sms_registration_time
  company_name
  company_code
  originating_address
  package_name
  payment_type
  payment_approval_type
  link_company
  link_originating_address
  transaction_status
  tel_company
  approval_store
  approval_store_detail
  approval_original_price
  approval_price
  approval_unit
  approval_real_price
  accumulated_price
  residual_limit
  approval_point
  point_balance
  approval_method
  approval_date
  approval_time
  is_usable_data
  is_from
  data_source
  data_channel
  registration_timestamp
]

total_count = `cat #{filename1} | wc -l`.chomp

null_count = 0

[filename1].each do |file|
  puts "Analyzing #{file} ..."
  i = 0

  # output = CSV.generate do |csv|
  #   csv << headers
    CSV.foreach(file, headers: true) do |row|
      i += 1
      print "\r#{i}/#{total_count}"
      key = headers.map {|header| row[header]}
      sms_id = row['sms_id']

      if key_by_sms_id.key? sms_id
        key_by_sms_id[sms_id] << key
        company_names = key_by_sms_id[sms_id].map {|item| item[headers.index('link_company')]}.uniq
        if company_names.count > 1
          p company_names 
          p sms_id
        end
      else
        key_by_sms_id[sms_id] = [key]
      end

    end
end


# output = CSV.generate do |csv|
#   csv << headers
#   a50s_set.each do |item|
#     csv << item
#   end
# end
# File.write()
