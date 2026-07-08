# Wall Street Admin System

A Flask and PostgreSQL coursework project for a financial-admin style web application. The app supports customer signup/login, admin login by role, branch creation, HOD registration, product listing/upload, invoice entry, employee entry, and salary-payment invoice generation.

This repository is useful as a database-backed web application example, especially for showing how Flask routes can connect to PostgreSQL tables, functions, procedures, triggers, and views.

## What the Application Implements

The app has three main user flows:

1. Public customer flow: customers can sign up, sign in, and view products.
2. CEO/admin flow: admin users with type `CEO` can open branches, register HODs, upload products, manage invoices, and add employees.
3. HOD flow: admin users with type `HOD` can upload products, manage invoices, add employees, and sign out.

The project is not a production banking system. It is a DBMS class project focused on web forms, relational schema design, PostgreSQL routines, and simple admin workflows.

## Verified Tech Stack

- Python
- Flask
- PostgreSQL
- PL/pgSQL functions, procedures, triggers, and views
- `psycopg2` for direct PostgreSQL access
- `flask_sqlalchemy` is imported, although the current code mainly uses `psycopg2`
- HTML templates and CSS

## Repository Structure

```text
.
|-- main.py
|-- sqlquries.sql
|-- Wall Street Brokering System Documentation.pdf
|-- github-repo-link.txt
`-- templates/
    |-- index.html
    |-- ceo.html
    |-- hod.html
    |-- custumer.html
    |-- display_products.html
    |-- invoices.html
    |-- manage_invoices.html
    |-- open_branch.html
    |-- register_employee.html
    |-- register_hod.html
    |-- upload_products.html
    `-- style.css
```

The repository also contains a Python bytecode cache directory (`__pycache__/`) and a few empty or unused template files.

## Main Flask Routes

| Route | Method | Purpose |
| --- | --- | --- |
| `/` and `/home` | GET/POST | Render the main sign-in/sign-up page. |
| `/signupuser` | GET/POST | Insert a customer into `customers`. |
| `/signin` | POST | Validate a customer password through `GET_customers_PASS`. |
| `/signinadminpg` | GET | Switch the index page into admin sign-in mode. |
| `/signinadmin` | POST | Validate an admin user, update `current_login_user`, and route CEO/HOD users. |
| `/registerHOD` | GET | Show the HOD registration form. |
| `/signup_hod` | GET/POST | Insert an HOD into `adminusers`. |
| `/registerbranch` | GET | Show the branch creation form. |
| `/open_branch` | GET/POST | Insert a branch into `branch`. |
| `/add_products` | GET/POST | Add product/property records through the `add_products` SQL function. |
| `/display_products` | GET | Display all records from `products`. |
| `/invoice` | GET/POST | Add an invoice for the current user's branch. |
| `/invoices` | GET | Display records from the `current_invoice` view. |
| `/PaySal` | GET/POST | Call the `paysal` procedure for the current branch. |
| `/delete_hod` | POST | Delete an admin user unless the submitted id is `1`. |
| `/add_emp` | GET/POST | Insert an employee record. |

## Database Objects

The SQL file `sqlquries.sql` includes definitions and sample data for these objects:

### Tables

- `branch`
- `adminusers`
- `customers`
- `products`
- `description`
- `invoice`
- `employees`
- `backupadmin`
- `current_login_user`

### Functions and procedures

- `check_pass`
- `create_adminuser`
- `get_pass`
- `get_type`
- `GET_customers_PASS`
- `add_products`
- `add_invoice`
- `move_del`
- `paysal`
- `update_current_user`

### Trigger and view

- `movedata` trigger on `adminusers` deletion
- `current_invoice` view for invoices tied to the current login branch

## How the Data Flow Works

- Customer signup inserts directly into `customers`.
- Customer login calls `GET_customers_PASS(user_id)` and compares the returned password with the submitted value.
- Admin login calls `get_pass(user_id)` and `get_type(user_id)`, then stores the active admin in `current_login_user` through `update_current_user`.
- Product upload calls the `add_products(...)` PostgreSQL function.
- Invoice creation calls the `add_invoice(...)` procedure using the current admin user's branch.
- Salary payment calls `paysal(...)`, which is intended to sum employee salaries for a branch and create an invoice.

## Setup Notes

There is no `requirements.txt` in the repository. Install the Python packages manually:

```bash
python -m pip install flask flask-sqlalchemy psycopg2-binary
```

Create a local PostgreSQL database named exactly as expected in `main.py`:

```text
Wall-Street-Admin
```

`main.py` currently connects with hardcoded local credentials:

```python
database="Wall-Street-Admin"
user="postgres"
password="arsal"
host="localhost"
port="5432"
```

Update these values before running on another machine.

The SQL setup file is named `sqlquries.sql`. It contains the schema, functions, procedures, sample inserts, and some repeated or experimental statements. Review and run it carefully in PostgreSQL before starting the Flask app.

Run the app:

```bash
python main.py
```

Then open:

```text
http://localhost:5000
```

## Documentation Artifact

The repository includes `Wall Street Brokering System Documentation.pdf`, a 10-page project documentation file generated from Microsoft Word.

## Known Limitations

- Database credentials are hardcoded in `main.py`.
- SQL queries are built through string concatenation in multiple routes, so this code is not safe against SQL injection.
- Passwords are stored and compared as plain text.
- The SQL setup file contains repeated table definitions and development-history statements, so it may need manual cleanup before a fresh database setup.
- `paysal` appears to call `add_invoice(bid, ...)` even though the procedure parameter is named `b_id`; this may require correction before salary payment works reliably.
- There is no `requirements.txt`, migration script, seed script, or automated test suite.
- Some templates are empty or unused, and the UI is a simple coursework interface.

## Future Improvements

- Move database configuration into environment variables.
- Replace string-built SQL with parameterized queries.
- Hash passwords before storing them.
- Convert `sqlquries.sql` into a clean setup script or migration sequence.
- Add a `requirements.txt` file.
- Add route-level validation and error handling.
- Add tests for login, product upload, invoice creation, and salary payment.

## Authors

Developed as a DBMS coursework project by Ahmed Musharaf, Muhammad Arsal, and Saaim Ali Khan.
