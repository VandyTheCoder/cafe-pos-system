![Cafe POS System Logo](app/assets/images/logo.png)
# Cafe POS System

Cafe POS System is an open-source Point of Sale (POS) system for cafes, built with Ruby on Rails. This system allows cafe owners to manage orders, products, and customers efficiently.

## Features

- User Authentication (Devise)
- Dashboard
- Point of Sale
- Sale Records
- Product Management
- Responsive Design (Bootstrap)
- Pagination (Kaminari)
- File Uploads (Image Processing)
- Dynamic Forms (Cocoon)
- Data Grids (Datagrid)

## Getting Started

### Prerequisites

- Ruby 3.3.5
- Rails 7.2.1
- PostgreSQL (Native installed on your PC, if you want to use PostgreSQL on docker, please update your database configuration in file `config/database.yml`)

### Installation

1. Clone the repository:

  ```sh
  git clone https://github.com/yourusername/cafe-pos-system.git
  cd cafe-pos-system
  ```

2. Install dependencies:

  ```sh
  bundle install
  ```

3. Set up the database:

  ```sh
  rails db:create
  rails db:migrate
  rails db:seed
  ```

4. Start the Rails server:

  ```sh
  rails server
  ```

Open your browser and navigate to `http://localhost:3000`.

### Contributing
We welcome contributions to improve the Cafe POS System. To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch (git checkout -b feature-branch).
3. Make your changes and commit them (git commit -m 'Add new feature').
4. Push to the branch (git push origin feature-branch).
5. Create a new Pull Request.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Acknowledgements
- Ruby on Rails
- Bootstrap
- Devise

### Contact
For any inquiries or support, please contact vandysodanheang@gmail.com.