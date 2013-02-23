class Search
  attr_accessor :term

  def initialize(term)
    @term = term
  end

  def execute
    members = search_members term
    jobs = search_jobs term
    groups = search_groups term

    SearchResult.new members, jobs, groups
  end

  def self.do(term)
    instance = new(term)
    instance.execute
  end

private

  # searching in full_name, nick, email
  # serching is case insensitive
  def search_members(name)
    query = <<-EOF
    lower(full_name) LIKE ? OR
    lower(nick) LIKE ? OR
    lower(email) LIKE ? OR
    lower(login) LIKE ?
    EOF
    
    args = []
    4.times { args << "%#{name.downcase}%"}

    # check for the name every time
    Member.where query, *args
  end

  def search_jobs(company)
    JobPosition.where "lower(company) LIKE ?", "%#{company.downcase}%"
  end

  def search_groups(group)
    args = []
    2.times { args << "%#{group.downcase}%" }
    Group.where "lower(name) LIKE ? OR lower(shortname) LIKE ?", *args
  end
end

SearchResult = Struct.new :members, :jobs, :groups