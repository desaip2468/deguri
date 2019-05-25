require 'csv'
require 'set'
require 'colorize'

src_filename = 'output16.csv'
dst_filename = 'refine_categorytime_g.csv'

dst_headers = %w[
  Total_UsageTime
]

total_count = `cat #{src_filename} | wc -l`.chomp
panel_ids_set = Set.new

puts "Gathering panel_id sets from #{src_filename}"
i = 0
total_count = `cat #{src_filename} | wc -l`.chomp

CSV.foreach('output10.csv', headers: true) do |row|
  i += 1
  print "\r#{i}/#{total_count}"
  panel_ids_set << row['panel_id']
end

puts "Analyzing #{dst_filename} ..."

if File.exist?('all_dst_file_sub_categories') && File.exist?('dst_hash')
  all_dst_file_sub_categories = Marshal.load(File.read('all_dst_file_sub_categories'))
  dst_hash = Marshal.load(File.read('dst_hash'))
else
  all_dst_file_sub_categories = Set.new
  dst_hash = {}

  i = 0
  total_count = `cat #{dst_filename} | wc -l`.chomp
  CSV.foreach(dst_filename, headers: true) do |row|
    i += 1
    print "\r#{i}/#{total_count}"

    panel_id = row['panel_id']
    next unless panel_ids_set.include? panel_id
    
    all_dst_file_sub_categories << row['category1_kr']
    
    dst_hash[panel_id] ||= Hash.new 0
    dst_hash[panel_id][row['category1_kr']] += row['Total_UsageTime'].to_i

    # break if i > 1000
  end

  File.write('all_dst_file_sub_categories', Marshal.dump(all_dst_file_sub_categories))
  File.write('dst_hash', Marshal.dump(dst_hash))
  
end
# exit 0

all_dst_file_sub_categories = all_dst_file_sub_categories.to_a

puts "Generating output ..."
i = 0
total_count = `cat #{src_filename} | wc -l`.chomp
output = CSV.generate do |csv|
  CSV.foreach(src_filename, headers: true) do |row|
    csv << row.headers + all_dst_file_sub_categories.map {|c| "#{c}_usagetime"} if i == 0
    i += 1
    print "\r#{i}/#{total_count}"
    panel_id = row['panel_id']
    next unless dst_hash.key? panel_id
    # next if row['Y0001'] == 'NULL'

    key = all_dst_file_sub_categories.map {|c| dst_hash[panel_id][c] || 0}
    csv << row.to_a.map(&:last) + key
  end
end

File.write('payments_ppdb_app_g2.csv', output)
