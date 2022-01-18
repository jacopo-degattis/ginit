#! /usr/bin/ruby

require "json"
require "base64"
require "optparse"
require "net/http"

VERSION = "0.1.0"
API_URI = "https://api.github.com"

def _create_local_folder(name)
    if !File.exists?(name)
        Dir.mkdir(name)
        Dir.chdir("./#{name}")
        system 'git init'
        system 'touch README.md'
        system 'touch LICENSE'
        system 'git branch -M master'
        system "git remote add origin https://github.com/#{ENV['git_user']}/#{name}"
        system 'git add .; git commit -S -m "Initial commit"'
    end
    
end

def _create_repo(name, description = "", priv = true)
    # @name: Name of the repository to be created

    if not name
        puts "ERROR: repository must have a name"
        exit(1)
    end

    payload = {
        "name": name,
        "description": description,
        "private": priv
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
            _create_local_folder(name)
        else
            puts "ERROR: encountered an error while fetching github api"
            exit(1)
    end    
end

def _print_help()
    puts "ginit #{VERSION}\nUtility to clone repo subfolders and files\n\nUSAGE:\n\tginit <repo-name>\n\n"
end

options = OpenStruct.new
OptionParser.new do |opt|
    opt.on("-n", "--name repo_name", "The repository name") { |o| options.name = o}
    opt.on("-d", "--description repo_description", "The repository description") { |o| options.description = o}
    opt.on("-v", "--visibility repo_visibility", "Whether repo is private or public") { |o| options.visibility = o}
end.parse!

if not ENV['git_token'] or not ENV['git_user']
    puts "ERROR: missing git_token and/or git_user in ENV variables"
    exit 1
end

if not options.name
    print "- Input repository name (default: test): "
    options.name = gets.chomp
end

if not options.description
    print "- Input repository description (default: ''): "
    options.description = gets.chomp
end

if not options.visibility
    print "- Input repository visibility ( public / private ) - (default to private): "
    options.visibility = gets.chomp
end

if not ['private', 'public'].include? options.visibility
    puts "ERROR: visibility must be either 'public' or 'private'"
    exit(1)
end

if options.visibility == 'public'
    _create_repo(options.name, options.description, false)
else
    _create_repo(options.name, options.description, true)
end