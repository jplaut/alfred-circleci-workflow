require 'json'
require 'uri'
require 'net/http'
require 'date'

project_query = ARGV[0]
branch_query = ARGV[1]

endpoint      = 'https://circleci.com/api/v1/projects?circle-token'
uri           = URI.parse("#{endpoint}=#{ENV['CIRCLECI_TOKEN']}")
https         = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
req           = Net::HTTP::Get.new(uri.request_uri)
req['Accept'] = 'application/json'
res           = https.request(req)
result        = JSON.parse(res.body)

branches = []

result.each do |project|
  project_name = "#{project['username']}/#{project['reponame']}"

  next unless project_name.match(%r{[^\/]*#{project_query}[^\/]*$}i)

  project["branches"].each do |branch_name, branch|
    next if branch["recent_builds"].nil?

    unless branch_query.nil?
      next unless branch_name.match(%r{[^\/]*#{branch_query}[^\/]*$}i)
    end

    branches << {
      project_name: URI.decode(project_name),
      branch_name: URI.decode(branch_name),
      status: branch['running_builds'].length > 0 ? 'running' : branch['recent_builds'][0]['outcome'],
      last_build: branch['running_builds'].length > 0 ? branch['running_builds'][0]['added_at'] : branch['recent_builds'][0]['added_at'],
      url: "https://circleci.com/gh/#{project_name}/tree/#{branch_name}"
    }
  end
end

xmlstring = "<?xml version=\"1.0\"?>\n<items>\n"

items = branches
.sort { |a, b| DateTime.parse(b[:last_build]) <=> DateTime.parse(a[:last_build]) }
.map do |branch, i|
  if branch[:status] =~ /success|fixed/
    icon = 'green.png'
  elsif branch[:status] == 'running'
    icon = 'blue.png'
  else
    icon = 'red.png'
  end

  autocomplete = branch_query.nil? ? branch[:project_name] : "#{branch[:project_name]} #{branch[:branch_name]}"

  {
    uid: i,
    title: "#{branch[:project_name]} > #{branch[:branch_name]}",
    subtitle: branch[:url],
    arg: branch[:url],
    autocomplete: autocomplete,
    icon: {
      type: "png",
      path: icon
    }
  }
end

puts JSON.dump({ items: items })
