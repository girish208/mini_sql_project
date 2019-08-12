/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
/* Ans: SELECT *
FROM(SELECT name,
		CASE WHEN membercost >0 then 'CHARGEABLE'
		 	 ELSE 'no member cost' END AS chargeable_facilities
FROM country_club.Facilities)a
WHERE chargeable_facilities='CHARGEABLE'
 */


/* Q2: How many facilities do not charge a fee to members? */
/* SELECT 
		count(chargeable_facilities)
FROM(SELECT name,
		CASE WHEN membercost >0  then 'CHARGEABLE'
		 	 ELSE 'no member cost' END AS chargeable_facilities
FROM country_club.Facilities)a
WHERE chargeable_facilities='no member cost' */

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
/* SELECT *
FROM(SELECT name as facility_name,
     		facid as facility_id,
     		membercost,
     		monthlymaintenance
		
FROM country_club.Facilities)a
WHERE membercost<0.2*monthlymaintenance */

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
/* SELECT *
FROM `Facilities` 
WHERE facid in (1,5) */

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
/* SELECT name,
		monthlymaintenance,
		CASE WHEN monthlymaintenance>100 THEN 'expensive'
			ELSE 'cheap' END AS LABEL
FROM `Facilities` */

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
/* SELECT firstname,
		surname as lastname,
		joindate
		
FROM `Members`
ORDER BY joindate DESC*/

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
/* SELECT a.full_name,
		a.court_name
FROM (SELECT facilities.name as court_name,
		facilities.facid,
		booked.firstname,
		booked.surname,
		CONCAT(booked.firstname ,' ' , booked.surname) AS full_name
FROM (SELECT members.memid,
		members.surname,
		members.firstname,
		bookings.facid,
      	bookings.slots
FROM `Members` members
INNER JOIN country_club.Bookings bookings
ON members.memid=bookings.memid)booked
INNER JOIN country_club.Facilities facilities
ON booked.facid=facilities.facid
WHERE booked.firstname != 'GUEST')a
ORDER BY 1 */

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

/* SELECT *
FROM (SELECT CONCAT(members.firstname,' ',members.surname) as member_name,
		cost.starttime as bookings,
		cost.name as facility,
		CASE WHEN (cost.guestcost*cost.slots)>30 THEN (cost.guestcost*cost.slots)
			WHEN (cost.membercost*cost.slots>30) THEN (cost.membercost*cost.slots)
			ELSE NULL END AS game_cost
FROM(SELECT slot.starttime,
		slot.slots,
		facilities.guestcost,
		facilities.membercost,facilities.name,
		slot.memid
FROM `Bookings` slot
JOIN country_club.Facilities facilities
ON slot.facid=facilities.facid
WHERE slot.starttime like '2012-09-14%'
		)cost
JOIN country_club.Members members
ON cost.memid=members.memid
ORDER BY game_cost DESC) final
where final.game_cost>30 */
/* Q9: This time, produce the same result as in Q8, but using a subquery. */
/* SELECT *
FROM (SELECT CONCAT(members.firstname,' ',members.surname) as member_name,
		cost.starttime as bookings,
		cost.name as facility,
		CASE WHEN (cost.guestcost*cost.slots)>30 THEN (cost.guestcost*cost.slots)
			WHEN (cost.membercost*cost.slots>30) THEN (cost.membercost*cost.slots)
			ELSE NULL END AS game_cost
FROM(SELECT slot.starttime,
		slot.slots,
		facilities.guestcost,
		facilities.membercost,facilities.name,
		slot.memid
FROM `Bookings` slot
JOIN country_club.Facilities facilities
ON slot.facid=facilities.facid
WHERE slot.starttime like '2012-09-14%'
		)cost
JOIN country_club.Members members
ON cost.memid=members.memid
ORDER BY game_cost DESC) final
where final.game_cost>30 */


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/*
SELECT *
from(SELECT income.court_name,
		sum(income) as REVENUE
		
FROM(SELECT metrics.court_name,
		metrics.firstname,
		sum(slots),
		sum(CASE WHEN metrics.firstname='GUEST' THEN metrics.guestcost*slots
			ELSE metrics.membercost END) AS income,
     	metrics.initialoutlay,
     	metrics.monthlymaintenance
	
FROM(SELECT facilities.name as court_name,
		facilities.facid,
		booked.slots,
     	booked.firstname,
      facilities.membercost,
		facilities.guestcost,
		facilities.initialoutlay,
		facilities.monthlymaintenance
FROM (SELECT members.memid,
		members.surname,
		members.firstname,
		bookings.facid,
      	bookings.slots,
      bookings.starttime
FROM `Members` members
INNER JOIN country_club.Bookings bookings
ON members.memid=bookings.memid)booked
INNER JOIN country_club.Facilities facilities
ON booked.facid=facilities.facid
      GROUP BY 2,3)metrics
GROUP by 1,2)income
GROUP BY 1
ORDER BY 2)revenue
WHERE revenue.REVENUE<1000
*/