#! /usr/bin/ruby

require "json"
require "base64"
require "net/http"

API_URI = "https://api.github.com"

def _create_repo(name)
    # @name: Name of the repository to be created

    if not ENV['git_token'] or not ENV['git_user']
        puts "ERROR: missing git_token and/or git_user in ENV variables"
        exit 1
    end

    payload = {
        "name": name,
        "description": "Test repo",
        "private": false
    }
    
    basic_auth = Base64.strict_encode64("#{ENV['git_user']}:#{ENV['git_token']}")
    headers = {'Authorization': "Basic #{basic_auth}", "Content-Type": "application/json"}

    
    uri = URI.parse("#{API_URI}/user/repos")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = payload.to_json

    response = http.request(request)

    case response
        when Net::HTTPSuccess
            puts "[!] Created repo #{name}"
        else
            puts "ERROR: encountered an error while fetching github api"
            exit(1)
    end    
end

def process_argv(option)
    case option
        when "--help"
            puts "TODO: HELP"
        else
            _create_repo(option)
    end
end

ARGV.each { |option| process_argv(option) }