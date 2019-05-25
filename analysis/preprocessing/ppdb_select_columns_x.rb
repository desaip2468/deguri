require 'csv'
require 'set'
require 'colorize'

src_filename = 'payments_ppdb_app_g2.csv'
dst_filename = 'ppdb_data.csv'

panel_ids_set = Set.new

puts "Gathering panel_id sets from #{src_filename}"
i = 0
total_count = `cat #{src_filename} | wc -l`.chomp

CSV.foreach(src_filename, headers: true) do |row|
  i += 1
  print "\r#{i}/#{total_count}"
  panel_ids_set << row['panel_id']
end

puts "Analyzing #{dst_filename} ..."
dst_hash = {}

save_headers = %w[
  X0001
  X0002
  X0003
  X0004
  X0005
  X0006
  X0007
  X0008
  X0009
]

i = 0
total_count = `cat #{dst_filename} | wc -l`.chomp
CSV.foreach(dst_filename, headers: true) do |row|
  panel_id = row['id']
  i += 1
  print "\r#{i}/#{total_count}"
  if panel_ids_set.include? panel_id
    dst_hash[panel_id] = save_headers.map {|header| row[header]}
  end
end

puts "Generating output ..."
i = 0
total_count = `cat #{src_filename} | wc -l`.chomp
output = CSV.generate do |csv|
  CSV.foreach(src_filename, headers: true) do |row|
    csv << row.headers + save_headers if i == 0
    i += 1
    print "\r#{i}/#{total_count}"
    panel_id = row['panel_id']
    next unless dst_hash[panel_id]

    key = dst_hash[panel_id]
    csv << row.to_a.map(&:last) + key
  end
end

File.write('payments_ppdb_app_g_x.csv', output)
