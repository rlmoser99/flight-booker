# Flight Booker

This is a project from the **Advanced Forms and Active Record** section in [The Odin Project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-advanced-forms)'s Ruby on Rails curriculum. 

## Demo
Add gif

## Live Project
Add link to heroku

## Project Requirements
This project is a fairly simple and straighforward app where a user books a 1-way flight. The focus of this project is getting more comfortable with Active Record and more advanced forms. It does not require any user authentication or authorization. 

**User Searches Flights:**
Users find flights based on the origin airport, destination airport, and the departure date. This feature required associations between the airports and flights, seeding the database, and building a form using pre-populated dropdowns.

**User Pick A Flight:** 
On the same page as the search, users select the flight that they would like to book. This feature required working with parameters and using a hidden field for the number of passengers.

**User Enters Passenger Information:** 
User enter the passenger information to finalize their booking. This feature required `Bookings` to accept nested attributes for `Passengers`. 

**RSpec Tests (EXTRA):** 
The current Ruby on Rails curriculum does not cover testing, so I decided there was no better time to learn testing on my own. After trying several other resources, I read [Rails 5 Test Prescriptions](https://pragprog.com/titles/nrtest3/rails-5-test-prescriptions/). Although the book is slightly outdated, it was very thorough and gave me the foundational knowledge that I was seeking.

**Layover Flights (EXTRA):** 
After finishing the bare bones of this project, I wanted to see if I could use two connecting flights between the locations. This was quite a challenge at my skill level, but it was very rewarding to see it all come together. I created a service object, `booking_options`, to find the available flights. If a direct flight was less then 4 hours long, it would only return direct flights. However, if a direct flight was over 4 hours long, it would look for connecting flights. I developed this service object using TDD, so it was a great way to utilize my new testing knowledge.

**Styles (EXTRA):** 
Styling this project was not required. I decided to use vanilla CSS, instead of using a framework like I had in the past. It is responsive, using a combination of media queries, flexbox, and grid. 

## How to Play
This chess game will look slightly different on other command line interfaces (CLI), such as repl.it or your computer. Not only will the colors vary, but the font size of my CLI is 24 points to increase the size of the unicode chess pieces.

### Play Online
If you want to play this chess game without installing it on your computer, you can play it [online](https://repl.it/@rlmoser/rubychess#README.md). Just click the `run` button at the top of the page. It will take a few seconds to load the dependencies and then the game menu will appear.

### Installation
- Clone this repo ([instructions](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository))
- Navigate into this project's directory `cd flight_booker`
- Install the required gems, by running `bundle install`
- Migrate the database, by running `rails db:migrate`
- Seed the database, by running `rails db:seed`
- Start the local server, by running `rails server`
- Open a web browser and enter `localhost:3000` as the address

## Running the tests
- To run the entire test suite, run `rspec`
- You can specify one spec folder to run a group tests, such as `rspec spec/features` 
- You can specify one spec file to run the a single set of tests, such as `rspec spec/models/flight_spec.rb` 
