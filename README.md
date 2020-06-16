The intention of this repository is to be used as a project for developers of all skill levels to improve their skills by contributing code and by assisting junior developers with their code contributions. The founder encourages women entrepreneurs to be the primary mentors, mentees, and leaders in this project and advocates for women's voices to be heard and heeded in the software development community.

RoleModel Enterprises, LLC, owns the copyright to all code, design, and graphics contributed to this repository. Contributors grant copyright of any code, design, and graphics they contribute to this repository to RoleModel Enterprises, LLC. Contributors may reuse their code contributions and the knowledge gained from working on this project, provided it meets the following criteria:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form are not permitted.

3. Redistribution of the entire code repository is not permitted. Use of the entire code repository is encouraged, but only for developers and their mentees who are using it for the specific educational purposes endorsed by RoleModel Enterprises, LLC.

4. Neither the name of ThinQ.tv, RoleModel Enterprises, LLC, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

This software is provided by the copyright holders and contributors "as is" and any express or implied warranties, including, but not limited to the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright owner of contributors be liable for any direct, indirect, incidental, special, exemplary or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.

This README file may change at any time.



### TO USE THE CODE IN YOUR LOCAL DEVELOPMENT AND TEST ENVIRONMENT

0. To set up Ruby on Rails on Mac or Linux, go to
https://gorails.com/setup/osx/10.13-high-sierra
Make sure you install the Postresql database, not sqlite. No need to create the myapp example since you'll be using the ThinQ.tv code.

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
FACEBOOK_APP_ID = "numbers"
FACEBOOK_APP_SECRET = "secret"
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

You must create the databases on your machine. They must be named the same as in your database.yml file.
https://www.guru99.com/postgresql-create-database.html

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


### REQUIREMENTS TO REMAIN IN THE THINQ.TV INTERNSHIP PROGRAM

We'll allow most appropriately-skilled college students the opportunity to earn great knowledge in the Thinq.tv internship program. Some of our interns have been fantastic teammates and have been hired for great careers after completing 160 hours of our program. However since many interns have proved to be unready for adulthood, after the first three weeks, we have minimum requirements to continued access to our time and resources:

- You must spend at least 10 hours per week on helping Thinq.tv grow. This is an internship at a business. It is not your toy app homework assignment.
- Push to github 5 times per week.
- Attend at least one of the Conversations posted on the home page per week. If you are not willing to be a part of our mission, you should not be taking up our time nor mental space.
- Contribute enough to justify a pull request every 3 weeks.
- Share conversations on your social media accounts every week: LinkedIn, Twitter, Facebook, Instagram. Tag Thinq.TV's account on the post to prove that the Conversation was shared.
- Invite parents and friends to participate on live conversations - and prove it by their appearance.
- Keep your hours updated on the Study Hall Schedule. Otherwise we'll assume you will not be fulfilling your 10 hours/week.

Add the following columns to your Goals & Accomplishments sheet:
- Conversations attended
- Person you brought into the conversation with you
- Dates & social media accounts where you Shared conversations
- The days you pushed to github
- Summary of your pull request


### RESOURCES

Refer to Michael Hartl's tutorial for great Rails knowledge http://railstutorial.org/book
You only need to go through chapters 2-6. And maybe 10 & 13. Do NOT build the toy app. Only use Hartl's tutorial as a reference for understanding ThinQ.tv rails code.

For a list of helpful git commands use the git cheatsheet: https://services.github.com/on-demand/downloads/github-git-cheat-sheet/

For minitest methods https://guides.rubyonrails.org/testing.html

For Capybara integration tests https://devhints.io/capybara


### PROFESSIONAL WORKPLACE RULES 

- ThinQ.tv is not your toy app for your professor to give you a smiley face. ThinQ.tv is a business. No employer wants you to build a toy app homework assignment. 
- If you do not believe in your employer's mission, you won't do well. Therefore everything you do must be toward getting more actively involved users/paying customers. 
- Exercise good judgement. Changing colors does not bring in users. Adding pictures does not bring in users. Clarifying information does. Do not add confusing distractions to the site.
- If you do not make a pull request every 2 or 3 weeks, you are using your time extremely poorly in your own corner with your own toy app.
- NEVER delete your .gitignore
- NEVER push secret keys to the internet. People get fired for this! 
- ALWAYS ALWAYS ALWAYS ALWAYS ALWAYS look over your github pushes to make sure you didn't break everything with typos or merge errors.
- NEVER make a pull request that has broken stuff you're leaving for everyone else to clean up. This is not a homework assignement. There is no partial credit for software that does not work. I am not going to pass you to get you out of my hair.
- NEVER leave technical debt messy confusing code for everyone else to clean up. 
- NEVER use the same database for test and development. You will lose ALL your data in your development database. This was mentioned already, but people still keep doing it.
- Never put spaces in filenames. Do you ever put spaces in your variable names? No. 
 



Copyright &copy; 2020, RoleModel Enterprises, LLC. All rights reserved.
