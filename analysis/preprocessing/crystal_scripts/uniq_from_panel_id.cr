require "csv"

key_by_panel_id = Hash(String, Array(String)).new

filename1 = "PAYMENT_201811.csv"
filename2 = "PAYMENT_201812.csv"
filename3 = "PAYMENT_201901.csv"
filename4 = "PAYMENT_201902.csv"

[filename1, filename2, filename3, filename4].each do |filename|
  csv = CSV.new(File.open(filename), headers: true)
  while csv.next
    panel_id = csv["panel_id"]
    key = csv["area_name1"]

    if key_by_panel_id[panel_id]?
      key_by_panel_id[panel_id] << key
    else
      key_by_panel_id[panel_id] = [key]
    end
  end
end

key_by_panel_id.each do |k, v|
  uniq_values = v.uniq
  next if uniq_values.size == 1

  puts k, uniq_values
end
