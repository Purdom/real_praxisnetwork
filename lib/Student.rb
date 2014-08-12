def fake_over_rows(worksheet)
  for row in 2..worksheet.count
    yield(row)
  end
end

def fake_student
  [
    fake_date,
    Faker::Name.name,
    fake_institution,
    fake_date,
    "http://#{Faker::Internet.domain_name}",
    "@#{Faker::Internet.user_name}",
    fake_research_area,
    Faker::Lorem.words(rand(1..3)).join(',').gsub(/,/, ' '),
  ]
end

def fake_research_area
  [
    "Textual Analysis",
    "Software Development",
    "Visualizations",
    "Spatial Humanities",
    "Other"
  ].sample.to_s
end

def fake_institution
  [
    "Praxis Program (UVA)",
    "Cultural Heritage Informatics (CHI) Initiative (MSU)",
    "Mellon Scholars program (Hope College)",
    "Digital Fellows Program (CUNY)",
    "MA-MSc program (UCL)",
    "PhD Lab in Digital Knowledge (Duke)",
    "Interactive Arts and Science Program (Brock University)",
    "Honors-level digital humanities program (University of Canterbury)"
  ].sample.to_s
end

def fake_date(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f)).strftime("%-m/%-d/%Y %H:%M:%S")
end

def fake_student_worksheet(count)

  worksheet = Array.new

  count.to_i.times do
    worksheet << fake_student
  end

  worksheet
end

