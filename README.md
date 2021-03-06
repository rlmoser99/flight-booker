# Flight Booker

This is a project from the **Advanced Forms and Active Record** section in [The Odin Project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-advanced-forms)'s Ruby on Rails curriculum. 

## Demo
<img src="app/assets/images/flight-booker-demo.gif" alt="web app demo" width=auto height="400px"/><br>

## Live Project
You can view this [web app](https://rlm-flight-booker.herokuapp.com/) on Heroku. The heroku server will need a little bit of time to fire up a dyno, so please be patient with this free service.

## Project Requirements
This project is a fairly simple and straighforward app where a user books a 1-way flight. The focus of this project is getting more comfortable with Active Record and more advanced forms. It does not require any user authentication or authorization. 

**User Searches Flights:**
Users find flights based on the origin airport, destination airport, and the departure date. This feature required associations between the airports and flights, seeding the database, and building a form using pre-populated dropdowns.

**User Pick A Flight:** 
On the same page as the search, users select the flight that they would like to book. This feature required working with parameters and using a hidden field for the number of passengers.

**User Enters Passenger Information:** 
Users enter passenger information to finalize their booking. This feature required `Bookings` to accept nested attributes for `Passengers`. 

**(Additional) RSpec Tests:** 
The current Ruby on Rails curriculum does not cover testing, so I decided to learn testing before tackling this project. After trying several other resources, I read [Rails 5 Test Prescriptions](https://pragprog.com/titles/nrtest3/rails-5-test-prescriptions/). Although the book is slightly outdated, it was very thorough and gave me the foundational knowledge that I was seeking.

**(Additional) 2 Connecting Flights:** 
After finishing the bare bones of this project, I wanted to see if I could implement two connecting flights for long cross-country flights. This was quite a challenge at my skill level, but it was very rewarding to see it all come together. I created a service object, `BookingOptions`, to find the available flights. If a direct flight is less then 4 hours long, it will only return direct flights. However, if a direct flight is over 4 hours long, it will also look for connecting flights in a specific window of time. I used TDD to develop this feature, so it was perfect timing to utilize my new testing knowledge.

**(Additional) Rake Tasks:** 
As I was wrapping up this project, I wanted to figure out a way to continually seed the database with flights in the future. The Odin Project's students look at other student's solutions, so I didn't want to this app to quit working in a month, three months, or even a year. I learned that I could create rake tasks and use [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler). In addition, I created another service object, `FlightGenerator`, that will be used by the seeds file and the rake task to generate flights.

**(Additional) Styling:** 
Although styling this project is not required, I wanted to add styling as a finishing touch. I decided to use vanilla CSS, instead of using a framework like I had in the past. I had the basic idea of using an light-colored inner area, with a darker "sky-like" gradient background. As I created this basic layout, I remembered the logo from [Catch Me If You Can](https://www.imdb.com/title/tt0264464/) and was inspired to create a similar logo using [Affinity Designer](https://affinity.serif.com/en-us/designer/). This web app is responsive, using a combination of media queries and flexbox. 

## Local Installation
- Prerequisites: Rails, Git, and Bundler
- Clone this repo ([instructions](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository))
- Navigate into this project's directory `cd flight_booker`
- Install the required gems, by running `bundle install`
- Migrate the database, by running `rails db:migrate`
- Seed the database, by running `rails db:seed`
- Start the local server, by running `rails server`
- View `localhost:3000` in a web browser

### Running the tests
- To run the entire test suite, run `rspec`
- You can specify one spec folder to run a group tests, such as `rspec spec/features` 
- You can specify one spec file to run a single set of tests, such as `rspec spec/models/flight_spec.rb` 
