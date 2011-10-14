require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    Person.create(:name => 'Jane Doe')
    Person.create(:name => 'Jane X. Doe')
    Person.create(:name => 'Jane XX. Doe')
  end

  test "finding people with no period in the query" do
    query = "Jane Doe"
    refute_empty find_people(query)
  end

  test "finding people with no period in the query, including associations" do
    query = "Jane Doe"
    refute_empty find_people(query, true)
  end

  test "finding people with a period after a single character word" do
    query = "Jane X. Doe"
    refute_empty find_people(query)
  end

  test "finding people with a period after a single character word, including associations" do
    query = "Jane X. Doe"
    refute_empty find_people(query, true)
  end

  test "finding people with a period after a two character word" do
    query = "Jane XX. Doe"
    refute_empty find_people(query)
  end

  test "finding people with a period after a two character word, including associations" do
    begin
      query = "Jane XX. Doe"
      refute_empty find_people(query, true)
    rescue => ex
      flunk "Mysql error occurred"
    end
  end

  def find_people(query, include_items=false)
    people = Person.where(:name => query).select('people.id AS the_id').order('the_id ASC')
    people = people.includes(:items) if include_items
    people.to_a # call to_a so the query is executed immediately
  end
end
