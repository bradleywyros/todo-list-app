# README

## To-Do List Challenge

An API-Only Ruby on Rails app designed to manage a ToDo lists at a personal or admin level. The app is currently in progress and not ready for release.

# Stack 

* **Ruby**: *3.4.2*
* **Rails**: *7.1.5+*
* **Database**: *PostgreSQL*
* **Authentication**: *Devise JWT*
* **Container**: *Docker*
* **Background Jobs**: *Sidekiq with Redis*
* **Suggested Environment**: *Linux Ubuntu 22.04*

# Key Features

* ToDo List creation and management at the personal or admin level
* API Only
* Todo List Items with Title, Description, Status, and Due Date
* Items can be filtered by Status and a date range using Due Date
* Personal Users can view and manage only their list items
* Admin Users can view and manage *all* items

## Getting Started

# Prerequisites

* Docker / Docker Compose
* Git

## Installing the App

1. Clone the repository
```
git clone https://github.com/bradleywyros/todo-list-app.git
```

2. `.env` is provided in the repo, but please adjust as needed. Values include:
```
TODO_LIST_APP_RAILS_DATABASE=todo_list_app_rails_db
TODO_LIST_APP_RAILS_DATABASE_USER=todo_list_app_rails_db_user
TODO_LIST_APP_RAILS_DATABASE_PASSWORD=your_password
DEVISE_JWT_SECRET_KEY=your_devise_secret_key
TODO_LIST_APP_RAILS_DATABASE_HOST=your_host
RAILS_MASTER_KEY=your_rails_master_key
SECRET_KEY_BASE=your_secret_key_base
```

3. Build and start your Docker containers
```
docker-compose build
docker-compose up
```

4. Create, migrate, and seed your database. Note that `seed.rb` provides test users
```
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose run web rake db:seed
```

5. Access application URL. *Note that this is API only*
* http://localhost:3000

## API Endpoints

# User

* `GET /api/my_list` - Gets the list and items of the current user. For filtering, see Filtering section.
* `POST /api/my_item` - Create a new item with parameters title*, description, and duedate* *( * required)*. Default status is `pending`.
* `DELETE /api/my_item/:id` - Delete an item
* `POST /api/my_item/:id/start` - Change item to "in_progress" status
* `POST /api/my_item/:id/complete` - Change item to "completed" status

# Admin Only

* `GET /api/admin/list` - Get all lists. For filtering, see Filtering section
* `GET /api/admin/list/:id` - Show a specific list
* `POST /api/admin/list` - Create a new list
* `DELETE /api/admin/list/:id` - Delete a list
* `GET /api/admin/list/:list_id/items/:id` - Show an item
* `POST /api/admin/list/:list_id/items` - Create a new item in a list with parameters title*, description, and duedate* *( * required)*. Default status is `pending`.
* `DELETE /api/admin/list/:list_id/items/:id` - Delete an item
* `POST /api/admin/list/:list_id/items/:id/start` - Change item to "in_progress" status
* `POST /api/admin/list/:list_id/items/:id/complete` - Change item to "completed" status

# Filtering

* Using the GET list enpoints, you can filter by `status`, `due_date`, `start_date`, and `end_date`
* Acceptable `status` values include `pending`, `in_progress`, and `completed`
* `due_date` returns all items due within the date defined. Note that this cannot be used with `start_date` and/or `end_date`.
* `start_date` returns all items on and after the date defined
* `end_date` returns all items on and before the date defined
* Using both `start_date` and `end_date` will return all items within the defined date range
* Acceptable date format is `YYYY/MM/DD`

## Database Schema

* **User**: Authentication and user management (Personal or admin)
* **List**: ToDo List that belongs to a user
* **Item**: Items that belong to a User List. Attributes include `title`, `description`, `status`, and `duedate`
