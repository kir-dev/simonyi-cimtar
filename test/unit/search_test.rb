require "test_helper"

class SearchTest < ActiveSupport::TestCase
 
  test "#execute returns a SearchResult object" do
    assert Search.new("example term").execute.is_a?(SearchResult)
  end 

  test "Search has a #do method for shortcuting initialiazion" do
    assert Search.respond_to?(:do)
  end

  test "#do return the same result as #execute" do
    term = "term"
    s = Search.new term
    
    assert_equal s.execute, Search.do(term)
  end

  test "searching for member name is case insensitive" do
    user = FactoryGirl.create :user, full_name: "Egyedi A. Nevem"

    sr = Search.do "egyedi"
    assert_not_nil sr
    assert_not_nil sr.members
    assert_equal 1, sr.members.count
    assert_equal user, sr.members.first
  end

  test "searching for members looks into full_name, nick, login and email" do
    FactoryGirl.create :user, full_name: "Joe Black"
    FactoryGirl.create :user, nick: "joel"
    FactoryGirl.create :user, email: "my_man_joetro@example.com"
    FactoryGirl.create :user, login: "joe_the_mighty"

    sr = Search.do "joe"

    assert_not_nil sr.members
    assert_equal 4, sr.members.count
  end

  test "searching in company names" do
    FactoryGirl.create :ms

    sr = Search.do "soft"

    assert_not_nil sr.jobs
    assert_equal 1, sr.jobs.count
  end

  test "searching in companies are case insensitive" do
    company_name = "ALL CAPS COMPANY"
    FactoryGirl.create :ms, company: company_name
    
    res = Search.do "company"

    assert_equal 1, res.jobs.count
    assert_equal company_name, res.jobs.first.company
  end

end