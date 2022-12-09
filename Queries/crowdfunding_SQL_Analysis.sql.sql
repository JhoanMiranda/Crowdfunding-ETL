CREATE TABLE "campaign" (
    "cf_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" varchar(100)   NOT NULL,
    "description" text   NOT NULL,
    "goal" numeric(10,2)   NOT NULL,
    "pledged" numeric(10,2)   NOT NULL,
    "outcome" varchar(50)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" varchar(10)   NOT NULL,
    "currency" varchar(10)   NOT NULL,
    "launch_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" varchar(10)   NOT NULL,
    "subcategory_id" varchar(10)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"
     )
);

CREATE TABLE "category" (
    "category_id" varchar(10)   NOT NULL,
    "category_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10)   NOT NULL,
    "subcategory_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);

CREATE TABLE "backers" (
	"backer_id" varchar(100) NOT NULL,
	"cf_id" int NOT NULL,
	"first_name" varchar(50) NOT NULL,
	"last_name" varchar(50) NOT NULL,
	"email" varchar(100) NOT NULL

);
DROP TABLE "backers";



ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

SELECT * FROM contacts;

SELECT * FROM campaign;

SELECT * FROM category;

SELECT * FROM subcategory;

SELECT * FROM backers;

-- Challenge Bonus queries.
-- 1. (2.5 pts)
-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 
SELECT (cf_id) cf_id,
		backers_count
FROM campaign as ca
	WHERE ca.outcome = ('live')	
GROUP BY ca.cf_id
ORDER BY ca.backers_count DESC
;

-- 2. (2.5 pts)
-- Using the "backers" table confirm the results in the first query.
SELECT  b.cf_id,
		ca.backers_count
FROM backers as b
INNER JOIN campaign as ca
ON (b.cf_id = ca.cf_id)
	WHERE ca.outcome = ('live')
GROUP BY (b.cf_id, ca.cf_id)
ORDER BY ca.backers_count DESC;

-- 3. (5 pts)
-- Create a table that has the first and last name, and email address of each contact.
-- and the amount left to reach the goal for all "live" projects in descending order. 

SELECT co.first_name,
	   co. last_name,
	   co.email, 
(ca.goal - ca.pledged) as  "Remaining Goal Amount"
INTO email_contacts_remaining_goal_amount
FROM contacts as co
INNER JOIN campaign as ca
ON (co.contact_id = ca.contact_id)
	WHERE ca.outcome = ('live')
ORDER BY (ca.goal - ca.pledged) DESC;






-- Check the table

SELECT * FROM email_contacts_remaining_goal_amount;

-- 4. (5 pts)
-- Create a table, "email_backers_remaining_goal_amount" that contains the email address of each backer in descending order, 
-- and has the first and last name of each backer, the cf_id, company name, description, 
-- end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 

SELECT ba.email,
       ba.first_name,
	   ba.last_name,
	   ca.cf_id,
	   ca.company_name,
	   ca.description,
	   ca.end_date,
	   (ca.goal - ca.pledged) as  "Left of Goal"
	   
INTO mail_backers_remaining_goal_amount
FROM campaign as ca
INNER JOIN backers as ba
ON (ca.cf_id = ba.cf_id)
INNER JOIN contacts as co
ON (ca.contact_id = co.contact_id)
ORDER BY ba.email DESC;


-- Check the table

SELECT * FROM mail_backers_remaining_goal_amount;

