# CrowdPublish.TV

The intention of this repository is to be used as a project for developers of all skill levels to improve their skills by contributing code and by assisting junior developers with their code contributions. The founder, Lisa Schaefer, Ph.D., has taught a beginners Ruby on Rails course at George Mason University and encourages women entrepreneurs to be the primary mentors, mentees, and leaders in this project. Dr. Schaefer also advocates for women's voices to be heard and heeded in the software development community.

RoleModel Enterprises, LLC, owns the copyright to all code, design, and graphics contributed to this repository. Contributors grant copyright of any code, design, and graphics they contribute to this repository to RoleModel Enterprises, LLC. Contributors may reuse their code contributions and the knowledge gained from working on this project, provided it meets the following criteria:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form are not permitted.

3. Redistribution of the entire code repository is not permitted. Use of the entire code repository is encouraged, but only for developers and their mentees who are using it for the specific educational purposes endorsed by RoleModel Enterprises, LLC.

4. Neither the name of CrowdPublish.TV, RoleModel Enterprises, LLC, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

This software is provided by the copyright holders and contributors "as is" and any express or implied warranties, including, but not limited to the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright owner of contributors be liable for any direct, indirect, incidental, special, exemplary or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.
 
This README file may change at any time.



### QUIZ FOR POTENTIAL DEVELOPERS
To determine current skill level -
Send your responses to info@CrowdPublish.TV. 

Refer to http://github.com/crowdpublishtv/crowdpublishtv and use tutorials, Google, etc. to help you figure out the answers. 

1. What is the design of the CrowdPublish.TV database? Submit as a jpg or png (You may draw on paper & submit as a photo).

2. Which file/view is the users' home page? What information do authors get to display on their home page? Where is this information stored in the CrowdPublish.TV database?

3. What pages/views do authors get in their web site when they sign up for CrowdPublish.TV?

4. What are the default views for all Rails apps?

5. What are the routes that were added to the CrowdPublish.TV app so the non-default/extra views for user pages could be displayed?

6. What are the methods that were added to the CrowdPublish.TV app so the non-default/extra user views/pages could be displayed? What file are they in?

7. Where is the method to add_bank_account to users? What gem does it use?

8. Fork a copy of the crowdpublishtv github repo (url above) into your GitHub account. Make a minor change that does not affect functionality (such as add a dummy file to the root directory) and request that the CrowdPublishTV admin pull your changes.

9. Summarize your Ruby & Rails skill level/what you know in your own words.

When you have completed the quiz, download and start working on the tutorial at https://github.com/crowdpublishtv/crowdpublishtv/blob/master/public/LearnRailsIn2Minutes.odt 


### TO USE THE CODE IN YOUR LOCAL TEST ENVIRONMENT

Files To Check/Change/Create: 

* gemfile: 
    Comment out 
```
    #gem 'pg' 
```
and uncomment 
```
gem 'sqlite3'
```

* config/initializers/aakeys.rb: 
    Create this file DO NOT CHANGE THE NAME (note that it is listed in .gitignore) & paste the following into it:

```
DEVISE_SECRET_KEY = 'fake'
AWS_KEY = 'morefake'
AWS_SECRET_KEY = 'pretend' 
STRIPE_SECRET_KEY = "madeup"
STRIPE_PUBLIC_KEY = "allfake"
GMAIL_PWD = "superfake"
Stripe.api_key = STRIPE_SECRET_KEY
```

Of course, with the fake keys, you will not be able to use AWS (upload files to user profiles), Devise (logins), or Stripe (purchase items from authors). If you have your own AWS, Devise, or Stripe accounts, you may replace the keys in config/initializers/aakeys.rb with your accounts' keys. 

*config/database.yml

Create this file DO NOT CHANGE THE NAME (note that it is listed in .gitignore) & paste the following into it:

```
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000
```
```
development:
  <<: *default
  database: db/development.sqlite3
```
```
test:
  <<: *default
  database: db/test.sqlite3
```

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
>bin/rails server
```
at the command line to start the server.

Copyright &copy; 2018, RoleModel Enterprises, LLC. All rights reserved.
