require 'csv'
require 'mysql2'

client = Mysql2::Client.new(username: 'root', database: 'desaip')
headers = nil

# File with UTF-8 BOM removed: `sed -i '1s/^\xEF\xBB\xBF//' backs.csv`
# File with invalid data removed: `sed '/^NULL/d' backs.csv > backs2.csv`
filename = '/tmp/backs2.csv'

i = 0
total_lines = `cat #{filename} | wc -l`.strip
query_string_body = []
headers = nil
query_string_header = nil

CSV.foreach(filename, headers: true) do |row|
  headers ||= row.headers
  query_string_header ||= "INSERT INTO payments (#{headers.join(', ')}) VALUES "
  query_string_value = "(\"#{row.map {|_h, v| v&.gsub('"', '\"')}.join('", "')}\")".gsub('"NULL"', 'NULL')
  query_string_body << query_string_value
  i += 1
  print "\r#{i}/#{total_lines}"

  if i % 1000 == 0
    query_string = query_string_header + query_string_body.join(', ')
    client.query(query_string)
    query_string_body.clear
  end
end

# Remainder values
query_string = query_string_header + query_string_body.join(', ')
client.query(query_string)
