json.groups do |json|
  json.array!(@result.groups) do |group|
    json.id "group##{group.id}"
    json.text group.name
  end
end
json.members do |json|
  json.array!(@result.members) do |member|
    json.id "member##{member.id}"
    json.text member.name
  end
end
json.jobs do |json|
  json.array!(@result.jobs) do |job|
    json.id "job##{job.company}"
    json.text job.company
  end
end