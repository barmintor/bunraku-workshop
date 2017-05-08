# linked_visuals.rb
require 'csv'

linked_visuals = Hash.new(0)
files = [
"characters_visuals.csv", # character_id,visual_id
"kashiras_visuals.csv", # kashira_id,visual_id
"performers_visuals.csv", # performer_id,visual_id
"playproductions_visuals.csv", # performer_id,visual_id
"plays_visuals.csv", #
"productions_visuals.csv", # production_id,visual_id
# "sceneproductions_visuals.csv", # EMPTY!
"scenes_visuals.csv", # scene_id,visual_id
"subjects_visuals.csv" # subject_id,visual_id
]
files.each do |file|
	CSV.foreach(file, headers: :first_row) do |row|
		linked_visuals[row[1]] += 1
	end
end
puts "visual_id,links"
linked_visuals.each { |k, v| puts "#{k},#{v}" }