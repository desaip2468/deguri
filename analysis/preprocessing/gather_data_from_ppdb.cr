require "csv"

m_headers = (1..27).map {|i| fs = "%02d" % i; "M00#{fs}"}
m_csv_headers = m_headers + %w[total]
m_counts_by_age = Hash(Int32, Hash(String, Int32)).new

# Fill data after compiler type inference
(1..6).each do |i|
  m_counts = Hash(String, Int32).new
  m_csv_headers.each {|m_csv_header| m_counts[m_csv_header] = 0}
  m_counts_by_age[i] = m_counts
end

i = 0
csv = CSV.new(File.open("ppdb_data.csv"), headers: true)
while csv.next
  i += 1
  print "\rrow: #{i}"
  m_h = m_counts_by_age[csv["X0002"].to_i]
  m_h["total"] += 1

  m_headers.each do |m_header|
    m_h[m_header] += 1 if csv[m_header] == "1"
  end
end

puts
puts "Complete!"

generated_csv = CSV.build do |csv|
  csv.row(%w[group] + m_csv_headers)

  (1..6).each do |group|
    values_hash = m_counts_by_age[group]
    csv.row([group] + m_csv_headers.map {|m_csv_header| values_hash[m_csv_header]})
  end
end

# output to file
File.write("output.csv", generated_csv)
