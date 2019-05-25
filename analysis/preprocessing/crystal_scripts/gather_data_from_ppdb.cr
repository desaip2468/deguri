require "mysql"
require "csv"

panel_id_array = Array(String).new

# connect to localhost mysql test db
DB.open "mysql://root@localhost/desaip" do |db|
  filename = "../ppdb_data.csv"
  total_count = `cat #{filename} | wc -l`.chomp
  panels_exist_count = 0
  i = 0
  csv = CSV.new(File.open(filename), headers: true)
  while csv.next
    i += 1
    print "\rrow: #{i}/#{total_count}"

    panel_id = csv["id"]
    result = db.scalar "select count(*) from payments where panel_id = '#{panel_id}'"

    if result != 0
      panels_exist_count += 1
      panel_id_array << panel_id
    end


  end

  puts
  puts panels_exist_count

  File.write("panel_ids_in_ppdb", panel_id_array.join(','))

  # puts "contacts:"
  # db.query "select name, age from contacts order by age desc" do |rs|
  #   puts "#{rs.column_name(0)} (#{rs.column_name(1)})"
  #   rs.each do
  #     puts "#{rs.read(String)} (#{rs.read(Int32)})"
  #   end
  # end
end
