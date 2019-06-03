The intention of this repository is to be used as a project for developers of all skill levels to improve their skills by contributing code and by assisting junior developers with their code contributions. The founder encourages women entrepreneurs to be the primary mentors, mentees, and leaders in this project and advocates for women's voices to be heard and heeded in the software development community.

RoleModel Enterprises, LLC, owns the copyright to all code, design, and graphics contributed to this repository. Contributors grant copyright of any code, design, and graphics they contribute to this repository to RoleModel Enterprises, LLC. Contributors may reuse their code contributions and the knowledge gained from working on this project, provided it meets the following criteria:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form are not permitted.

3. Redistribution of the entire code repository is not permitted. Use of the entire code repository is encouraged, but only for developers and their mentees who are using it for the specific educational purposes endorsed by RoleModel Enterprises, LLC.

4. Neither the name of CrowdPublish.TV, RoleModel Enterprises, LLC, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

This software is provided by the copyright holders and contributors "as is" and any express or implied warranties, including, but not limited to the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright owner of contributors be liable for any direct, indirect, incidental, special, exemplary or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.
 
This README file may change at any time.



### QUIZ FOR POTENTIAL DEVELOPERS
To determine current skill level -

Refer to http://github.com/ece106/tomatocan and use tutorials, Google, etc. to help you figure out the answers. 

1. Copy schema.rb and save it as schema.txt. Describe each field of the events, merchandises, purchases, rsvpqs, and users tables.
e.g. "created_at" - Time and date at which each record was created
"twitter" - user's twitter handle

2. Which file/view is the users' profile page? What information can users display on their page? 

3. Where is the users' profile page information stored in the Tomatocan database?

4. What files does Rails autogenerate when you generate scaffolding for a table? 

5. User pages are found by their permalink rather than record id number. What are the routes that were added to the Tomatocan app so the views for user pages could be displayed?

6. What are the methods that were added to the Tomatocan app so the user views could be displayed? 

7. What gem is used for signin/signout? How many times is it mentioned in the Tomatocan repository?

### TO USE THE CODE IN YOUR LOCAL DEVELOPMENT AND TEST ENVIRONMENT

0. To set up Ruby on Rails on Mac or Linux, go to
https://gorails.com/setup/osx/10.13-high-sierra
Make sure you install the Postresql database, not sqlite. No need to create the myapp example since you'll be using the CrowdPublish.TV code.

1. Fork tomatocan to your local machine

Fork the tomatocan code by clicking the fork button at http://github.com/ece106/tomatocan. Forking will allow you to have a copy of the tomatocan code in your personal github. 

Clone the fork you have created. 

a. On GitHub, navigate to your fork of the tomatocan repository.

b. Under the repository name, click ``` Clone or download ```. Do NOT download.

c. To CLONE the repository: In a terminal, in the directory you would like to store your code:

```
 git clone https://github.com/YOUR-GITHUB_USERNAME/tomatocan
```

2. Files To Check/Change/Create: 

* gemfile: 

If you're using sqlite3:
    Comment out 
```
    #gem 'pg' 
```
and uncomment 
```
gem 'sqlite3'

```
If you're using postgresql, leave the gemfile as is.

* config/initializers/aakeys.rb: 
    Create this file DO NOT CHANGE THE NAME (note that it is listed in .gitignore) & paste the following into it:

```
DEVISE_SECRET_KEY = 'fake'
AWS_KEY = 'morefake'
AWS_SECRET_KEY = 'pretend' 
AWS_BUCKET = 'yourawsbucketname'
STRIPE_SECRET_KEY = "madeup"
STRIPE_PUBLIC_KEY = "allfake"
GMAIL_PWD = "superfake"
Stripe.api_key = STRIPE_SECRET_KEY
STRIPE_CONNECT_CLIENT_ID = "superfake"
```

Of course, with the fake keys, you will not be able to use AWS (upload files to user profiles), Devise (logins), or Stripe (purchase items from users). If you have your own AWS, Devise, or Stripe accounts, you may replace the keys in config/initializers/aakeys.rb with your accounts' keys. 

*config/database.yml

Create this file DO NOT CHANGE THE NAME (note that it is listed in .gitignore) & paste the following into it:

For postgresql:

```
default: &default
  adapter: postgresql
  pool: 5
  timeout: 5000

development:
  <<: *default
  encoding: unicode
  database: YOUR_DEVELOPMENT_DATABASE_NAME
  username: YOUR_USERNAME

test:
  <<: *default
  encoding: unicode
  database: YOUR_TEST_DATABASE_NAME
  username: YOUR_USERNAME

production:
  <<: *default
```

For sqlite3:

```
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3

test:
  <<: *default
  database: db/test.sqlite3
```

DO NOT NAME YOUR DEVELOPMENT DATABASE THE SAME AS YOUR TEST DATABASE!!!

* config/environments/development.rb: 

Create this file DO NOT CHANGE THE NAME (note that it is listed in .gitignore) & paste the following into it:

```
Rails.application.configure do

config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true
config.action_mailer.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :user_name => "randomemail@gmail.com",
  :password => 'fake',
  :authentication => 'plain',
  :enable_starttls_auto => true
}
config.action_mailer.default_url_options = {
  host: "localhost:3000", protocol: "http" 
}
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
```

3. Then type
```
>gem install bundler
```
at the command line so you can install all the gems.

Then type
```
>bundle install
```
at the command line to install all the necessary gems.

4. Then type
```
>rake db:migrate
```
at the command line to build the database with the correct schema.

Then type
```
>rails s
```
at the command line from the tomatocan directory to start the server.


### TO USE THE TOMATOCAN GITHUB REPO

*. Saving your changes to your repository

To add modified and new files that are not in .gitignore:
```
git add * :/
```

To commit your current files:
```
git commit -a -m "Useful Comment of Your Changes/Additions"
```

Push comitted changes to your repository:

```
git push origin master
```
or
  
```
git push https://github.com/YOUR-GITHUB_USERNAME/YOUR-TOMATOCAN-REPOSITORY master
```

*. Pulling changes from tomatocan master into your local machine

When changes have been made to the http://github.com/ece106/tomatocan master repo, your own github repo will be behind. Pull the changes to your local machine, then push them to your repository. To pull changes from tomatocan master: 

```
git pull https://github.com/ece106/tomatocan.git master
```

*. Getting your code into tomatocan test branch

Once you have made changes to your personal repository you can request to pull your changes into the a test branch. Go to http:/github.com/YOUR-GITHUB-USERNAME/YOUR-TOMATOCAN-REPOSITORY. Click the "New Pull Request" button. After creating a pull request your changes have to be reviewed and then either accepted or denied.


Refer to Michael Hartl's tutorial for great Rails knowledge http://railstutorial.org/book

For a list of helpful git commands use the git cheatsheet: https://services.github.com/on-demand/downloads/github-git-cheat-sheet/

For minitest methods https://guides.rubyonrails.org/testing.html

Copyright &copy; 2019, RoleModel Enterprises, LLC. All rights reserved.