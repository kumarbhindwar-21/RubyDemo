# require 'csv'

# input_file = 'Input.csv'
# output_file = 'Output.dat'
# report_file = 'Comparison_Report.csv'

# # Read Input.csv
# input_data = []
# CSV.foreach(input_file, col_sep: ';') do |row|
#   input_data << row
# end

# # Read Output.dat
# output_data = []
# File.foreach(output_file) do |line|
#   output_data << line.strip.split('|')
# end

# # Generate Report
# CSV.open(report_file, 'w') do |csv|
#   csv << ['Row', 'Input', 'Output', 'Status', 'ExtraData']

#   max_rows = [input_data.size, output_data.size].max

#   (0...max_rows).each do |i|

#     input_row = input_data[i] || []
#     output_row = output_data[i] || []

#     # Convert Output.dat to Input.csv format
#     formatted_output = [
#       output_row[0],
#       "\"#{output_row[1].gsub('"', '')}\"",
#       output_row[2],
#       output_row[3]
#     ]

#     input_string = input_row.join(';')
#     output_string = formatted_output.join(';')

#     status = input_string == output_string ? "PASS" : "FAIL"

#     extra_data = output_row[4..]&.join(';') || ""

#     csv << [
#       i + 1,
#       input_string,
#       output_string,
#       status,
#       extra_data
#     ]
#   end
# end

# puts "Comparison completed successfully."
# puts "Report generated: #{report_file}"
#======================================================New way to compare the files===============================================

# require 'csv'

# input_file = "Input.csv"
# output_file = "Output.dat"
# report_file = "Comparison_Report.csv"

# # Read Input.csv
# input_data = CSV.read(input_file, col_sep: ';')

# # Read Output.dat
# output_data = File.readlines(output_file).map do |line|
#   line.strip.split('|')
# end

# CSV.open(report_file, "w") do |csv|
#   csv << ["Row", "Input", "Matched Output", "Status", "ExtraData"]

#   input_data.each_with_index do |input_row, index|

#     input_string = input_row.join(';')

#     matched = nil

#     # Search current input row in all output rows
#     output_data.each do |output_row|

#       formatted_output = [
#         output_row[0],
#         "\"#{output_row[1].gsub('"','')}\"",
#         output_row[2],
#         output_row[3]
#       ]

#       output_string = formatted_output.join(';')

#       if input_string == output_string
#         matched = {
#           output: output_string,
#           extra: output_row[4..].join(';')
#         }
#         break
#       end
#     end

#     if matched
#       csv << [
#         index + 1,
#         input_string,
#         matched[:output],
#         "PASS",
#         matched[:extra]
#       ]
#     else
#       csv << [
#         index + 1,
#         input_string,
#         "",
#         "FAIL",
#         ""
#       ]
#     end
#   end
# end

# puts "Comparison completed successfully."
#================================3rd version of code========================================================

# require 'csv'

# CONFIG_FILE = "config/file_pairs.csv"
# INPUT_FOLDER = "input"
# OUTPUT_FOLDER = "output"
# REPORT_FOLDER = "reports"

# CSV.foreach(CONFIG_FILE, headers: true) do |row|

#   input_file = File.join(INPUT_FOLDER, row["InputFile"])
#   output_file = File.join(OUTPUT_FOLDER, row["OutputFile"])

#   report_name = File.basename(row["InputFile"], ".csv") + "_Report.csv"
#   report_file = File.join(REPORT_FOLDER, report_name)

#   puts "Comparing..."
#   puts "Input  : #{input_file}"
#   puts "Output : #{output_file}"

#   input_data = CSV.read(input_file, col_sep: ';')

#   output_data = File.readlines(output_file).map do |line|
#     line.strip.split('|')
#   end

#   CSV.open(report_file, "w") do |csv|

#     csv << ["Row","Input","Matched Output","Status","ExtraData"]

#     input_data.each_with_index do |input_row,index|

#       input_string = input_row.join(';')

#       match = output_data.find do |output_row|

#         formatted_output = [
#           output_row[0],
#           "\"#{output_row[1].delete('"')}\"",
#           output_row[2],
#           output_row[3]
#         ].join(';')

#         formatted_output == input_string
#       end

#       if match

#         csv << [
#           index + 1,
#           input_string,
#           [match[0],"\"#{match[1]}\"",match[2],match[3]].join(';'),
#           "PASS",
#           match[4..].join(';')
#         ]

#       else

#         csv << [
#           index + 1,
#           input_string,
#           "",
#           "FAIL",
#           ""
#         ]

#       end

#     end

#   end

#   puts "#{report_name} generated."

# end

# puts "All files compared successfully."
#===============================================================4th version of code========================================================

require 'csv'
require 'fileutils'

CONFIG_FILE = "config/file_pairs.csv"
INPUT_DIR = "input"
OUTPUT_DIR = "output"
REPORT_DIR = "reports"

FileUtils.mkdir_p(REPORT_DIR)

CSV.foreach(CONFIG_FILE, headers: true) do |pair|

  input_file = File.join(INPUT_DIR, pair["InputFile"])
  output_file = File.join(OUTPUT_DIR, pair["OutputFile"])

  report_file = File.join(
    REPORT_DIR,
    "#{File.basename(pair['InputFile'], '.csv')}_Report.csv"
  )

  # Read Input
  input_rows = CSV.read(input_file, col_sep: ';')

  input_header = input_rows.shift

  # Read Output
  output_lines = File.readlines(output_file).map(&:strip)

  output_header = output_lines.shift.split('|')

  output_rows = output_lines.map { |line| line.split('|') }

  CSV.open(report_file, "w") do |csv|

    csv << ["Row","Input","Output","Status","ExtraData"]

    # ---------------- Header Comparison ----------------

    input_header_string = input_header.join(';')

    output_header_string = output_header.first(input_header.length).join(';')

    header_extra = output_header[input_header.length..]&.join(';') || ""

    header_status = input_header_string == output_header_string ? "PASS" : "FAIL"

    csv << [
      "Header",
      input_header_string,
      output_header_string,
      header_status,
      header_extra
    ]

    # ---------------- Data Comparison ----------------

    input_rows.each_with_index do |input_row, index|

      input_string = input_row.join(';')

      matched_output = ""
      extra_data = ""
      status = "FAIL"

      output_rows.each do |output_row|

        output_string = [
          output_row[0],
          "\"#{output_row[1].delete('"')}\"",
          output_row[2],
          output_row[3]
        ].join(';')

        if input_string == output_string

          matched_output = output_string
          extra_data = output_row[4..].join(';')
          status = "PASS"
          break

        end

      end

      csv << [
        index + 1,
        input_string,
        matched_output,
        status,
        extra_data
      ]

    end

  end

  puts "#{report_file} generated."

end

puts "All comparisons completed."