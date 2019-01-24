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
Send your responses to rolemodelenterprises@gmail.com 

Refer to http://github.com/ece106/tomatocan and use tutorials, Google, etc. to help you figure out the answers. 

1. Copy schema.rb and save it as schema.txt. Describe each field of the events, merchandises, purchases, rsvpqs, and users tables.
e.g. "created_at" - Time and date at which each record was created
"twitter" - user's twitter handle


2. Which file/view is the users' home page? What information can users display on their home page? Where is this information stored in the Tomatocan database?

3. What pages/views do users get in their web site when they sign up for Tomatocan?

4. What are the default views for all Rails apps? What do they display?

5. What are the routes that were added to the Tomatocan app so the non-default/extra views for user pages could be displayed?

6. What are the methods that were added to the Tomatocan app so the non-default/extra user views/pages could be displayed? What file are they in?

7. Where is the method to calcdashboard for users? 

8. What gem is used for signin/signout? How many times is it mentioned in the Tomatocan repository?

9. Fork a copy of the tomatocan github repo (url above) into your GitHub account. Make a minor change that does not affect functionality (such as add a dummy file to the root directory) and request that the Tomatocan admin pull your changes.

10. Summarize your Ruby & Rails skill level/what you know in your own words.

### TO USE THE TOMATOCAN GITHUB

For a list of helpful git commands use the git cheetsheet: https://services.github.com/on-demand/downloads/github-git-cheat-sheet/

1. Forking from tomatocan and bringing the code to your local machine

Begin by forking the tomatocan code by pressing the fork button located at http://github.com/ece106/tomatocan. Forking will allow you to have a copy of the tomatocan code in your personal github and will give you a way to request tomatocan to pull your changes. 

In order to bring the tomatocan code to your local machine you must make a clone of the fork you have created. 

a. On GitHub, navigate to your fork of the tomatocan repository.

b. Under the repository name, click ``` Clone or download ```. Do NOT download.

c. To CLONE the repository: Open a command line in the directory you would like your code to be saved and use the command:

```
 git clone https://github.com/YOUR-GITHUB_USERNAME/tomatocan
```

2. Saving your changes to your repository

In order to push your code to your repository you will have to stage your files to commit. You can stage your files by using the following commands:

"Adds modified and new files that are not .ignored to the stage"
```
git add * :/
```

To finish your commit (which will save your current files) use the command:
```
git commit -a -m "Useful Comment of Your Changes/Additions"
```

Now you can push your comitted changes to your repository with the following commands:

```
git push origin master
```
or
  
```
git push https://github.com/YOUR-GITHUB_USERNAME/YOUR-TOMATOCAN-REPOSITORY master
```

3. Pulling changes from tomatocan into your local machine

When changes have been made to the code http://github.com/ece106/tomatocan, your github will be behind. So you will have to pull the changes to your local machine and then push them to your repository. To pull changes from tomatocan, be sure to be in the correct directory, and use the command: 

```
git pull https://github.com/ece106/tomatocan.git master
```

4. Getting your code onto tomatocan

Once you have made changes to your personal repository you can request for tomatocan to pull your changes into the original repository. To do this you have to create a pull request. One way of creating a pull request is to go to http:/github.com/YOUR-GITHUB-USERNAME/YOUR-TOMATOCAN-REPOSITORY and there is a button labeled "New Pull Request". After creating a pull request your changes have to be reviewed and then either accepted or denied.

### TO USE THE CODE IN YOUR LOCAL TEST ENVIRONMENT

Files To Check/Change/Create: 

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

Of course, with the fake keys, you will not be able to use AWS (upload files to user profiles), Devise (logins), or Stripe (purchase items from authors). If you have your own AWS, Devise, or Stripe accounts, you may replace the keys in config/initializers/aakeys.rb with your accounts' keys. 

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

Then type
```
>gem install bundler
```
at the command line so you can install all the gems.

Then type
```
>bundle install
```
at the command line to install all the necessary gems.

Then type
```
>rake db:migrate
```
at the command line to build the database with the correct schema.

Then type
```
>rails s
```
at the command line from the tomatocan directory to start the server.


And it's good to refer to Michael Hartl's tutorial for a lot of Rails help http://railstutorial.org/book

Copyright &copy; 2019, RoleModel Enterprises, LLC. All rights reserved.
