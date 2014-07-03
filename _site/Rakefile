#! /usr/bin/env ruby

#rubygems is not technically required, but habit
require "rubygems"
require "dotenv"
require "google_drive"
require "date"

Dotenv.load

SPREADSHEET_KEY      = ENV.fetch('SPREADSHEET_KEY', '')
USER_EMAIL           = ENV.fetch('USER_EMAIL', '')
USER_PASSWORD        = ENV.fetch('USER_PASSWORD', '')

def login
  @session ||= GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASSWORD'])
end

def get_worksheet(key)
  login
  @worksheet = @session.spreadsheet_by_key(ENV[key]).worksheets[0]
end

def over_rows(key)
  worksheet = get_worksheet(key)
  for row in 2..worksheet.num_rows
    yield(row)
  end
end

task :default => 'import:all'

namespace :import do

  desc "import all institutions."
  task :institutions do
    puts "starting import"

    over_rows('INSTITUTIONS_KEY') do |row|
      write_institutionsmarkdown row
    end
  end

  desc "import all students."
  task :students do
    puts "starting import"

    over_rows('PEOPLE_FORM_KEY') do |row|
      write_studentmarkdown row
    end
  end

  desc "Generate markup for both institutions and students"
  task :all => ['import:institutions', 'import:students']

end

def parse_date(date)
  parts = date.to_s.split(' ')
  date_components = parts[0].split('/')
  "%04d-%02d-%02d" % [date_components[2], date_components[0], date_components[1]]
end

def make_name (string, date = Date.now)
  d = parse_date(date)
  slug = string.gsub(/ /,"_").downcase
  "#{d}-#{slug}" #look at what wayne did with slugify in the codespeak
end

def write_file(base_name, contents)

  puts "Writing #{base_name}..."
  #This writes a file in the subdirectory 'posts'
  begin
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
  student_name                = @worksheet[row, 2]
  #student_email               = @worksheet[row, 3]
  program_name                = @worksheet[row, 7]
  year_entering_fellowship    = @worksheet[row, 4]
  personal_website            = @worksheet[row, 5]
  twitter_handle              = @worksheet[row, 6]
  research_area               = @worksheet[row, 8]
  other_research_areas        = @worksheet[row, 9]
  base_name                   = make_name(student_name, timestamp)

  contents               = "---
layout: post
status: publish
permalink: posts/students/#{base_name}
title: #{student_name}
categories: [student, #{program_name}, #{research_area}]
other: #{other_research_areas}
website: #{personal_website}
---
# #{student_name}

## Program Name: #{program_name}
### Year Entering Fellowship:  #{year_entering_fellowship}
### Personal Website:  #{personal_website}
### Twitter Handle:  #{twitter_handle}
  "

  write_file(base_name, contents)
end

#This method writes a markdown file (for institutions) for any row passed to it
def write_institutionsmarkdown (row)
  timestamp                   = @worksheet[row, 1]
  #contact_name               = @worksheet[row, 2]
  #email                      = @worksheet[row, 3]
  program_name                = @worksheet[row, 4]
  program_url                 = @worksheet[row, 9]
  institution_name            = @worksheet[row, 5]
  #program_address            = @worksheet[row, 6]
  mission_statement           = @worksheet[row, 7]
  population_supported        = @worksheet[row, 8]
  other_population_supported  = @worksheet[row, 10]
  base_name                   = make_name(program_name, timestamp)

  puts population_supported

  contents               = "---
layout: post
status: publish
#permalink: posts/institutions/#{base_name}
title: #{program_name}
categories: #{population_supported.gsub(/,/, ' ')}
other: #{other_population_supported}
website: #{program_url}
---
# #{program_name}, #{institution_name}

## Mission Statement

#{mission_statement}
  "
  write_file(base_name, contents)
end