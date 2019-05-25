require 'csv'
require 'set'
require 'colorize'

require 'byebug'

filename1 = "refine_apptime.csv"

key_by_panel_id = Set.new

# company_include_names = %w[
#   페이코
#   페이나우
#   삼성페이
# ].to_set
headers = %w[
  panel_id
  gender
  age
]

total_count = `cat #{filename1} | wc -l`.chomp

[filename1].each do |file|
  puts "Analyzing #{file} ..."
  i = 0

  # output = CSV.generate do |csv|
  #   csv << headers
    CSV.foreach(file, headers: true) do |row|
      i += 1
      print "\r#{i}/#{total_count}"
      panel_id = row['panel_id']

      key_by_panel_id << panel_id
    end
end

puts
File.write('app_panel_ids', key_by_panel_id.to_a.join(','))
