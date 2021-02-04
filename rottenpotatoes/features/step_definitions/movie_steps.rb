# Add a declarative step here for populating the DB with movies.
num_rows=0
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
#     Movie.create!(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
    Movie.create!(movie)
    num_rows+=1
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(/[\s\S]*#{e1}[\s\S]*#{e1}/).to match(page.body)
end

# for clicking on submit, refresh etc.
When /^I click '(.*)'/ do |button|
  click_button button
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_array = rating_list.split(', ')
  rating_array.each do |rating|
    if !uncheck.nil?
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
#     if uncheck.nil?
#         step %Q{I check "ratings_#{rating}"}
#     else
#         step %Q{I uncheck "ratings_#{rating}"}
#     end
  end
end

# to examine the list of movies shown
Then /I should (not )?see: (.*)$/ do |should_not, movies_list|
  movies = movies_list.split(", ")
  movies.each do |movie|
    if should_not.nil?
      expect(page).to have_content(movie)
    else
      expect(page).not_to have_content(movie)
    end
  end
  num_rows = 0
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(num_rows).to eq 10
end
