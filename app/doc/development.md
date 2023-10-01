# OnTrack Front End Doc For Developers

The FE of OnTrack has 5 pages.


Table of contents:
- [Landing Page](#landing-page)
- [User Dashboard](#user-dashboard)
- [Tasks Index Page](#tasks-index-page)
- [Task Create Page](#task-create-page)
- [Task Edit Page](#task-edit-page)

## All pages
- (image) Light/Dark mode toggle
- (image) Log Out 
- (image) Button to Task Create page
- (image) Button to Task Index page
- (image) Button to User Dashboard page


## Landing Page (Login)
This page appears for users who are not logged in. Users see a button to log in with google.

All other pages are only accessible to users who are logged in. Attempting to access them manually through the url or through the navigation buttons will redirect user back to the Login Page with the flash message: “Please Log In”

Log in uses Google OAuth (insert more details here)


## User Dashboard
This is the homepage for logged in users. 

(screenshot)
User sees three buttons with facial expressions representing mood. The user’s currently selected mood is whichever button is framed.

(Describe how holidays/birthdays are shown, have screenshots, and code snippets)


Users see a sticky note on their dashboard. On the sticky note is:
- A task’s name, which links to its associated edit page
- The task’s description, if it has one
- A button to “Skip”
- A button to mark the task is “Complete”

The task that appears on the dashboard is chosen by an algorithm in the backend, which is affected by the current mood selected by the user on this page. When the user selects a mood, it saves that mood as a cookie in the front end. This cookie is used as a query param when accessing the backend server for tasks.
```ruby
insert code snippet of the cookie implementation here
```

[See the BE Mood Endpoint Docs for more information.](placeholder.com)

When a user either chooses to mark a task as skipped or completed, this goes through the TasksController update action. If the task frequency is "once" it will be redirected to the destroy action
```ruby
code snippet
```
Tasks that are not destroyed are instead updated on the backend with a timestamp for their completion date. The backend algorithm uses this information when determining how often to prompt daily, weekly, monthly, and annual tasks to the user. [See the BE daily tasks endpoint docs for more information](placeholder.com)

After (time), the dashboard will no longer prompt tasks and instead suggest the user rest for the evening.

## Tasks Index Page
This page contains a list of all the user’s registered tasks. 

There are three dropdown menus allowing the user to filter by frequency (once, daily, monthly, weekly, annual), priority level (mandatory or optional), and by category (rest, hobby, or chore). Selecting any of these options and clicking the “Filter Tasks” button will send a query to the backend index endpoint to return tasks that apply to the given filters. The queries are formatted through the helper methods below.
```ruby
code snippet of the queries being formatted and how they are rendered back on the index page
```

Selecting “Clear Filters” will remove all filters and show all tasks again.

Each task name is a link to its edit page, which contains all other information about that task.


## Task Create Page
This page contains a form for the user to input information to create a new task. Submitting this form will send a post request to the BE.

The mandatory fields on this form are name and category. Optional fields are a checkbox for whether or not it is a mandatory task, an event date field, and a notes field. The frequency field defaults to “once”. 

If any mandatory fields are not filled in and the user attempts to save the task, the page will refresh with an error message noting which fields still need to be filled in. It will keep all the user's current input information when refreshing, by passing it back through the params.
```ruby
code snippet showing the params being preserved and redirected back to new task page
```

The user also sees a button that says it will generated an AI-powered suggested breakdown of the task. If the user clicks this button after inputting a task name, the field will populate with a potential step-by-step way of approaching the task. 
```ruby 
code snippet of the get_ai method and redirection
```
(screenshot of suggested breakdown for a random task)

If the user clicks this button without putting in any task name, they will receive a flash error that they need to at least put in a task name in order to generate a breakdown of the task.

The user has two submit buttons. One saves the task and redirects back to the dashboard, and the other saves the task and refreshes a new blank version of the page to create another task.


## Task Edit Page
This page is a form similar to the Task Create page. Fields are pre-filled with information relevant to the current task that is being edited.

Similar to the task create page, mandatory fields are the task name and category. If the user deletes the pre-filled information in these fields and tries to save changes, they will receive an error that those fields cannot be blank.

Also similar to the Task Create page, the user has a button to generate an AI-Powered breakdown of the task.

Clicking “Save Changes” will send a request to the BE patch endpoint to update the task. Clicking “Delete” will send a request to the BE delete endpoint.
