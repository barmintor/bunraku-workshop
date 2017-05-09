

"obj=ldpd_bun_slide_578_2_2280_8404&size=medium"
"size=thumb"

require 'csv'
require 'net/http'

def dlo_link(obj, size='medium')
  URI("http://www.columbia.edu/cgi-bin/dlo?obj=#{obj}&size=#{size}")
end

def link_check(uri)
  Net::HTTP.start(uri.host, uri.port) do |http|
    res = http.head uri
    unless res.is_a?(Net::HTTPSuccess)
      puts "#{uri} does not resolve"
    end
  end
end

all_objid = {}
CSV.foreach("../visuals.csv", headers: true) do |row|
  o = row['objid']
  
  next if (o.nil? || o.empty?) # returning if no link param provided

  # checking to make sure link params are unique
  if all_objid.key?(o)
    puts "WARN: #{o} already exists at id #{all_objid[o]}}"
  else
    all_objid[o] = row['id']
  end

  # Check to make sure thumb and medium sized image exist
  link_check(dlo_link(o, "medium"))
  link_check(dlo_link(o, "thumb"))
end


