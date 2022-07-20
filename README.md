# Fringer - CollectionView - CoreData - MKMapView 
## **Features:**
#### Splash page showing an image of the Adelaide Fringe
When user open the application, a splash page will be displayed with logo of Fringe Festival. Then a Main Menu will display as a Table View for user to access the other features of the application.
#### Copyright/About Page
This page displays the information of student and disclaimer, access via the main menu of the application
#### List of the provided Fringe events downloaded from an online database using an API
This function is accessed via main menu, a list of events will be display as a Collection View
The Data Manager class is where the JSON data is downloaded and save in Core Data as an array of Events.
#### Display details of a Fringe event
![alt text](https://github.com/UyenTran218/Swift-Collection-View-Core-Data-MKMapView/blob/master/ezgif.com-gif-maker.gif?raw=true)

When user tap on an event in the Collection View, a detail page will display event information such as name, like, dislike number, venues, description and artist.
The Detail Page is implemented via the Cell of the Collection View, which got the current index path. 
#### Marking an event as interested
User can add an event into their favourite event list by tapping on the star button at the top of the detail view, the data will be saved in Core Data, they can delete it from the list by click on the tag again or head to Browse event and swipe left
The event will be added into the favourites array and save on Core Data. 
#### Show a series of Fringe events so that the user can swipe right if they like a show or swipe left if they don't, swiping up indicates that they wish to attend.
User access this feature from main menu, they can browse the events and swipe right to add to Favorite, swipe left to delete from Favourite and swipe up to input their email to register interest in attending an event
This function is implemented with a third-party library called Shuffle which helps creating and displaying the Swipeable Card. 
#### Display a map with the location of venues in Adelaide, connect the individual events so that people can see where a given event will be held
User access this feature via main menu by clicking on Venues option, the application will ask for permission to access user location and then show Venues with their corresponding events
Using Map Kit to display the Map View and create annotations. In Data Manager, Venues location is downloaded and save to Core Data. The longitude and latitude are used to create the annotation, then event name is displayed with the venue where it is held by a searching event function.
#### Upload Likes/Dislikes, send one like or dislike per show
In the Detail View, users can like or dislike an event and the like/dislike number will be updated.
User can like or dislike an event in its detail view, the API will be called to increase/decrease the like/dislike number and will be updated back to the view.
#### Express Interest in Attending by swiping up
User can select Browsing from Main menu to swipe up and register their interest in attending an event, a popup window will ask user to input email address and confirm to users they have registered.
In the Browsing View, user can swipe up and an fill out a text field with their email, this will trigger a function to call API and return the success result.
