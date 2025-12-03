CLOUD EIGHT SPRAY PAINT | ONLINE SHOP DOCUMENTATION
===================================================

TEAM #67
Patrik Balazsy - patrikpbalazsy@gmail.com
Leo Cabral     - [Insert Email Here]


---------------------------------------------------------
1. SETUP & INSTALLATION
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


---------------------------------------------------------
2. WALKTHROUGH
---------------------------------------------------------

We focused our extra effort on the site's User Experience (UX).

- Landing Page: 'index.jsp' initializes the site with a "Hero-style" landing 
  page to establish the visual identity.

- Product Flow: Users are immediately greeted with product listings upon 
  entering the homepage. This intentional design creates an immediate shopping flow.

- Navigation: Users can scroll, search, or access utility features (like Login) easily.

- Interactions: 
  * Every listing features an "Add to Cart" button.
  * Clicking a listing reveals a "Product Detail" view.

The site is designed to feel intuitive with highly visible feature sets.


---------------------------------------------------------
3. TEST CREDENTIALS
---------------------------------------------------------

Use the following pre-existing user IDs and passwords for testing:

User ID      Password
----------   -----------
arnold       304Arnold!
bobby        304Bobby!
candace      304Candace!
darren       304Darren!
beth         304Beth!


---------------------------------------------------------
4. USE OF AI & EXTERNAL SOURCES
---------------------------------------------------------

[External Assets (Non-AI)]
- Hero Image: Sourced from Pexels.
- Site Framework: Based on COSC 304 Labs 6-9.
- Backend: Java development stream using JDBC for local SQL database connection.

[AI Implementation]
We utilized AI tools to enhance several areas of the project:

A. Image Generation
   - Tool: Gemini (Banana Nano Pro 3)
   - Usage: Generated 10+ high-quality images for products and the logo 
     using detailed prompts.
   - Log: https://gemini.google.com/u/1/app/f9dedcce85b33f45?pageId=none

B. Styling & SQL
   - Tool: Gemini Pro 3
   - Usage: 
     1. CSS: Modified global styles (styles.css) to ensure robust 
        responsiveness without manual coding.
     2. SQL DDL: Generated INSERT statements for all 40 products to 
        populate the database efficiently.
   - Log: https://gemini.google.com/u/1/app/256fd703a07c454d?pageId=none


---------------------------------------------------------
5. TO-DO
---------------------------------------------------------

[ ] Add feature marking
