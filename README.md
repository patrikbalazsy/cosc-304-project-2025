## Cloud Eight Spray Paint | Online Shop Documentation

Team #67

Patrik Balazsy patrikpbalazsy@gmail.com
Leo Cabral "email"

---------------------------------------------------------
## Setup

- clone the repo onto your local machine and run the following in terminal
git clone https://github.com/patrikbalazsy/cosc-304-project-2025

- navigate into the project root (depends on where you clone the repo)
cd cosc-304-project-2025
  
- make sure docker desktop is up and then start the container from project root
docker compose build (first time)
docker compose up -d

-To turn off late use
docker compose down

-Currently data must be manually loaded since we are not cloud hosting the page, run that in your browser
http://localhost/shop/loaddata.jsp

-Then access site 
http://localhost/shop/index.jsp

---------------------------------------------------------

## Walkthrough

We focused our extra effort on the sites user experience.
'''index.jsp''' starts by setting the site with a hero-style landing page and sets the vibe for the home page 

In the homepage the user is immediately greeted with product listings. This is intentional, and lets the site have flow.
The user can continue to scroll down, search, or access another feature like login

Each listing has an add card button, and the user can click on a listing to see more details

The site should feel intuitive and features are visible

---------------------------------------------------------

##Pre-existing user ids and passwords respectively;

'arnold' , '304Arnold!'
'bobby' , '304Bobby!'
'candace' , '304Candace!'
'darren' , '304Darren!'
'beth' , '304Beth!'

---------------------------------------------------------

## Use of AI and other sources

Non AI sources: Hero-Landing page image from pexels
Pre-existing site framework: COSC 304 labs 6-9
-The java pathway for development stream (Uses JDBC to connect to local SQL database)

We used AI in many area of our project

-Image creation: We used Gemini's latest Banana Nano Pro 3 to generate over 10 high quality images of our products and logo given detailed prompts
Link: https://gemini.google.com/u/1/app/f9dedcce85b33f45?pageId=none

-Styling + SQL DDL product insertion: We used Gemini Pro 3 to modify/enhance our global styles especially in styles.css. We specifically saved time here from having to manually 
  add robust responsiveness, and other styling elements to our site.
-Product Insertion: We also used Gemini Pro 3 to write insert statements since we didn't want to write them for all 40 products in the DDL.
Link: https://gemini.google.com/u/1/app/256fd703a07c454d?pageId=none

---------------------------------------------------------

## TO-DO:

Add feature marking
