#! /usr/bin/env ruby

#This is what the script requires to run, what needs to be available

#rubygems is not technically required, but habit
require "rubygems"

#within the context of this execution make the variables listed in the dotenv file available, keeps the variables hidden
require "dotenv"

#this is the access to google drive documents
require "google_drive"

#tells it to load the .env; classes and modules are uppercase; methods are lowercase; everything is a method in Ruby
Dotenv.load

#defines a task, named default, and tells it what to do. in this case to execute another task
task :default => [:import]

#anything in all caps is a global variable, meaning i can use it anywhere in the execution of the script (I am defining something here that I can use elsewhere) "Now, what I am doing here is being cute" said Wayne Graham. This protects it from failing to execute properly. If there is not a spreadsheet key, this tells Ruby to set it as an empty string, so .env loads the environmental variables, and this tells Ruby to use the environmental variable if available or set an empty string. Ultimately, this protects sensitive info.
SPREADSHEET_KEY      = ENV.fetch('SPREADSHEET_KEY', '')
USER_EMAIL           = ENV.fetch('USER_EMAIL', '')
USER_PASSWORD        = ENV.fetch('USER_PASSWORD', '')

#def defines a method; this uses a regular expression to find spaces and replace with an underscore. Anytime this method is called, take the string i give it and returns back to me the underscore version. The .downcase tacks on a method to make the string lowcase
def make_name (string)
  string.gsub(/ /,"_").downcase
end



#This method writes a markdown file for any row passed to it
#these variables are local to this specific method.

def write_markdown (row)
  timestamp                   = @worksheet[row, 1]
  name                        = @worksheet[row, 2]
  email_address               = @worksheet[row, 3]
  name_of_program             = @worksheet[row, 4]
  program_url                 = @worksheet[row, 5]
  name_of_institution         = @worksheet[row, 6]
  address_of_program          = @worksheet[row, 7]
  mission_statement           = @worksheet[row, 8]
  areas_of_research_support   = @worksheet[row, 9]
  #square brackets indicate an array location, while () indicate a method call. a space does indicate a method call, so for one thing use a space, for more than one use ()
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

  #{additional_information}
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
