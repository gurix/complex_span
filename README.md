# Online-Experiment „Complex Span“

## Installation
Requirements
* Mongodb 2.4 or higher
* Ruby on Rails 4 or higher
* Ruby 2.1 or higher
* chromedriver only for E2E-Tests  (https://sites.google.com/a/chromium.org/chromedriver/)

1. Clone the repository: `git clone https://github.com/gurix/complex_span.git`
2. Ensure your mongodb is running
3. Start your application locally `cd complex_span && rails server`

The application is now running on http://localhost:3000/

### Runnning tests
We are using Rspec as test environment. All tests are located under `spec`. One complete cycle of the experiment is available under `spec/features/complete_spec.rb`.

At the moment we are using Google Chrome for End-to-End tests in the browser. Ensure **chormedriver** is installed on your local machine.

## Development

There are two git branches in this project:

**development:** Everything that is in development and not ready to be deployed  
**master:** Code that is in production, merging into master will be automatically deployd on heroku!

New features should be placed in a seperate branch labeled with **feature/XYZ**
### Cycle to develop a new feature
1. Create a new branch under **feature/XYZ** `git checkout -b feature/XYZ`
2. Write your tests describing the feature
3. Implement your feature
4. Ensure no tests are failing `bundle exec rspec`
5. Merge your feature into development branch `git checkout develop && git merge feature/XYZ`

## Deployment

1. Checkout your master branch `git checkout master`
2. Merge your development branch `git merge develop`
3. Ensure no tests are failing `bundle exec rspec`
4. Push your master branch `git push`

After pushing your master branch, heroku picks up the changes and deploys the new master branch automatically.

## Languages
At the moment, English and German is supported. One can choose the language over a) the button on the first  page, or b) over the a direct url:

* On production:
http://complexspan.herokuapp.com/#/de or http://complexspan.herokuapp.com/#/en
* On your local development environment: http://localhost:3000/#/de or http://localhost:3000/#/en

## Links and Tools

* Mongodb Administration interface http://genghisapp.com/
