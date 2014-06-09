#! /usr/bin/env ruby

#This is what the script requires to run, what needs to be available

#rubygems is not technically required, but habit
require "rubygems"

require "dotenv"

require "google_drive"

Dotenv.load

#defines a task, named default, and tells it what to do. in this case to execute another task
task :default => [:import]


SPREADSHEET_KEY      = ENV.fetch('SPREADSHEET_KEY', '')
USER_EMAIL           = ENV.fetch('USER_EMAIL', '')
USER_PASSWORD        = ENV.fetch('USER_PASSWORD', '')


def make_name (string)
  string.gsub(/ /,"_").downcase
end

#This method writes a markdown file for any row passed to it
def write_markdown (row)
  timestamp                   = @worksheet[row, 1]
  name                        = @worksheet[row, 2]
  email_address               = @worksheet[row, 3]
  name_of_program             = @worksheet[row, 4]
  program_url                 = @worksheet[row, 5]
  name_of_institution         = @worksheet[row, 6]
  address_of_program          = @worksheet[row, 7]
  mission_statement           = @worksheet[row, 8]
  #areas_of_research_support   = @worksheet[row, 9]
   base_name              = make_name name_of_program

  contents               = "---
layout: page
status: publish
#permalink: /institutions/#{base_name}
title: #{name_of_program}
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

  #This writes a file in the subdirectory 'institutions'
  begin
    file = File.open("_institutions/#{base_name}.md", "w")
    puts "Writing file for #{base_name}"
    file.write(contents) 
  rescue IOError => e
    puts "File not writable."
  ensure
    file.close unless file == nil
  end

  #
end
desc "import all the things."
task :import do
  puts "starting import"

  #this logs me in to google drive and gives me access to my documents
  session = GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASSWORD'])

  #this clarifies which file within google drive i want. this grabs the spreadsheet based on the key and returns worksheet 0
  @worksheet = session.spreadsheet_by_key(ENV['INSTITUTIONS_KEY']).worksheets[0]

  #this is telling the script to grab each row and then passes it to the method write_markdown, which
  for row in 2..@worksheet.num_rows
    #2..ws.num_rows.each do |row|
    write_markdown row 

  end
end
