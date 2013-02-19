class Search
  attr_accessor :term

  def initialize(term)
    @term = term
  end

  def execute
    members = search_members term
    SearchResult.new members
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
    lower(email) LIKE ?
    EOF
    
    args = []
    3.times { args << "%#{name.downcase}%"}

    # check for the name every time
    Member.where query, *args
    
  end

end

SearchResult = Struct.new :members, :jobs, :groups