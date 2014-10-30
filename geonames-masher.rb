#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'
require_relative 'lib/icu4j-53_1.jar'

def normalize(input_string)
  if input_string.nil?
    return ""
  else
    return Java::ComIbmIcuText::Transliterator.getInstance('Any-Latin; Lower; NFD; [:Nonspacing Mark:] Remove; [:Punctuation:] Remove; NFC').transliterate(input_string)
  end
end

def add_resource_name(resource_names_hash, name, id)
  unless name.nil?
    transliterated_name = normalize(name)

    if resource_names_hash[transliterated_name].nil?
      resource_names_hash[transliterated_name] = []
    end

    unless resource_names_hash[transliterated_name].include?(id)
      resource_names_hash[transliterated_name] << id
    end
  end
end

input_csv_filename = ARGV[0]
geonames_csv_filename = ARGV[1]
toponym_columns = ARGV[2..-1]

geonames = {}
geonames_names = {}
$stderr.puts "Parsing GeoNames..."
# geonames_csv_string = File.open(geonames_csv_filename, "rb").read.force_encoding('UTF-8').encode('UTF-8', :invalid => :replace)
# CSV.parse(geonames_csv_string, :headers => false, :col_sep => "\t", :quote_char => "\u{FFFF}") do |row|
File.open(geonames_csv_filename, "rb") do |geonames_csv|
  geonames_csv.each_line do |line|
    row = line.force_encoding('UTF-8').encode('UTF-8', :invalid => :replace).split("\t")
    id = row[0]
    # exclude by featurecode for e.g. airports here, feel free to expand
    unless %w{RSTN AIRP AIRH AIRB AIRF ASTR BUSTN BUSTP MFG}.include?(row[7])
      geonames[id] = {}
      geonames[id]["id"] = id
      geonames[id]["name"] = row[1]
      geonames[id]["asciiname"] = row[2]
      geonames[id]["alternatenames"] = row[3].nil? ? [] : row[3].split(',')
      geonames[id]["latitude"] = row[4].to_f
      geonames[id]["longitude"] = row[5].to_f
      geonames[id]["featureclass"] = row[6]
      geonames[id]["featurecode"] = row[7]

      ([geonames[id]["name"], geonames[id]["asciiname"]] + geonames[id]["alternatenames"]).each do |name|
        add_resource_name(geonames_names, name, id)
      end
    end
  end
end

input_csv = CSV.read(input_csv_filename, :headers => true)
$stderr.puts input_csv.headers
output_headers = input_csv.headers + ["geonames matches"]
csv_output = CSV.generate do |csv|
  csv << output_headers
  input_csv.each do |row|
    geonames_matches = []
    toponym_columns.each do |toponym_column|
      normalized = normalize(row[toponym_column])
      unless (normalized == "") || geonames_names[normalized].nil?
        geonames_matches += geonames_names[normalized]
      end
    end
    geonames_matches.flatten!
    geonames_matches.reject!{|g| g.nil?}
    geonames_matches.uniq!
    geonames_matches.map!{|g| "http://sws.geonames.org/#{g}/"}
    csv << (row.fields + [geonames_matches.join("\n")])
  end
end

puts csv_output
