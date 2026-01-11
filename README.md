The business requirements given are to create a custom page where users are able to perform three basic functions:
          Search
          View at inventory
          create reservations
Overall: This will be implementd using LWCs on a Lighting App Page, and customer facing through Experience.

 Search: For search, we will implement a design that allows users to search using Title, Author, ISBM number, and CUrrent invetory. These fields will also need to be fields within the Salesforce org under the Book Object. Imperative Apex herre
 View Inventory: For this requirement, we will implement imperastive Apex again, with pagination. We want to get 10 or 15 recordw with each click, so that the users ins't waiting for resuklts as we scale inveteory. 
 Create reservations: Requirements are very clear on relating Contacts to the Reservation object. We will implement a date picker. It will be ideal to have dates and times that aren't available already greyed out, but we will see if time permits this design. If not, we will
   check availability upon submission. 
