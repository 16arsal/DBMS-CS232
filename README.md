# Wall Street Admin System

This is a web-based administration system for managing various aspects of a financial institution, called "Wall Street Admin System". It allows users to perform tasks such as managing customers, employees, branches, products, invoices, and more.

## Features

- **User Authentication**: Allows users to sign up and sign in with their credentials.
- **Customer Management**: Admins can manage customer information including name, email, and contact details.
- **Employee Management**: Admins can add, delete, and update employee records including name, ID, branch, and salary.
- **Branch Management**: Admins can open new branches and register Head of Departments (HODs) for each branch.
- **Product Management**: Allows admins to add new products to the system including category, price, type, and location.
- **Invoice Management**: Admins can generate invoices for various transactions, including income and expenses.
- **Salary Payment**: Provides functionality to pay salaries to employees.
- **Interactive User Interface**: Offers a user-friendly web interface for easy navigation and interaction.

## Technologies Used

- **Flask**: Python web framework used for building the backend server.
- **SQLAlchemy**: SQL toolkit and Object-Relational Mapping (ORM) library used for database interactions.
- **PostgreSQL**: Relational database management system used for storing application data.
- **HTML/CSS**: Frontend languages used for designing and styling web pages.
- **JavaScript**: Frontend language used for adding interactivity to web pages.
- **psycopg2**: PostgreSQL adapter for Python used for database connectivity.

## Setup Instructions

1. Clone the repository to your local machine.
2. Install Python 3.x and PostgreSQL if not already installed.
3. Install the required Python packages using `pip install -r requirements.txt`.
4. Create a PostgreSQL database named "Wall-Street-Admin".
5. Update the `app.py` file with your PostgreSQL database credentials.
6. Run the Flask application using `python app.py`.
7. Open your web browser and navigate to `http://localhost:5000` to access the application.

## Contribution

Contributions are welcome! If you find any bugs or want to add new features, feel free to open an issue or submit a pull request.

