[![GitHub contributors](https://img.shields.io/github/contributors/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/forks)
[![GitHub Repo stars](https://img.shields.io/github/stars/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/issues)

# OnTrack (Front end Repo)



## About This Project
### Important to Note
This is an SOA app and needs both this repo (front end) AND [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/ontrack-2305/ontrack_be) (back end) in order to be fully functioning.

### Mod 3 Group Consultancy Project
OnTrack is an innovative web app designed for those that need assistance with managing daily tasks without becoming overwhelmed. OnTrack has the ability for registered users to schedule their day based on their mood: 'good', 'meh', and 'bad' moods are taken into account to populate their dashboard with tasks that they've assigned for themselves. Each task falls into a category: 'chore', 'rest', and 'hobby', which are chosen one by one, using an algorithm based on current mood setting and mandatory status.
                                                  <br><br>
                    <img src="app/assets/images/logo_rounded.png" width="300" height="300">
                    

## Built With
* ![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
* ![Postgresql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
* ![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
* ![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
* ![Heroku](https://img.shields.io/badge/heroku-%23430098.svg?style=for-the-badge&logo=heroku&logoColor=white)
* ![Postman Badge](https://img.shields.io/badge/Postman-FF6C37?logo=postman&logoColor=fff&style=for-the-badge)



## Running On
  - Rails 7.0.6
  - Ruby 3.2.2

## <b>Getting Started</b>

To get a local copy, follow these simple instructions

### <b>Installation</b>

1. Fork the Project
2. Clone the repo 
``` 
git clone git@github.com:ontrack-2305/ontrack_fe.git
```
3. Install the gems
```
bundle install
```
4. Create the database
```
rails db:{create,migrate}
```
5. RAILS CREDENTIALS STEPS
```
Run this command to open your credentials file:
  EDITOR="code --wait" bin/rails credentials:edit
Add your API key to the credentials file, formatted something like this:
    GOOGLE_CLIENT_ID: hg39874yt1vfh394uhi
    GOOGLE_CLIENT_SECRET: 934786012394687

You can then call on this API key anytime like this!:
Rails.application.credentials[:GOOGLE_CLIENT_ID]
Rails.application.credentials[:GOOGLE_CLIENT_SECRET]
```
6. Get your API key at: [![Google](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://code.google.com/apis/console/)

    Note the Client ID and the Client Secret.
```
- For more details, read the Google docs: https://developers.google.com/accounts/docs/OAuth2
    - Put your Client ID after `GOOGLE_CLIENT_ID:`
    - PUT you CLIENT SECRET after `GOOGLE_CLIENT_SECRET:` 
```
7. Run Tests in the terminal to verify everything was set up correctly
```
$ bundle exec rspec
```
- All tests should be passing
8. Run Rails Server from the terminal to verify page is loading
```
$ rails s
```
- Open a web browser and navigate to `http://localhost:5000`
- The welcome page should display
- Note: To be able to have full functionality of the site you will also need to setup the backend repo, setup instructions can be found here: [OnTrack Back end repo](https://github.com/ontrack-2305/ontrack_be)

### <b>Contribute your own code</b>
1. Create your Feature Branch
```
$ git checkout -b feature/AmazingFeature
```
2. Commit your Changes
```
$ git commit -m 'Add some AmazingFeature'
```
3. Push to the Branch
```
$ git push origin feature/AmazingFeature
```

4. Open a Pull Request

## How To Use OnTrack
 Login with the Login Button and Sign in with Google
 ![welcome screen](screenshot)
  Description of what to do....
 ![welcome logged in](screenshot)
  Description of what to do . . .
 OTHER SCREENSHOTS
  Other descriptions of what to do . . . 
 


## Schema
    t.string "email"
    t.string "token"
    t.string "google_id"
    t.string "first_name"
    t.string "last_name"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

## Contributing [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/ontrack-2305/ontrack_fe/issues)
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

## Thoughts for future contributions:
- Upcoming birthday notifications
- Screen reader friendly
- Choose which holidays a user can be reminded about
- Choose different country holidays
- Link holidays and events to people: "Mother's Day, send Mom something"
- Language translation
- Attach photos such as grocery lists
- Standalone app
- Task templates
- "I'm bored" feature that can suggest new hobbies or activities based on previous user input

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!


EQUITY ANALYSIS 
## Authors
- Artemy Gibson [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/algibson1) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white) ](https://www.linkedin.com/in/artemy-gibson/)
- Anna Wiley [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/awiley33) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white) ](https://www.linkedin.com/in/annawiley/)
- Dani Rae Wilson [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/dani-wilson) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white) ](https://www.linkedin.com/in/daniraewilson/)
- Parker Boeing [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/ParkerBoeing) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white) ](https://www.linkedin.com/in/parker-boeing/)
- Nick Sacco [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/sicknacco) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white) ](https://www.linkedin.com/in/nick-sacco/)

## Planning Tools
- [![Miro Board](https://img.shields.io/badge/Miro-050038?style=for-the-badge&logo=Miro&logoColor=white)](https://miro.com/app/board/uXjVMmKnWLE=/?share_link_id=729961862050)
- [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/orgs/ontrack-2305/projects/2)
- ![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)
