require "rubygems"
require "dotenv"
require "google_drive"

Dotenv.load

def make_name (program)
  program.gsub(/ /,"_")
end


task :default => [:import]

desc "import the googles data"
task :import do
  puts "starting import"

  session = GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASSWORD'])
  puts session

  ws = session.spreadsheet_by_key(ENV['INSTITUTIONS_KEY']).worksheets[0]
  puts make_name(ws[2,4])

  for row in 2..ws.num_rows
    for col in 1..ws.num_cols
      #p ws[row, col]
    end
  end
end
