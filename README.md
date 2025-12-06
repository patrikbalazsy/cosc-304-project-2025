CLOUD EIGHT SPRAY PAINT | ONLINE SHOP DOCUMENTATION
===================================================

Patrik B.
Leo C.

---------------------------------------------------------
SETUP & INSTALLATION
---------------------------------------------------------

[Step 1] Clone the Repository
Clone the repo onto your local machine and navigate into the project root:

    > git clone https://github.com/patrikbalazsy/cosc-304-project-2025
    > cd cosc-304-project-2025


[Step 2] Docker Configuration
Ensure Docker Desktop is running, then start the container from the project root.

    > docker compose build   (Run only on first setup)
    > docker compose up -d   (Start in detached mode)

    Note: To turn off later, use:
    > docker compose down


[Step 3] Load Data & Access
Since the application is not cloud-hosted, data must be manually loaded.

    1. Initialize Database: http://localhost/shop/loaddata.jsp
    2. Launch Site:         http://localhost/shop/index.jsp
