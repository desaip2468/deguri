require "csv"

m_csv_headers = %w[
  gender
  age
  area_code1
  area_code2
  area_name1
  area_name2
  registration_timestamp
]

row_by_panel_id = Hash(
  String,
  Array(Array(String))
).new

filename1 = "PAYMENT_201811.csv"
filename2 = "PAYMENT_201812.csv"
filename3 = "PAYMENT_201901.csv"
filename4 = "PAYMENT_201902.csv"

[filename1, filename2, filename3 ,filename4].each do |filename|
  total_count = `cat #{filename} | wc -l`.chomp
  i = 0
  csv = CSV.new(File.open(filename), headers: true)
  while csv.next
    i += 1
    print "\rrow: #{i}/#{total_count}"
    key = m_csv_headers.map {|header| csv[header]}
    panel_id = csv["panel_id"]

    if row_by_panel_id[panel_id]?
      row_by_panel_id[panel_id] << key
    else
      row_by_panel_id[panel_id] = [key]
    end

    # break if i > 1000
  end

  puts
end

generated_csv = CSV.build do |csv|
  csv.row(m_csv_headers)

  row_by_panel_id.each do |panel_id, values|
    # puts values
    gender_values = values.map {|item| item[0]}
    gender_values = gender_values.reject {|item| item.strip == ""}
    if gender_values.size == 0
      gender = "NULL"
    else
      gender = gender_values.map {|item| item[0].to_i}.max
    end

    age = values.map {|item| item[1].to_i}.max

    areas = values.map {|item| item[2..6]}
    areas = areas.reject {|items| items[0].strip == ""}
    if areas.size == 0
      area_code1, area_code2, area_name1, area_name2 = ["NULL"] * 4
    else
      area_code1, area_code2, area_name1, area_name2 = areas.max_by {|items| Time.parse(items.last, "%F %T", Time::Location.local)}[0..3]
    end

    csv.row([panel_id, gender, age, area_code1, area_code2, area_name1, area_name2])
  end
end

# output to file
File.write("output.csv", generated_csv)
