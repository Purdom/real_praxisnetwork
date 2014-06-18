#! /usr/bin/env ruby

require "rubygems"
require "dotenv"
require "google_drive"
require "date"
require "erb"

Dotenv.load

SPREADSHEET_KEY      = ENV.fetch('SPREADSHEET_KEY', '')
USER_EMAIL           = ENV.fetch('USER_EMAIL', '')
USER_PASSWORD        = ENV.fetch('USER_PASSWORD', '')

task :default => 'import:all'

namespace :import do

  module Praxis

    class Page

      PREFIX = "_posts"

      def slugify(string)
        string.to_s.downcase.gsub(/ /, '-')
      end

      def output_file
        @output = "#{PREFIX}/#{@timestamp.strftime('%F')}-#{slugify(@name)}.md"
      end

      def render
        template = File.open(@template, 'r').read
        erb = ERB.new(template)
        erb.result(binding)
      end

      def notice
        "Writing #{output_file}..."
      end

      def save
        puts notice
        File.open(output_file, 'w+') do |file|
          file.write(render)
        end
      end
    end

    class Institution < Page
      @@template = 'institution.erb'

      def initialize(institution)
        @timestamp                 = DateTime.parse(institution[0])
        @name                      = institution[1]
        @email_address             = institution[2]
        @name_of_program           = institution[4]
        @program_url               = institution[8]
        @name_of_institution       = institution[4]
        @address_of_program        = institution[5]
        @mission_statement         = institution[6]
        @areas_of_research_support = institution[7]

        @template                  = 'institution.erb'
      end

    end

    class Student < Page
      @@template = 'student.erb'

      def initialize(student)

      end
    end
  end



  # Creates an autenticated user session with Google Drive
  #
  # @return [Session] GoogleDrive::Session
  def login
    @session ||= GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASSWORD'])
  end

  # Load a worksheet in to memory
  #
  # @param key The key of the Google Drive document to load
  # @return [Worksheet] GoogleDrive::Worksheet
  def get_worksheet(key)
    @worksheet = @session.spreadsheet_by_key(key).worksheets[0]
  end

  def generate_institutions

    institutions = @worksheet.rows.dup
    institutions.shift

    institutions.each do |row|
      i = Praxis::Institution.new(row)
      i.save
    end
  end


  desc "import all institutions."
  task :institutions do
    puts "starting import"

    login
    get_worksheet(ENV['INSTITUTIONS_KEY'])
    generate_institutions

  end

  desc "import all students."
  task :students do
    puts "starting import"

    #this logs me in to google drive and gives me access to my documents
    session = GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASSWORD'])

    #this clarifies which file within google drive i want. this grabs the spreadsheet based on the key and returns worksheet 0
    @worksheet = session.spreadsheet_by_key(ENV['PEOPLE_FORM_KEY']).worksheets[0]

    #this is telling the script to grab each row and then passes it to the method write_markdown, which
    for row in 2..@worksheet.num_rows
      #2..ws.num_rows.each do |row|
      write_instmarkdown row 

    end
  end

  desc "Generate markdup for both institutions and students"
  task :all => ['import:institutions', 'import:students']

end

def make_name (string)
  string.gsub(/ /,"_").downcase
end

def write_file(timestamp,base_name, contents)
  #This writes a file in the subdirectory 'posts'
  begin
    time = "#{timestamp}"
    Date.strftime(time, "%F")
    file = File.open("_posts/#{base_name}.md", "w")
    file.write(contents)
  rescue IOError => e
    puts "File not writable."
  ensure
    file.close unless file == nil
  end


end

#This method writes a markdown file (for students) for any row passed to it
def write_studentmarkdown (row)
  timestamp                   = @worksheet[row, 1]
  name                        = @worksheet[row, 2]
  email                       = @worksheet[row, 3]
  name_of_program             = @worksheet[row, 7]
  year_entering_fellowship    = @worksheet[row, 4]
  personal_website_url        = @worksheet[row, 5]
  twitter_handle              = @worksheet[row, 6]
  base_name              = make_name name

  contents               = "---
layout: post 
status: publish
permalink: posts/students/#{base_name}
title: #{name}
categories: 
elsewhere:
  website: #{personal_website_url}
---
# #{name}

  #{name_of__of_program}
  #{year_entering_fellowship}
  #{personal_website_url}
  #{twitter_handle}

  "
end

#This method writes a markdown file (for institutions) for any row passed to it
def write_instmarkdown (row)
  timestamp                   = @worksheet[row, 1]
  name                        = @worksheet[row, 2]
  email_address               = @worksheet[row, 3]
  name_of_program             = @worksheet[row, 4]
  program_url                 = @worksheet[row, 9]
  name_of_institution         = @worksheet[row, 5]
  address_of_program          = @worksheet[row, 6]
  mission_statement           = @worksheet[row, 7]
  areas_of_research_support   = @worksheet[row, 8]
  base_name              = make_name name_of_program
  puts areas_of_research_support
  contents               = "---
layout: posts 
status: publish
#permalink: posts/institutions/#{base_name}
title: #{name_of_program}
categories: 
elsewhere:
  website: #{program_url}
categories:
  - institutions
---
# #{name_of_program}

  #{name_of_institution}

## Mission Statement

  #{mission_statement}

  "
  write_file("institutions", base_name, contents)
  #This writes a file in the subdirectory 'institutions'
  # begin
  #file = File.open("_institutions/#{base_name}.md", "w")
  #puts "Writing file for #{base_name}"
  #file.write(contents) 
  #rescue IOError => e
  #puts "File not writable."
  #ensure
  #file.close unless file == nil
  #end

  #
end





#end
