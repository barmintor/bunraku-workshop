# encoding: UTF-8
require 'csv'
DLO = "http://www.columbia.edu/cgi-bin/dlo"
linked_visuals = {}
CSV.foreach("linked_visuals.csv", headers: :first_row) { |row| linked_visuals[row[0]] = row[1].to_i }
creators = {
	"Toyotake Komatsudayū II"=>123,
	"Barbara Curtis Adachi"=>124,
	"Harri Peccinotti"=>125,
	"Fukuda Fumio"=>126,
	"M. Arai"=>127,
	"Unknown. Photo: Columbia University Libraries"=>128
}
transform = CSV.generate do |csv|
	ctr = -1
	# id,data_id,colser_id,series_number,sequence_number,item_id,subjecttype_id,slidepage_folder_no,container_type,container_number,folder_title,notes_on_item,creator,online_image,objid,mediumURL,thumbURL,jp2URL
	CSV.foreach("visuals.csv") do |row|
		# ldpd_bun_slide_452_2_0001_0001
		# should be ['ldpd_bun_slide',slidepage_folder_no,series_number,sequence_number,item_id]
		row = row[0...-3]

		if (ctr += 1) == 0
			row << :dlo
			csv << row
			next
		end

		objid = row[-1]
		next unless linked_visuals[row[0]]

		row[12] = creators[row[12]]
		row << (objid.to_s != "")
		unless row[-1]
			csv << row
			next
		end

		subjecttype_id = row[6].to_i
		if subjecttype_id == 20
			type_prefix = 'realia'
			type_suffix = row[5].gsub('-','')
		elsif subjecttype_id == 48
			type_prefix = 'album'
			type_suffix = row[3] + '_' + row[5].gsub('-','')
		elsif subjecttype_id == 47
			type_prefix = "slide_#{row[7]}"
			type_suffix = "#{row[3]}_#{row[4]}_#{row[5]}"
		else
			type_prefix = "unknown-#{subjecttype_id}"
			type_suffix = nil
		end

		parts =  ['ldpd_bun',type_prefix]
		parts << type_suffix if type_suffix

		expected = parts.join('_')
		raise "\"#{row[0]}\" subjecttype_id: #{subjecttype_id} expected #{expected} actual #{objid}" unless objid.eql? expected
		csv << row
	end
end
open("visuals-transform.csv",'w') {|b| b.write(transform) }
