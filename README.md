[![GitHub contributors](https://img.shields.io/github/contributors/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/forks)
[![GitHub Repo stars](https://img.shields.io/github/stars/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/ontrack-2305/ontrack_fe)](https://github.com/ontrack-2305/ontrack_fe/issues)

# OnTrack (Front End Repo)


## About This Project
### Important to Note
This is an SOA app and needs both this repo (front end) AND [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white) ](https://github.com/ontrack-2305/ontrack_be) (back end) in order to be fully functioning.


### Overview
This project is built to satisfy the requirements of the Turing School of Software and Design's [Consultancy Project](https://backend.turing.edu/module3/projects/consultancy/). Students come up with their own idea for an application and build it as a group project.

OnTrack is a web application to help users improve productivity as well as mental health.

The application is designed for users who have executive dysfunction or related disorders which often have symptoms such as:
- Easily overwhelmed
- Forgetfulness 
- Difficulty making decisions

Such symptoms also often lead to low self esteem and depression, due to difficulty maintaining relationships and a healthy lifestyle.

Registered users have the ability to input items on their to-do list. In addition to standard chores, users can put in restful "tasks" and tasks related to personal hobbies.

Users are prompted to complete one task at a time. This helps avoid decision paralysis by letting the app tell the user what to do next, and reduces overwhelming feelings caused by seeing a long list.

Possible edge case users: 
 - People applying to jobs who want a streamlined way to keep track
 - Used as a project planner for work / way for people to timeblock their workday

[See feature documentation for more info](./app/doc/development.md) 
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
 Login with the Login Button and Sign in with Google. Authorize the app for whatever permissions you deem appropriate. At any point light and dark mode can be toggled by clicking on the moon icon in the top left corner.

Upon logging in, users will be redirected to their dashboard page. The dashboard page has four additional buttons in the top left corner, each with alt tags displaying functionality if the user hovers over them. The house brings user back to dashboard, the + allows a user to add a task, the notepad allows users to view their task index (where they can also edit their tasks), and the door allows users to logout.

Users are then prompted to select a mood icon that represents their current mood, and the dashboard will populate with a task list tailored to that specific mood. If the user is happy, they will get more chores added to their list on top of their mandatory daily tasks. If a user is sad, they will only have to complete their mandatory tasks, then they will be prompted to do only restful tasks if they so choose. If they are in a mediocre mood, there will be a divvying of hobby and rest tasks after mandatory tasks are completed. At any point the user can change their mood and the task list will regenerate accordingly.
 
Located on the dashboard as well are the next three national holidays coming up as well as an option for users to integrate their google calendar. If they choose to integrate their google calendar, upcoming calendar events for the next two weeks will be displayed on their dashboard.

When the user navigates to the tasks/new page, there is a form to add a new task. The user has three options after they fill out a task. As a preliminary step, they can generate a suggested breakdown of the task (powered by AI) that will autopopulate the notes section. Otherwise, they can save the task and navigate back to the dashboard or they can save the task and continue to add more tasks.

When the user navigates to the /tasks page, they see all their tasks listed as well as the ability to select from any combination of three filters, one each for frequency, priority, and category. Users can clear and reset those filters at any point. Also, each task is shown as a link to its show page. If the user clicks on a task, they have the option to edit, generate an AI breakdown of the task, or delete the task.
 
 


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
- Users can register/log in without using a google account
- Upcoming birthday notifications
- Screen reader friendly
- Refactor to have all tables on the back end
- Choose which holidays a user can be reminded about
- Choose different country holidays
- Link holidays and events to people: "Mother's Day, send Mom something"
- Language translation
- Standalone app
- Task templates
- Allow users to customize text colors and backgrounds - Promotes inclusivity for color blindness
- "I'm bored" feature that can suggest new hobbies or activities based on previous user input

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!


## EQUITY ANALYSIS
- The intended users of OnTrack are individuals with executive dysfunction or related disorders. Our design choices prioritize their unique needs and challenges.
- While our primary user base includes individuals with executive dysfunction or related disorders, we recognize that these users may belong to diverse identity groups. We are dedicated to ensuring inclusivity for all.
- We understand that factors such as internet connectivity and device compatibility can impact access. We are actively working to minimize these barriers to ensure a wider reach. By maintaining a web application users can use public access such as libraries to use our product.
- Given more time, we plan to collaborate closely with our intended users through interviews, surveys, and usability testing to continually improve and tailor the application to their evolving requirements.
- To prevent misuse of our product, we would like to implement reporting mechanisms and community guidelines. We are committed to maintaining a safe and welcoming environment for all users.
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
